import dgram from 'node:dgram';
import {isIP} from 'node:net';
import {performance} from 'node:perf_hooks';
import {randomBytes} from 'node:crypto';
import {query_request,query_response_at} from '../web/engine.mjs';

/** Query one server. Returns an offset; never changes the OS clock. No automatic retries. */
export function query(host,{port=123,timeoutMs=3000,family=4,localAddress,localPort=0,ttl,version=4,signal,now=()=>Date.now()/1000,monotonic=()=>performance.now()/1000}={}) {
  if(typeof host!=='string'||!host||!Number.isInteger(port)||port<1||port>65535||![4,6].includes(family)||!Number.isFinite(timeoutMs)||timeoutMs<=0||timeoutMs>2147483647)return Promise.reject(new Error('Invalid NTP query options'));
  if(![3,4].includes(version)||!Number.isInteger(localPort)||localPort<0||localPort>65535||localAddress!==undefined&&isIP(localAddress)!==family||ttl!==undefined&&(!Number.isInteger(ttl)||ttl<1||ttl>255||family!==4)||signal!==undefined&&!(signal instanceof AbortSignal))return Promise.reject(new Error('Invalid NTP transport options'));
  if(signal?.aborted)return Promise.reject(new Error('NTP query aborted'));
  return new Promise((resolve,reject)=>{
    const socket=dgram.createSocket(family===6?'udp6':'udp4');let done=false,sentHex,wall,mono;
    const finish=(error,value)=>{
      if(done)return;done=true;clearTimeout(timer);signal?.removeEventListener('abort',abort);
      try{socket.close()}catch{}
      if(error)reject(error);else resolve(value);
    };
    const abort=()=>finish(new Error('NTP query aborted'));
    const timer=setTimeout(()=>finish(new Error('NTP query timeout')),timeoutMs);
    signal?.addEventListener('abort',abort,{once:true});socket.on('error',error=>finish(error));
    socket.on('message',data=>{
      if(!sentHex||done)return;
      try{
        const elapsed=monotonic()-mono;
        if(!Number.isFinite(elapsed)||elapsed<0)throw new Error('Invalid monotonic clock');
        const output=query_response_at(sentHex,wall,wall+elapsed,data.toString('hex'));
        if(output.startsWith('ERROR:'))throw new Error(output);
        finish(null,{...JSON.parse(output),receivedUnix:wall+elapsed,elapsedSeconds:elapsed,server:host,port});
      }catch(error){finish(error)}
    });
    const connected=()=>{
      if(done){try{socket.close()}catch{}return;}
      try{
        wall=now();mono=monotonic();
        if(!Number.isFinite(wall)||!Number.isFinite(mono))throw new Error('Invalid clock');
        if(ttl!==undefined)socket.setTTL(ttl);
        const wire=query_request(0);if(wire.startsWith('ERROR:'))throw new Error(wire);
        const request=Buffer.from(wire,'hex');
        // The wire timestamp is an unpredictable 64-bit nonce, not the client's clock.
        request[0]=(version<<3)|3;randomBytes(8).copy(request,40);sentHex=request.toString('hex');
        socket.send(request,error=>{if(error)finish(error)});
      }catch(error){finish(error)}
    };
    const connect=()=>{if(done){try{socket.close()}catch{}return;}try{socket.connect(port,host,connected)}catch(error){finish(error)}};
    try{if(localAddress!==undefined||localPort!==0)socket.bind(localPort,localAddress,connect);else connect()}catch(error){finish(error)}
  });
}
