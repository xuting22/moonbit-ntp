import fs from 'node:fs';
import {run} from '../web/engine.mjs';
const args=process.argv.slice(2);let input, json=false;
try {
 for(let i=0;i<args.length;i++){
  const a=args[i];
  if(a==='--help'){process.stdout.write('Usage: node tools/cli.mjs [--input TEXT | --file PATH] [--json]\nWithout --input/--file, reads UTF-8 stdin. Exit: 0 success, 2 invalid input, 1 host error.\n');process.exit(0)}
  else if(a==='--json')json=true;
  else if(a==='--input'||a==='--file'){
   if(input!==undefined||i+1>=args.length)throw new Error('Exactly one input source is required');
   const value=args[++i];
   if(a==='--file'){if(fs.statSync(value).size>2097152)throw new Error('Input exceeds 2 MiB');input=fs.readFileSync(value,'utf8')}else input=value;
  }else throw new Error('Unknown argument: '+a);
 }
 if(input===undefined){let size=0;const chunks=[];for await(const chunk of process.stdin){size+=chunk.length;if(size>2097152)throw new Error('Input exceeds 2 MiB');chunks.push(chunk)}input=Buffer.concat(chunks).toString('utf8')}
 if(Buffer.byteLength(input)>2097152)throw new Error('Input exceeds 2 MiB');
 const output=run(input),ok=!output.startsWith('ERROR:');
 process.stdout.write(json?JSON.stringify({ok,output})+'\n':output+(output.endsWith('\n')?'':'\n'));
 process.exitCode=ok?0:2;
}catch(e){process.stderr.write(JSON.stringify({ok:false,error:String(e.message||e)})+'\n');process.exitCode=1}
