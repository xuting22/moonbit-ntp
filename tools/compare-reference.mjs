import fs from 'node:fs';
import {spawnSync} from 'node:child_process';
import {createHash} from 'node:crypto';
import {protocol} from './protocol.mjs';
import {createAuthenticator} from './auth.mjs';

const file=new URL('./reference-cases.json',import.meta.url);
const raw=fs.readFileSync(file),cases=JSON.parse(raw);
const replay=process.argv.includes('--replay');
const recorded=replay?JSON.parse(fs.readFileSync(new URL('../evidence/reference-comparison.json',import.meta.url),'utf8')):null;
if(recorded&&recorded.casesSHA256!==createHash('sha256').update(raw).digest('hex'))throw Error('Reference input hash changed');
const command=JSON.parse(process.env.NTP_REFERENCE_COMMAND_JSON??'["ntp-probe"]');
if(!Array.isArray(command)||!command.length||command.some(s=>typeof s!=='string'))
  throw Error('Invalid reference command');
const result=replay?{status:0,stdout:Buffer.from(recorded.rows.map(r=>JSON.stringify(r.reference)).join('\n')),stderr:Buffer.alloc(0)}:spawnSync(command[0],command.slice(1),{
  input:cases.map(c=>JSON.stringify(c)).join('\n')+'\n',
  timeout:30000,maxBuffer:8000000,windowsHide:true,
});
if(result.status!==0)throw Error(result.stderr?.toString()??String(result.error));
const references=result.stdout.toString().trim().split('\n').map(JSON.parse);
if(references.length!==cases.length)throw Error('Reference output count mismatch');
const rows=cases.map((input,index)=>{
  const reference=references[index],differences=[];
  let actual,error;
  try {
    if(input.kind==='auth') {
      const auth=createAuthenticator(input.auth);
      if(reference.error)differences.push({field:'key acceptance',reference:reference.error,actual:'accepted'});
      else {
        const wire=Buffer.from(reference.requestHex,'hex');
        auth.verify(wire);
        const rebuilt=auth.sign(wire.subarray(0,-auth.macLength));
        if(!rebuilt.equals(wire))differences.push({field:'MAC bytes',reference:reference.requestHex,actual:rebuilt.toString('hex')});
        const corrupted=Buffer.from(wire);corrupted[corrupted.length-1]^=1;
        let rejected=false;try{auth.verify(corrupted);}catch{rejected=true;}
        if(!rejected)differences.push({field:'tampered MAC',actual:'accepted'});
        actual={macMatched:rebuilt.equals(wire),tamperRejected:rejected};
      }
    }else {
      const reply=Buffer.from(input.replyHex,'hex'),sent=Buffer.from(reference.requestHex,'hex').subarray(0,48);
      if(sent.length!==48)throw Error('Reference did not construct a request');
      sent.copy(reply,24,40,48);
      actual=protocol({op:'analyze',sentHex:sent.toString('hex'),sentUnix:input.sentUnix,
        receivedUnix:input.receivedUnix,replyHex:reply.toString('hex'),validate:false});
      const flat={...actual,...actual.header};
      if(reference.error)differences.push({field:'query acceptance',reference:reference.error,actual:'accepted'});
      else for(const [key,expected] of Object.entries(reference.value)) {
        const value=flat[key];
        // Unix-time Double inputs have sub-microsecond quantization at this era.
        const same=typeof expected==='number'?Math.abs(value-expected)<=0.0000015:value===expected;
        if(!same)differences.push({field:key,reference:expected,actual:value});
      }
      if(!reference.error&&Boolean(reference.healthError)!==Boolean(actual.healthError))
        differences.push({field:'health acceptance',reference:reference.healthError,actual:actual.healthError});
    }
  }catch(e){
    error=e.message;
    if(!reference.error)differences.push({field:'local error',actual:error,reference:'accepted'});
    else actual={bothRejected:true};
  }
  return {input,reference,actual,error,differences,
    status:differences.length?(input.intentionalDifference&&differences.every(d=>input.differenceFields?.includes(d.field))?'documented-difference':'unexplained-difference'):'matched'};
});
const report={reference:'beevik/ntp v1.5.0, unchanged public QueryWithOptions with a deterministic in-memory net.Conn and clock callback',
  casesSHA256:createHash('sha256').update(raw).digest('hex'),
  engineSHA256:createHash('sha256').update(fs.readFileSync(new URL('../web/engine.mjs',import.meta.url))).digest('hex'),
  numericToleranceSeconds:0.0000015,
  scope:'Response data/health acceptance and six authenticated request MAC algorithms. Invalid key rejection compared; no secret operational keys. Differences retained.',
  rows,matched:rows.filter(r=>r.status==='matched').length,
  documentedDifferences:rows.filter(r=>r.status==='documented-difference').length,
  unexplainedDifferences:rows.filter(r=>r.status==='unexplained-difference').length,
  referenceStderr:result.stderr.toString()};
fs.writeFileSync(new URL('../evidence/'+(replay?'reference-replay.json':'reference-comparison.json'),import.meta.url),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify({matched:report.matched,documented:report.documentedDifferences,
  unexplained:report.unexplainedDifferences,
  differences:rows.filter(r=>r.differences.length).map(r=>({name:r.input.name,differences:r.differences}))},null,2));
process.exitCode=report.unexplainedDifferences?1:0;
