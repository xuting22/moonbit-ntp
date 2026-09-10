import {run} from '../web/engine.mjs';import config from '../web/config.mjs';import fs from 'node:fs';import os from 'node:os';
const expected=run(config.example);if(expected.startsWith('ERROR:'))throw Error(expected);
for(let i=0;i<5;i++)run(config.example);
const times=[];for(let i=0;i<30;i++){const start=performance.now();if(run(config.example)!==expected)throw Error('Non-deterministic output');times.push(performance.now()-start)}times.sort((a,b)=>a-b);
const record={project:config.slug,utc:new Date().toISOString(),runtime:process.version,platform:process.platform,cpu:os.cpus()[0]?.model,input_utf8_bytes:Buffer.byteLength(config.example),samples:30,warmup:5,median_ms:times[15],p95_ms:times[28],max_ms:times[29],scope:'JS warm execution of documented example; no cross-project or upstream performance claim'};
fs.writeFileSync(new URL('../evidence/benchmark.json',import.meta.url),JSON.stringify(record,null,2));console.log(JSON.stringify(record));
