import {Worker,isMainThread,parentPort} from 'node:worker_threads';
import fs from 'node:fs';
import {protocol as core} from '../web/engine.mjs';
if(isMainThread) {
  const worker=new Worker(new URL(import.meta.url));
  const timer=setTimeout(()=>{worker.terminate();console.error('Protocol fuzz deadline');process.exitCode=1;},20000);
  worker.on('message',value=>{clearTimeout(timer);fs.writeFileSync(new URL('../evidence/protocol-robustness.json',import.meta.url),JSON.stringify(value,null,2)+'\n');console.log(JSON.stringify(value));});
  worker.on('error',error=>{clearTimeout(timer);console.error(error);process.exitCode=1;});
}else {
  let seed=59057822,accepted=0,rejected=0,cases=0;
  const random=()=>{seed^=seed<<13;seed^=seed>>>17;seed^=seed<<5;return seed>>>0;};
  const run=input=>{
    const result=JSON.parse(core(input));cases++;
    if(typeof result.ok!=='boolean'||(!result.ok&&typeof result.error!=='string'))throw Error('Malformed protocol result');
    result.ok?accepted++:rejected++;return result;
  };
  for(const input of ['','{','null','[]','1','"\ud800"','x'.repeat(300001),JSON.stringify({op:'__proto__'})])
    if(run(input).ok)throw Error('Invalid input accepted');
  for(let i=0;i<1024;i++) {
    const packet=Buffer.alloc(random()%600);for(let j=0;j<packet.length;j++)packet[j]=random()&255;
    run(JSON.stringify({op:'decode',hex:packet.toString('hex'),macLength:[0,4,20,24][random()%4]}));
  }
  // Valid maximum extension count roundtrips; every truncation rejects.
  const header='23'+'00'.repeat(47),extensions=Array.from({length:64},(_,i)=>({type:0x1234+i,valueHex:'00'.repeat(i===63?24:12)}));
  const encoded=run(JSON.stringify({op:'encode',headerHex:header,extensions}));if(!encoded.ok)throw Error(encoded.error);
  const decoded=run(JSON.stringify({op:'decode',hex:encoded.value}));if(decoded.value.extensions.length!==64)throw Error('Lost extension');
  for(let i=1;i<28;i++)if(run(JSON.stringify({op:'decode',hex:encoded.value.slice(0,-i*2)})).ok)throw Error('Truncated extension accepted');
  if(run(JSON.stringify({op:'encode',headerHex:header,extensions:[...extensions,extensions[63]]})).ok)throw Error('Extension limit missing');
  parentPort.postMessage({seed:59057822,cases,accepted,rejected,uncaught:0,scope:'Bounded protocol/parser mutation and extension framing checks, not a conformance proof.'});
}
