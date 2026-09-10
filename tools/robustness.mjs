import {Worker,isMainThread,parentPort,workerData} from 'node:worker_threads';
import fs from 'node:fs';import {fileURLToPath} from 'node:url';import {run} from '../web/engine.mjs';import config from '../web/config.mjs';
if(isMainThread){
 const worker=new Worker(new URL(import.meta.url),{workerData:true});const timer=setTimeout(()=>{worker.terminate();console.error('bounded robustness run exceeded 20s');process.exitCode=1},20000);
 worker.on('message',report=>{clearTimeout(timer);fs.writeFileSync(new URL('../evidence/robustness.json',import.meta.url),JSON.stringify(report,null,2));console.log(config.slug+': '+report.cases+' bounded inputs, no uncaught runtime failure')});
 worker.on('error',e=>{clearTimeout(timer);console.error(e);process.exitCode=1});
}else{
 let state=20260910;const rng=()=>{state=(Math.imul(state,1664525)+1013904223)>>>0;return state};
 const alphabet='0123456789 abcdef{}[]()<>$;:\\"\n\r\t+-*/,=&!汉字';
 const cases=['','\0','\ud800','\udfff',' '.repeat(4096),'('.repeat(96)+')'.repeat(96),config.example];
 for(let i=0;i<300;i++){let s='';for(let j=0,n=rng()%100;j<n;j++)s+=alphabet[rng()%alphabet.length];cases.push(s)}
 let errors=0;
 for(const input of cases){let result;try{result=run(input)}catch(e){throw Error('uncaught exception on '+JSON.stringify(input)+': '+e)}if(typeof result!=='string')throw Error('non-string output');if(result.startsWith('ERROR:'))errors++}
 parentPort.postMessage({project:config.slug,seed:20260910,cases:cases.length,expected_error_responses:errors,uncaught_exceptions:0,scope:'bounded malformed-input robustness, not proof of full language/protocol conformance'});
}
