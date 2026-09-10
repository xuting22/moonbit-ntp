import {test} from 'node:test';
import assert from 'node:assert/strict';
import dgram from 'node:dgram';
import {once} from 'node:events';
import {query} from './udp-client.mjs';
const base=1800000000;
function timestamp(buffer,at,unix){const n=unix+2208988800;buffer.writeUInt32BE(Math.floor(n)>>>0,at);buffer.writeUInt32BE(Math.floor((n-Math.floor(n))*2**32)>>>0,at+4)}
async function server(t,edit=()=>{},family=4){const s=dgram.createSocket(family===6?'udp6':'udp4');s.bind(0,family===6?'::1':'127.0.0.1');await once(s,'listening');t.after(()=>s.close());s.on('message',(req,remote)=>{assert.equal(req.length,48);assert.equal(req[0]&7,3);const reply=Buffer.alloc(48);reply[0]=36;reply[1]=2;req.copy(reply,24,40,48);timestamp(reply,16,base-10);timestamp(reply,32,base+.2);timestamp(reply,40,base+.3);const wire=edit(reply,req);if(wire===false)return;s.send(wire??reply,remote.port,remote.address)});return s.address().port}
function options(port){let call=0;return {port,timeoutMs:250,now:()=>base,monotonic:()=>call++===0?100:100.5}}
await test('UDP four timestamps produce independently calculated offset and delay',async t=>{const port=await server(t);const value=await query('127.0.0.1',options(port));assert.ok(Math.abs(value.offsetSeconds)<.000001);assert.ok(Math.abs(value.delaySeconds-.4)<.000001);assert.equal(value.stratum,2)});
await test('UDP rejects origin mismatch KoD unsynchronized wrong mode and truncation',async t=>{for(const [edit,error] of [
 [b=>{b[24]^=1},/origin mismatch/],
 [b=>{b[1]=0;b.write('RATE',12)},/RATE/],
 [b=>{b[0]|=192},/unsynchronized/],
 [b=>{b[0]=35},/server response/],
 [b=>b.subarray(0,47),/48-byte/],
 [b=>{b.fill(0,40,48)},/missing server timestamp/]
]){const port=await server(t,edit);await assert.rejects(query('127.0.0.1',options(port)),error)}});
await test('UDP timeout cancellation and invalid clock close the socket',async t=>{const port=await server(t,()=>false);await assert.rejects(query('127.0.0.1',{port,timeoutMs:20}),/timeout/);const control=new AbortController();const pending=query('127.0.0.1',{port,signal:control.signal});control.abort();await assert.rejects(pending,/aborted/);await assert.rejects(query('127.0.0.1',{port,now:()=>NaN}),/clock/)});
await test('UDP IPv6 loopback',async t=>{const port=await server(t,()=>{},6);const result=await query('::1',{...options(port),family:6});assert.equal(result.stratum,2)});

await test('UDP health limits include stale future and missing reference and excessive distance',async t=>{
 for(const [edit,error] of [
  [b=>timestamp(b,16,base-131073),/stale/],
  [b=>timestamp(b,16,base+1),/follows/],
  [b=>b.fill(0,16,24)&&undefined,/missing reference/],
  [b=>{b.writeUInt32BE(17*65536,8)},/excessive/]
 ]){const port=await server(t,edit);await assert.rejects(query('127.0.0.1',options(port)),error)}
 const port=await server(t,b=>{b.writeInt32BE(2*65536,4);b.writeUInt32BE(3*65536,8)});
 const result=await query('127.0.0.1',options(port));assert.ok(Math.abs(result.rootDistanceSeconds-4.2)<.000001);
});
await test('UDP nonce separates origin matching from clock and supports source bind and version',async t=>{
 const seen=[];const source=dgram.createSocket('udp4');source.bind(0,'127.0.0.1');await once(source,'listening');const localPort=source.address().port;await new Promise(resolve=>source.close(resolve));
 const port=await server(t,(reply,req)=>{seen.push(req.subarray(40).toString('hex'));assert.equal((req[0]>>3)&7,3)});
 for(let i=0;i<2;i++){
  const result=await query('127.0.0.1',{...options(port),localAddress:'127.0.0.1',localPort,ttl:1,version:3});
  assert.ok(Math.abs(result.offsetSeconds)<.000001);assert.ok(Math.abs(result.delaySeconds-.4)<.000001);
 }
 assert.notEqual(seen[0],seen[1]);
 const mismatch=await server(t,reply=>{reply[30]^=1});await assert.rejects(query('127.0.0.1',options(mismatch)),/origin mismatch/);
 for(const bad of [{ttl:0},{ttl:256},{localAddress:'::1'},{localPort:-1},{version:2},{signal:{}}])await assert.rejects(query('127.0.0.1',{...options(port),...bad}),/options/);
});
