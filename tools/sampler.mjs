import {performance} from 'node:perf_hooks';
import {query,parseAddress} from './udp-client.mjs';
import {ClockFilter,combinePeers} from './protocol.mjs';

function pause(milliseconds,signal) {
  if(signal?.aborted)return Promise.reject(Error('NTP sampling aborted'));
  return new Promise((resolve,reject)=>{
    const abort=()=>{clearTimeout(timer);signal?.removeEventListener('abort',abort);reject(Error('NTP sampling aborted'));};
    const timer=setTimeout(()=>{signal?.removeEventListener('abort',abort);resolve();},milliseconds);
    signal?.addEventListener('abort',abort,{once:true});
  });
}

/** Bounded, cancellable rounds. Returns estimates and never adjusts a clock. */
export async function* sampleServers(servers,{
  rounds=8,intervalMs=64000,concurrency=4,minimum=Math.min(3,servers?.length??0),
  maximumDistance=1,respectPoll=true,queryOptions={},signal,
  clock=()=>performance.now()/1000,
}={}) {
  if(!Array.isArray(servers)||servers.length<1||servers.length>64||
     !Number.isInteger(rounds)||rounds<1||rounds>4096||
     !Number.isInteger(intervalMs)||intervalMs<0||intervalMs>86400000||
     !Number.isInteger(concurrency)||concurrency<1||concurrency>32||
     !Number.isInteger(minimum)||minimum<1||minimum>servers.length||
     !Number.isFinite(maximumDistance)||maximumDistance<=0||maximumDistance>16||
     typeof respectPoll!=='boolean'||typeof clock!=='function'||
     !queryOptions||typeof queryOptions!=='object'||Array.isArray(queryOptions)||
     (signal!==undefined&&!(signal instanceof AbortSignal)))
    throw Error('Invalid NTP sampler options');
  if(signal?.aborted)throw Error('NTP sampling aborted');
  const lifetime=new AbortController();
  const externalAbort=()=>lifetime.abort(signal.reason);
  signal?.addEventListener('abort',externalAbort,{once:true});
  const activeSignal=lifetime.signal;
  const identities=new Set(),states=[];
  let started;
  try {
    for(const value of servers) {
      const entry=typeof value==='string'?{address:value}:value;
      if(!entry||typeof entry!=='object'||Array.isArray(entry)||
         Object.keys(entry).some(k=>!['address','id','options'].includes(k))||
         (entry.options!==undefined&&(!entry.options||typeof entry.options!=='object'||Array.isArray(entry.options))))
        throw Error('Invalid NTP server entry');
      const parsed=parseAddress(entry.address,entry.options?.port??queryOptions.port??123);
      const id=entry.id??entry.address;
      const endpoint=parsed.host.toLowerCase()+':'+parsed.port;
      if(typeof id!=='string'||!id||id.length>256||identities.has('id:'+id)||identities.has('endpoint:'+endpoint))
        throw Error('Duplicate or invalid NTP source');
      identities.add('id:'+id);identities.add('endpoint:'+endpoint);
      states.push({id,address:entry.address,options:entry.options??{},filter:new ClockFilter(),
        metadata:new Map(),next:0,disabled:false});
    }
    started=clock();
    if(!Number.isFinite(started)||started<0)throw Error('Invalid sampler clock');
    for(let round=1;round<=rounds;round++) {
      if(signal?.aborted)throw Error('NTP sampling aborted');
      const observations=new Array(states.length);
      let cursor=0;
      const worker=async()=>{
        while(cursor<states.length) {
          const index=cursor++,state=states[index],now=clock();
          if(signal?.aborted)throw Error('NTP sampling aborted');
          if(state.disabled||now<state.next) {
            observations[index]={id:state.id,skipped:state.disabled?'server denied access':'poll backoff',
              nextPollAt:state.disabled?null:state.next};
            continue;
          }
          state.filter.beginPoll(now);
          try {
            const result=await query(state.address,{...queryOptions,...state.options,signal:activeSignal});
            const received=clock();
            const estimate=state.filter.observe({offsetSeconds:result.offsetSeconds,
              delaySeconds:result.delaySeconds,
              dispersionSeconds:0.000001+result.precisionSeconds+0.000015*result.elapsedSeconds,
              receivedAt:received});
            state.metadata.set(received,result);
            while(state.metadata.size>8)state.metadata.delete(state.metadata.keys().next().value);
            state.next=respectPoll?received+Math.min(131072,Math.max(1,result.pollSeconds)):received;
            observations[index]={id:state.id,result,estimate};
          }catch(error) {
            if(signal?.aborted)throw Error('NTP sampling aborted');
            if(error.code==='KOD') {
              if(['DENY','RSTR'].includes(error.kissCode))state.disabled=true;
              state.next=clock()+Math.min(131072,Math.max(1,intervalMs/1000,(error.pollSeconds??64)*2));
            }
            observations[index]={id:state.id,error:{code:error.code??'SAMPLE',message:error.message,
              ...(error.kissCode?{kissCode:error.kissCode}:{})}};
          }
        }
      };
      const completed=await Promise.allSettled(Array.from({length:Math.min(concurrency,states.length)},
        ()=>worker().catch(error=>{lifetime.abort(error);throw error;})));
      const failure=completed.find(result=>result.status==='rejected');
      if(failure)throw failure.reason;
      if(signal?.aborted)throw Error('NTP sampling aborted');
      const at=clock(),peers=[],sources=[],addresses=new Set();
      for(const state of states) {
        const estimate=state.filter.estimate(at);
        const packet=estimate&&state.metadata.get(estimate.selectedAt);
        let exclusion=state.disabled?'server denied access':!estimate||!estimate.reach||!packet?'no reachable sample':null;
        const endpoint=packet&&(packet.address??packet.server)+':'+packet.port;
        if(!exclusion&&addresses.has(endpoint))exclusion='duplicate resolved endpoint';
        if(!exclusion)addresses.add(endpoint);
        const distance=packet?state.filter.distance(at,packet.rootDelaySeconds,packet.rootDispersionSeconds):null;
        sources.push({id:state.id,estimate,rootDistanceSeconds:distance,exclusion});
        if(!exclusion)peers.push({id:state.id,offsetSeconds:estimate.offsetSeconds,
          rootDistanceSeconds:distance,jitterSeconds:estimate.jitterSeconds,stratum:packet.stratum});
      }
      const consensus=combinePeers(peers,{minimum,clusterMinimum:Math.max(3,minimum),maximumDistance});
      yield {round,elapsedSeconds:at-started,observations,sources,consensus};
      if(round<rounds&&!states.every(state=>state.disabled))await pause(intervalMs,signal);
      else break;
    }
  }finally {
    lifetime.abort();
    signal?.removeEventListener('abort',externalAbort);
    for(const state of states)state.filter.close();
  }
}
