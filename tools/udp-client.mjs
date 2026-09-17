import dgram from 'node:dgram';
import {isIP} from 'node:net';
import {performance} from 'node:perf_hooks';
import {randomBytes} from 'node:crypto';
import {query_request} from '../web/engine.mjs';
import {createAuthenticator} from './auth.mjs';
import {protocol} from './protocol.mjs';

export class NtpQueryError extends Error {
  constructor(code,message,details={}) {super(message);this.name='NtpQueryError';this.code=code;Object.assign(this,details);}
}

/** A host, host:port, bare IPv6 literal, or bracketed IPv6 address. */
export function parseAddress(address,defaultPort=123) {
  if(typeof address!=='string'||!address||address.length>1024||/\s|[\x00-\x1f]/.test(address))
    throw new NtpQueryError('OPTIONS','Invalid NTP address');
  let host=address,port=defaultPort;
  const bracket=address.match(/^\[([^\]]+)\](?::([0-9]+))?$/);
  if(bracket) {host=bracket[1];if(bracket[2]!==undefined)port=Number(bracket[2]);}
  else if(address.includes('[')||address.includes(']'))throw new NtpQueryError('OPTIONS','Invalid bracketed address');
  else if(address.split(':').length===2) {
    const split=address.lastIndexOf(':');host=address.slice(0,split);
    const suffix=address.slice(split+1);
    if(!/^[0-9]+$/.test(suffix))throw new NtpQueryError('OPTIONS','Invalid NTP port');
    port=Number(suffix);
  }
  if(!host||!Number.isInteger(port)||port<1||port>65535)throw new NtpQueryError('OPTIONS','Invalid NTP port');
  return {host,port};
}

/** Query a server; default health validation is fail-closed. Never changes the OS clock. */
export async function query(address,options={}) {
  if(!options||typeof options!=='object'||Array.isArray(options))throw new NtpQueryError('OPTIONS','Invalid NTP query options');
  const names=['port','timeoutMs','family','localAddress','localPort','ttl','version','signal','now','monotonic','auth','extensions','validate','socketFactory'];
  if(Object.keys(options).some(name=>!names.includes(name)))throw new NtpQueryError('OPTIONS','Unknown NTP query options');
  const {port:defaultPort=123,timeoutMs=3000,localAddress,localPort=0,ttl,version=4,signal,
    now=()=>Date.now()/1000,monotonic=()=>performance.now()/1000,auth,extensions=[],validate=true,
    socketFactory=family=>dgram.createSocket(family===6?'udp6':'udp4')}=options;
  const {host,port}=parseAddress(address,defaultPort);
  const family=options.family??(isIP(host.split('%')[0])===6?6:4);
  if(![4,6].includes(family)||!Number.isFinite(timeoutMs)||timeoutMs<=0||timeoutMs>2147483647||
     ![2,3,4].includes(version)||!Number.isInteger(localPort)||localPort<0||localPort>65535||
     (localAddress!==undefined&&isIP(localAddress)!==family)||
     (ttl!==undefined&&(!Number.isInteger(ttl)||ttl<1||ttl>255||family!==4))||
     (signal!==undefined&&!(signal instanceof AbortSignal))||
     typeof now!=='function'||typeof monotonic!=='function'||typeof socketFactory!=='function'||
     !Array.isArray(extensions)||extensions.length>64||typeof validate!=='boolean')
    throw new NtpQueryError('OPTIONS','Invalid NTP transport options');
  if(signal?.aborted)throw new NtpQueryError('ABORT','NTP query aborted');
  const authenticator=auth===undefined?undefined:createAuthenticator(auth);
  // Protocol parsing and key validation happen before creating a socket.
  const blank=query_request(0);
  const template=Buffer.from(protocol({op:'encode',headerHex:blank,extensions,
    macHex:'00'.repeat(authenticator?.macLength??0)}),'hex');
  return new Promise((resolve,reject)=>{
    let socket,done=false,timer,sentHex,wall,mono;
    const finish=(error,value)=>{
      if(done)return;done=true;clearTimeout(timer);signal?.removeEventListener('abort',abort);
      try{socket?.close()}catch{}
      if(error)reject(error);else resolve(value);
    };
    const abort=()=>finish(new NtpQueryError('ABORT','NTP query aborted'));
    timer=setTimeout(()=>finish(new NtpQueryError('TIMEOUT','NTP query timeout')),timeoutMs);
    signal?.addEventListener('abort',abort,{once:true});
    try {
      socket=socketFactory(family);
      if(!socket||!['on','connect','send','close'].every(k=>typeof socket[k]==='function'))
        throw new NtpQueryError('OPTIONS','Invalid NTP socket factory result');
      socket.on('error',error=>finish(error));
      socket.on('message',data=>{
        if(!sentHex||done)return;
        try {
          // Sample receipt time before MAC/JSON processing, which may be expensive.
          const elapsed=monotonic()-mono;
          if(!Number.isFinite(elapsed)||elapsed<0)throw new NtpQueryError('CLOCK','Invalid monotonic clock');
          const bytes=Buffer.from(data);
          if(bytes.length<48||bytes.length>65507)throw new NtpQueryError('PACKET','Expected 48-byte NTP header and bounded datagram');
          if(!bytes.subarray(24,32).equals(Buffer.from(sentHex,'hex').subarray(40,48)))
            throw new NtpQueryError('ORIGIN','origin mismatch');
          if(authenticator) {
            try{authenticator.verify(bytes);}
            catch{throw new NtpQueryError('AUTH','NTP authentication failed');}
          }
          // KoD receive/transmit timestamps are undefined (RFC 5905 section 7.4).
          // Honor backoff after source/nonce/MAC/framing checks, before time math.
          if(validate&&bytes[1]===0) {
            const packet=protocol({op:'decode',hex:bytes.toString('hex'),macLength:authenticator?.macLength??0}).header;
            if(packet.mode===4&&packet.version>=2&&packet.version<=4)
              throw new NtpQueryError('KOD','Kiss-of-death: '+packet.kissCode,
                {kissCode:packet.kissCode,pollSeconds:2**packet.poll});
          }
          const value=protocol({op:'analyze',sentHex,sentUnix:wall,receivedUnix:wall+elapsed,
            replyHex:bytes.toString('hex'),macLength:authenticator?.macLength??0,validate:false});
          if(validate&&value.healthError) {
            if(value.header.stratum===0)throw new NtpQueryError('KOD','Kiss-of-death: '+value.header.kissCode,
              {kissCode:value.header.kissCode,pollSeconds:value.pollSeconds});
            throw new NtpQueryError('HEALTH',value.healthError);
          }
          const remote=typeof socket.remoteAddress==='function'?socket.remoteAddress():undefined;
          finish(null,{...value,...value.header,header:undefined,receivedUnix:wall+elapsed,
            elapsedSeconds:elapsed,server:host,port,address:remote?.address,family,
            authenticated:!!authenticator,authentication:authenticator?{type:authenticator.type,keyID:authenticator.keyID}:null});
        }catch(error){finish(error);}
      });
      const connected=()=>{
        if(done){try{socket.close()}catch{}return;}
        try {
          if(ttl!==undefined)socket.setTTL(ttl);
          const request=Buffer.from(template);
          request[0]=(version<<3)|3;
          randomBytes(8).copy(request,40);
          sentHex=request.subarray(0,48).toString('hex');
          const payload=authenticator?request.subarray(0,-authenticator.macLength):request;
          const wire=authenticator?authenticator.sign(payload):payload;
          // Clock starts after construction/authentication and immediately before send.
          wall=now();mono=monotonic();
          if(!Number.isFinite(wall)||!Number.isFinite(mono))throw new NtpQueryError('CLOCK','Invalid clock');
          socket.send(wire,error=>{if(error)finish(error);});
        }catch(error){finish(error);}
      };
      const connect=()=>{if(done){try{socket.close()}catch{}return;}try{socket.connect(port,host,connected);}catch(error){finish(error);}};
      if(localAddress!==undefined||localPort!==0)socket.bind(localPort,localAddress,connect);else connect();
    }catch(error){finish(error);}
  });
}
