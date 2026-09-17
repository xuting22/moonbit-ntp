import assert from 'node:assert/strict';
import dgram from 'node:dgram';
import http from 'node:http';
import {once} from 'node:events';
import fs from 'node:fs/promises';
import {startServer} from './serve.mjs';
import {ClockFilter} from './protocol.mjs';

const host=await startServer({port:0}),udp=dgram.createSocket('udp4'),groups=[];
let silent=false;
udp.on('message',(request,remote)=>{
  if(silent)return;
  const reply=Buffer.alloc(48),unix=Date.now()/1000;
  reply[0]=36;reply[1]=2;reply[3]=236;request.copy(reply,24,40,48);
  for(const [at,value] of [[16,unix-1],[32,unix],[40,unix]]) {
    const whole=Math.floor(value);
    reply.writeUInt32BE((whole+2208988800)>>>0,at);reply.writeUInt32BE(Math.floor((value-whole)*2**32),at+4);
  }
  udp.send(reply,remote.port,remote.address);
});
udp.bind(0,'127.0.0.1');await once(udp,'listening');
const address='127.0.0.1:'+udp.address().port;
const post=(path,value,options={})=>fetch(host.url+path,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(value),...options});
const group=async(name,fn)=>{await fn();groups.push(name);};
const active=async()=> (await (await fetch(host.url+'/api/status')).json()).activeJobs;
async function until(fn) {for(let i=0;i<100;i++){if(await fn())return;await new Promise(r=>setTimeout(r,10));}throw Error('Condition deadline');}
try {
  await group('Static whitelist, MIME/CSP and origin/Host checks',async()=>{
    const page=await fetch(host.url+'/web/');assert.equal(page.status,200);assert.match(await page.text(),/时间观测台/);
    assert.match(page.headers.get('content-security-policy'),/frame-ancestors 'none'/);
    assert.match((await fetch(host.url+'/web/worker.mjs')).headers.get('content-type'),/javascript/);
    for(const p of ['/.git/config','/tools/auth.mjs','/web/..%2f.git/config'])assert.equal((await fetch(host.url+p)).status,404);
    assert.equal((await post('/api/query',{server:address},{headers:{'Content-Type':'application/json',Origin:'https://example.invalid'}})).status,403);
    const code=await new Promise((resolve,reject)=>{
      const req=http.get(host.url+'/api/status',{headers:{Host:'example.invalid'}},res=>{res.resume();resolve(res.statusCode);});req.on('error',reject);
    });assert.equal(code,403);
  });
  await group('Real HTTP to UDP query and eight streamed filter rounds',async()=>{
    const q=await post('/api/query',{server:address});assert.equal(q.status,200);assert.equal((await q.json()).value.stratum,2);
    const r=await post('/api/sample',{servers:[address],options:{rounds:8,intervalMs:1,respectPoll:false}});
    assert.match(r.headers.get('content-type'),/ndjson/);
    const rows=(await r.text()).trim().split('\n').map(JSON.parse);
    assert.equal(rows.length,9);assert.equal(rows.at(-1).type,'done');
    assert.equal(rows[7].sources[0].estimate.validSamples,8);assert.ok(rows[7].consensus);
  });
  await group('Body, schema, round, destination-count and timeout limits',async()=>{
    assert.equal((await post('/api/query',{}, {body:'x'.repeat(20000)})).status,413);
    assert.equal((await post('/api/query',{}, {headers:{'Content-Type':'text/plain'}})).status,415);
    for(const value of [{servers:[]},{servers:Array(9).fill(address)},{servers:[address],options:{rounds:33}},
      {servers:[address],options:{queryOptions:{timeoutMs:10001}}},{servers:[address],options:{clock:1}}])
      assert.equal((await post('/api/sample',value)).status,400);
    assert.equal((await post('/api/query',{server:address,options:{auth:{type:'BAD',key:'secret',keyID:1}}})).status,400);
    assert.equal(await active(),0);
  });
  await group('Disconnect during poll wait stops job and restores filter capacity',async()=>{
    const control=new AbortController();
    const response=await post('/api/sample',{servers:[address],options:{rounds:8,intervalMs:64000}},{signal:control.signal});
    const reader=response.body.getReader();assert.match(new TextDecoder().decode((await reader.read()).value),/"round":1/);
    assert.equal(await active(),1);control.abort();await reader.cancel().catch(()=>{});
    await until(async()=>await active()===0);
    const filters=[];try{for(let i=0;i<256;i++)filters.push(new ClockFilter());}finally{filters.forEach(f=>f.close());}
  });
  await group('Four pending queries saturate slots; abort releases all slots',async()=>{
    silent=true;const controllers=Array.from({length:4},()=>new AbortController());
    const requests=controllers.map(c=>post('/api/query',{server:address,options:{timeoutMs:10000}},{signal:c.signal}).catch(()=>null));
    await until(async()=>await active()===4);
    assert.equal((await post('/api/query',{server:address})).status,429);
    controllers.forEach(c=>c.abort());await Promise.all(requests);await until(async()=>await active()===0);silent=false;
    assert.equal((await post('/api/query',{server:address})).status,200);
  });
  await fs.writeFile(new URL('../evidence/http-validation.json',import.meta.url),JSON.stringify({runtime:process.version,passed:groups.length,groups},null,2)+'\n');
  console.log(JSON.stringify({passed:groups.length,groups}));
}finally {
  await host.close();await new Promise(resolve=>udp.close(resolve));
}
