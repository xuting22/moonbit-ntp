import assert from 'node:assert/strict';
import fs from 'node:fs';
import {spawnSync} from 'node:child_process';
import {query} from './udp-client.mjs';

// These deterministic test keys must only be used by a private test daemon.
const address=process.env.NTP_DAEMON_ADDRESS??'127.0.0.1:43123';
if(!/^127\.0\.0\.1:[0-9]+$/.test(address))throw Error('A loopback test daemon is required');
const reference=JSON.parse(process.env.NTP_REFERENCE_COMMAND_JSON??'["ntp-probe"]');
const rows=[];
for(const version of [2,3,4]) {
  const result=await query(address,{version,timeoutMs:1000});
  assert.equal(result.stratum,10);
  assert.equal(result.healthError,null);
  assert.ok(result.delaySeconds>=0&&result.delaySeconds<1);
  assert.ok(Math.abs(result.offsetSeconds)<1);
  rows.push({case:'plain v'+version,passed:true,result});
}
for(const [index,[type,size]] of [
  ['MD5',16],['SHA1',20],['SHA256',20],['SHA512',20],['AES128',16],['AES256',32],
].entries()) {
  const auth={type,key:'HEX:'+Buffer.from(Array.from({length:size},(_,i)=>i)).toString('hex'),keyID:100+index};
  const actual=await query(address,{auth,timeoutMs:1000});
  assert.equal(actual.authenticated,true);
  assert.equal(actual.stratum,10);
  assert.equal(actual.healthError,null);
  const call=spawnSync(reference[0],reference.slice(1),{input:JSON.stringify({Name:type,Server:address,Auth:auth,Version:4})+'\n',
    timeout:5000,maxBuffer:1000000,windowsHide:true});
  assert.equal(call.status,0,call.stderr.toString());
  const official=JSON.parse(call.stdout);
  assert.equal(official.error,undefined);
  assert.equal(official.healthError,null);
  assert.equal(official.value.stratum,10);
  rows.push({case:type+' both clients authenticate',passed:true,actual,official});
  const extended=await query(address,{auth,extensions:[{type:0x1234,valueHex:'00'.repeat(12)}],timeoutMs:1000});
  assert.equal(extended.authenticated,true);
  rows.push({case:type+' authenticated unknown extension',passed:true,result:extended});
}
await assert.rejects(query(address,{auth:{type:'AES128',key:'ASCII:wrong-secret-key',keyID:104},timeoutMs:200}),
  /timeout|authentication failed/);
rows.push({case:'wrong key rejected',passed:true});
const report={server:'chronyd 4.8',address,scope:'Private unprivileged daemon with -x and local stratum 10. No system clock modification. Node 20 in WSL and unchanged beevik/ntp 1.5.0 both query the same daemon.',
  passed:rows.length,rows};
fs.writeFileSync(new URL('../evidence/chrony-validation.json',import.meta.url),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify({passed:rows.length,server:report.server}));
