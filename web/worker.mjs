import {protocol as core} from './engine.mjs';
const call=value=>{const result=JSON.parse(core(JSON.stringify(value)));if(!result.ok)throw Error(result.error);return result.value;};
self.onmessage=event=>{
  const {id,kind,...request}=event.data;
  try {
    let value;
    if(kind==='demo') {
      const handles=[],rounds=[];
      try {
        for(let i=0;i<4;i++)handles.push(call({op:'filterOpen'}));
        for(let round=1;round<=8;round++) {
          const sources=[],observations=[],peers=[];
          for(let i=0;i<4;i++) {
            const name=['示例 A','示例 B','示例 C','偏离来源'][i],handle=handles[i];
            call({op:'filterPoll',id:handle,now:round});
            const offset=[.012,.015,.013,.42][i]+Math.sin(round*2+i)*.0007;
            const delay=.008+((round*7+i*3)%9)*.0005;
            const estimate=call({op:'filterObserve',id:handle,offset,delay,dispersion:.00001,now:round});
            const distance=call({op:'filterDistance',id:handle,now:round,rootDelay:0,rootDispersion:.03});
            sources.push({id:name,estimate,rootDistanceSeconds:distance,exclusion:null});
            observations.push({id:name,result:{offsetSeconds:offset,delaySeconds:delay,stratum:2}});
            peers.push({id:name,offsetSeconds:estimate.offsetSeconds,rootDistanceSeconds:distance,jitterSeconds:estimate.jitterSeconds,stratum:2});
          }
          rounds.push({round,elapsedSeconds:round,sources,observations,consensus:call({op:'combine',peers,minimum:3})});
        }
        value=rounds;
      }finally {for(const handle of handles)call({op:'filterClose',id:handle});}
    }else if(kind==='decode')value=call({op:'decode',...request});
    else throw Error('Unknown worker request');
    self.postMessage({id,ok:true,value});
  }catch(error){self.postMessage({id,ok:false,error:error.message});}
};
