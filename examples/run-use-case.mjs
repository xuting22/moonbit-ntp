#!/usr/bin/env node
// Convenience recipe runner only. It is not counted as the project's core contribution.
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import {spawnSync} from 'node:child_process';
import {fileURLToPath} from 'node:url';
import {createHash} from 'node:crypto';
const root=fileURLToPath(new URL('../',import.meta.url));
const recipe=JSON.parse(fs.readFileSync(new URL('./use-case.json',import.meta.url),'utf8'));
const output=fs.mkdtempSync(path.join(os.tmpdir(),'moonbit-use-case-'));
const results=[];
for(const step of recipe.steps){
  const args=step.args.map(a=>a.replaceAll('{out}',output));
  const input=step.stdinFile?fs.readFileSync(path.join(root,step.stdinFile)):undefined;
  const result=spawnSync(process.execPath,args,{cwd:root,input,encoding:'utf8',timeout:60000,maxBuffer:4*1024*1024,windowsHide:true});
  const n=results.length+1;
  fs.writeFileSync(path.join(output,`step-${n}.stdout.txt`),result.stdout??'');
  fs.writeFileSync(path.join(output,`step-${n}.stderr.txt`),result.stderr??'');
  results.push({args,exit:result.status,error:result.error?.message,stdinSha256:input?createHash('sha256').update(input).digest('hex'):undefined});
  if(result.status!==0){process.exitCode=1;break;}
}
const report={title:recipe.title,scope:recipe.scope,expected:recipe.expected,output,ok:!process.exitCode,results};
fs.writeFileSync(path.join(output,'report.json'),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify(report,null,2));
