import assert from 'node:assert/strict';
import dgram from 'node:dgram';
import {once} from 'node:events';
import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import {spawn} from 'node:child_process';
import {fileURLToPath} from 'node:url';
import {createAuthenticator} from './auth.mjs';
import {query,parseAddress} from './udp-client.mjs';
import {ClockFilter,protocol} from './protocol.mjs';
import {sampleServers} from './sampler.mjs';

const root=fileURLToPath(new URL('../',import.meta.url)),groups=[],sockets=[];
const temporary=await fs.mkdtemp(path.join(os.tmpdir(),'ntp-sync-'));
async function group(name,work) {await work();groups.push(name);}
function timestamp(b,at,unix) {
  const whole=Math.floor(unix);
  b.writeUInt32BE((whole+2208988800)>>>0,at);
  b.writeUInt32BE(Math.floor((unix-whole)*2**32)>>>0,at+4);
}
async function server({auth,offset=0,rootDispersion=0,edit,silent=false}={}) {
  const socket=dgram.createSocket('udp4'),signer=auth&&createAuthenticator(auth);
  let requests=0;
  socket.on('error',()=>{});
  socket.on('message',(request,remote)=>{
    requests++;
    if(silent)return;
    if(signer) {try{signer.verify(request);}catch{return;}}
    const b=Buffer.alloc(48),now=Date.now()/1000+offset;
    b[0]=36;b[1]=2;b[2]=0;b[3]=236;
    b.writeUInt32BE(Math.round(rootDispersion*65536),8);
    request.copy(b,24,40,48);
    timestamp(b,16,now-1);timestamp(b,32,now);timestamp(b,40,now);
    let reply=edit?.(b,request)??b;
    if(signer)reply=signer.sign(reply);
    socket.send(reply,remote.port,remote.address);
  });
  socket.bind(0,'127.0.0.1');await once(socket,'listening');sockets.push(socket);
  return {address:'127.0.0.1:'+socket.address().port,socket,count:()=>requests};
}
const cli=(args)=>new Promise((resolve,reject)=>{
  const child=spawn(process.execPath,[path.join(root,'tools/ntp.mjs'),...args],{windowsHide:true});
  const out=[],err=[];let size=0;
  const timer=setTimeout(()=>{child.kill();reject(Error('CLI test deadline'));},10000);
  child.stdout.on('data',b=>{size+=b.length;if(size>2000000){child.kill();reject(Error('CLI output limit'));}out.push(b);});
  child.stderr.on('data',b=>err.push(b));
  child.on('error',error=>{clearTimeout(timer);reject(error);});
  child.on('exit',(code,signal)=>{clearTimeout(timer);resolve({code,signal,out:Buffer.concat(out),err:Buffer.concat(err)});});
});
try {
  await group('Official Go MAC captures validate bytes, padding and key rejection',async()=>{
    const record=JSON.parse(await fs.readFile(new URL('../evidence/reference-comparison.json',import.meta.url),'utf8'));
    const rows=record.rows.filter(row=>row.input.kind==='auth');
    assert.equal(rows.length,54);
    for(const row of rows) {
      if(row.reference.error) {assert.throws(()=>createAuthenticator(row.input.auth));continue;}
      const auth=createAuthenticator(row.input.auth),wire=Buffer.from(row.reference.requestHex,'hex');
      auth.verify(wire);
      assert.deepEqual(auth.sign(wire.subarray(0,-auth.macLength)),wire);
      wire[wire.length-1]^=1;
      assert.throws(()=>auth.verify(wire),/authentication failed/);
    }
    assert.throws(()=>createAuthenticator({type:'__proto__',key:'ASCII:abcdefghijklmnop',keyID:1}),/Invalid/);
  });
  await group('Actual UDP authenticates six algorithms and sends extension fields',async()=>{
    for(const [type,size] of [['MD5',16],['SHA1',20],['SHA256',20],['SHA512',20],['AES128',16],['AES256',32]]) {
      const auth={type,key:'HEX:'+'45'.repeat(size),keyID:55};
      const fixture=await server({auth,edit:(reply,request)=>{assert.equal(request.readUInt16BE(48),0x1234);return reply;}});
      const result=await query(fixture.address,{auth,extensions:[{type:0x1234,valueHex:'00'.repeat(16)}],timeoutMs:500});
      assert.equal(result.authenticated,true);
      assert.equal(result.authentication.type,type);
      await assert.rejects(query(fixture.address,{auth:{...auth,keyID:56},timeoutMs:20}),/timeout/);
    }
  });
  await group('Required MAC rejects missing authentication; malformed input fails before transport',async()=>{
    const fixture=await server();
    const auth={type:'AES128',key:'ASCII:abcdefghijklmnop',keyID:5};
    await assert.rejects(query(fixture.address,{auth}),/authentication failed/);
    for(const options of [{unknown:1},{version:1},{signal:{}},{now:3},{socketFactory:3},
      {extensions:[{type:1,valueHex:'abcd'}]}])
      await assert.rejects(query(fixture.address,options));
    assert.deepEqual(parseAddress('[::1]:443'),{host:'::1',port:443});
    assert.deepEqual(parseAddress('::1'),{host:'::1',port:123});
    assert.throws(()=>parseAddress('host:NaN'));
  });
  await group('Multi-source sampling warms eight stages and removes one false clock',async()=>{
    const fixtures=[];
    for(const offset of [.01,.02,.03,1])fixtures.push(await server({offset,rootDispersion:.05}));
    const rounds=[];
    for await(const value of sampleServers(fixtures.map((s,i)=>({id:'clock'+i,address:s.address})),
      {rounds:8,intervalMs:2,respectPoll:false,concurrency:2,minimum:3,queryOptions:{timeoutMs:500}}))rounds.push(value);
    assert.equal(rounds.length,8);
    const last=rounds.at(-1);
    assert.notEqual(last.consensus,null,JSON.stringify(last.sources));
    assert.deepEqual(last.consensus.survivors.slice().sort(),['clock0','clock1','clock2']);
    assert.ok(Math.abs(last.consensus.offsetSeconds-.02)<.05);
    assert.ok(last.sources.every(s=>s.estimate.validSamples===8&&s.estimate.reach===255));
  });
  await group('Advertised polling and authenticated KoD backoff prevent repeated requests',async()=>{
    const plain=await server();
    for await(const value of sampleServers([plain.address],{rounds:3,intervalMs:2}))assert.ok(value);
    assert.equal(plain.count(),1);
    for(const code of ['RATE','DENY','RSTR']) {
      const auth={type:'AES128',key:'ASCII:abcdefghijklmnop',keyID:5};
      const fixture=await server({auth,edit:b=>{
        b[1]=0;b.write(code,12);b.fill(0,16,24);b.fill(0,32,48);return b;
      }});
      const rows=[];
      for await(const value of sampleServers([{address:fixture.address,options:{auth}}],
        {rounds:3,intervalMs:2,respectPoll:false}))rows.push(value);
      assert.equal(fixture.count(),1);
      assert.equal(rows[0].observations[0].error.kissCode,code);
      assert.equal(rows[0].consensus,null);
    }
  });
  await group('Abort releases pending UDP queries and every core filter handle',async()=>{
    const silent=await server({silent:true}),control=new AbortController();
    const promise=(async()=>{for await(const value of sampleServers([silent.address],
      {rounds:8,intervalMs:1,signal:control.signal,queryOptions:{timeoutMs:5000}}))assert.ok(value);})();
    const timer=setTimeout(()=>control.abort(),10);
    await assert.rejects(promise,/aborted/);clearTimeout(timer);
    const handles=[];
    try{for(let i=0;i<256;i++)handles.push(new ClockFilter());assert.throws(()=>new ClockFilter(),/limit/);}
    finally{handles.forEach(h=>h.close());}
    await assert.rejects(async()=>{for await(const value of sampleServers([silent.address,silent.address]))assert.ok(value);},/Duplicate/);
  });
  await group('Protocol rejects invalid MAC framing and malformed session requests',async()=>{
    const header=Buffer.alloc(48);header[0]=35;
    for(const length of [1,4,12,16,20,24]) {
      const packet=Buffer.concat([header,Buffer.alloc(length)]);
      assert.throws(()=>protocol({op:'decode',hex:packet.toString('hex')}));
    }
    const field=Buffer.alloc(28);field.writeUInt16BE(0x1234);field.writeUInt16BE(28,2);
    const wire=Buffer.concat([header,field]);
    assert.equal(protocol({op:'decode',hex:wire.toString('hex')}).extensions[0].type,0x1234);
    assert.throws(()=>protocol({op:'decode',hex:wire.toString('hex'),other:1}),/unknown/);
    const filter=new ClockFilter();
    try{assert.throws(()=>filter.observe({offsetSeconds:NaN,delaySeconds:0,dispersionSeconds:0,receivedAt:1}));}
    finally{filter.close();}
  });
  await group('Real CLI query/auth-file/sample/decode and input failures',async()=>{
    const auth={type:'AES128',key:'ASCII:abcdefghijklmnop',keyID:5},fixture=await server({auth});
    const authFile=path.join(temporary,'auth.json');await fs.writeFile(authFile,JSON.stringify(auth));
    const result=await cli(['query',fixture.address,'--auth-file',authFile]);
    assert.equal(result.code,0,result.err.toString());
    assert.equal(JSON.parse(result.out).authenticated,true);
    const sample=await cli(['sample',fixture.address,'--auth-file',authFile,'--rounds','5','--interval','1','--no-poll-wait']);
    assert.equal(sample.code,0,sample.err.toString());
    assert.equal(sample.out.toString().trim().split('\n').map(JSON.parse).length,5);
    const hexFile=path.join(temporary,'packet.txt');await fs.writeFile(hexFile,'23'+'00'.repeat(47));
    const decoded=await cli(['decode','--file',hexFile]);assert.equal(decoded.code,0);assert.equal(JSON.parse(decoded.out).header.version,4);
    const invalid=path.join(temporary,'invalid.json');await fs.writeFile(invalid,Buffer.from([255]));
    assert.equal((await cli(['query',fixture.address,'--auth-file',invalid])).code,1);
    assert.equal((await cli(['query',fixture.address,'--rounds','1'])).code,1);
    assert.equal((await cli(['sample',fixture.address,'--rounds','0'])).code,1);
    const large=path.join(temporary,'large.json');
    const handle=await fs.open(large,'w');await handle.truncate(1024*1024*1024);await handle.close();
    const oversized=await cli(['replay','--file',large]);
    assert.equal(oversized.code,1);assert.match(oversized.err.toString(),/exceeds 2 MiB/);
    assert.equal((await cli(['replay','--file',temporary])).code,1);
    assert.equal((await cli(['sample',fixture.address,'--no-poll-wait','--no-poll-wait'])).code,1);
  });
  await fs.writeFile(new URL('../evidence/sync-host-validation.json',import.meta.url),
    JSON.stringify({runtime:process.version,passed:groups.length,groups},null,2)+'\n');
  console.log(JSON.stringify({passed:groups.length,groups}));
}finally {
  for(const socket of sockets)await new Promise(resolve=>socket.close(resolve));
  const real=await fs.realpath(temporary),base=await fs.realpath(os.tmpdir());
  if(path.dirname(real).toLowerCase()!==base.toLowerCase()||!path.basename(real).startsWith('ntp-sync-'))throw Error('Unsafe test cleanup');
  await fs.rm(real,{recursive:true,force:true});
}
