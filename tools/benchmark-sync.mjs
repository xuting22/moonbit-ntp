import fs from 'node:fs';
import os from 'node:os';
import {createHash} from 'node:crypto';
import {protocol} from './protocol.mjs';
const rows=JSON.parse(fs.readFileSync(new URL('../evidence/reference-comparison.json',import.meta.url))).rows.filter(r=>r.input.kind==='response');
const requests=rows.map(({input,reference})=>{
  const packet=Buffer.from(input.replyHex,'hex'),sent=Buffer.from(reference.requestHex,'hex').subarray(0,48);
  sent.copy(packet,24,40,48);
  return {op:'analyze',sentHex:sent.toString('hex'),sentUnix:input.sentUnix,receivedUnix:input.receivedUnix,replyHex:packet.toString('hex'),validate:false};
});
const peers=Array.from({length:64},(_,i)=>({id:'p'+String(i).padStart(2,'0'),offsetSeconds:Math.sin(i)*.05,
  rootDistanceSeconds:.1+i*.001,jitterSeconds:.00001,stratum:2}));
const workloads=[
  {name:'102 rich packet analyses including era boundaries',operations:102,run:()=>{for(const request of requests)protocol(request);}},
  {name:'64-source selection and clustering down to three',operations:1,run:()=>{if(protocol({op:'combine',peers,minimum:3}).survivors.length!==3)throw Error('Unexpected clustering result');}},
];
const measurements=workloads.map(work=>{
  for(let i=0;i<5;i++)work.run();
  const samples=[];
  for(let i=0;i<30;i++){const start=performance.now();work.run();samples.push(performance.now()-start);}
  samples.sort((a,b)=>a-b);
  return {name:work.name,operations:work.operations,warmups:5,samples:30,medianMs:samples[15],p95Ms:samples[28],maxMs:samples[29]};
});
const report={runtime:process.version,cpu:os.cpus()[0]?.model,platform:process.platform,
  engineSHA256:createHash('sha256').update(fs.readFileSync(new URL('../web/engine.mjs',import.meta.url))).digest('hex'),
  scope:'Local warm JS engine plus JSON bridge, no network. Single process wall time; no upstream performance equivalence claim.',measurements};
fs.writeFileSync(new URL('../evidence/sync-benchmark.json',import.meta.url),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify(measurements));
