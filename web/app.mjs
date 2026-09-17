import config from './config.mjs';
const $=id=>document.getElementById(id);
const colors=['#a7e8cc','#80c6ec','#c2aff1','#f3bb82','#eaa5ba','#d0d998','#8fced0','#afbbd6'];
let rows=[],kind='',control=null,auth,worker,serial=0;
const pending=new Map();
function workerStart() {
  worker=new Worker('./worker.mjs',{type:'module'});
  worker.onmessage=({data})=>{const p=pending.get(data.id);if(!p)return;pending.delete(data.id);clearTimeout(p.timer);data.ok?p.resolve(data.value):p.reject(Error(data.error));};
  worker.onerror=()=>workerReset(Error('离线计算发生错误，请重试'));
}
function workerReset(error) {worker.terminate();for(const p of pending.values()){clearTimeout(p.timer);p.reject(error);}pending.clear();workerStart();}
function compute(kind,value={}) {
  return new Promise((resolve,reject)=>{
    const id=++serial,timer=setTimeout(()=>workerReset(Error('离线计算超时，请检查输入')),10000);
    pending.set(id,{resolve,reject,timer});worker.postMessage({id,kind,...value});
  });
}
workerStart();
function status(text,error=false){$('status').textContent=text;$('status').classList.toggle('error',error);}
function busy(value) {
  for(const id of ['query','sample','demo','servers','rounds','interval','minimum','version','fast','auth','clear-auth'])$(id).disabled=value;
  $('cancel').disabled=!value;
}
const ms=value=>Number.isFinite(value)?(value*1000).toFixed(3):'—';
function reset(mode){rows=[];kind=mode;$('mode-label').textContent=mode;$('download').disabled=true;render();}
function render() {
  const latest=rows.at(-1),consensus=latest?.consensus;
  const estimates=latest?.sources.filter(s=>s.estimate)??[];
  $('offset').textContent=ms(consensus?.offsetSeconds??(kind==='单次查询'?estimates[0]?.estimate.offsetSeconds:undefined));
  $('delay').textContent=ms(estimates.length?Math.min(...estimates.map(s=>s.estimate.delaySeconds)):undefined);
  $('survivors').textContent=latest?(consensus?.survivors.length??0)+' / '+latest.sources.length:'—';
  $('round-label').textContent=latest?'第 '+latest.round+' 轮 · '+latest.elapsedSeconds.toFixed(1)+' 秒':'尚未开始';
  $('selection-note').textContent=consensus?'共识主来源：'+consensus.systemPeer+' · 抖动 '+ms(consensus.jitterSeconds)+' ms':
    kind==='单次查询'?'单次结果尚未经过八级过滤与来源共识。':'尚未形成共识：检查有效来源数量、过滤预热、不确定度与来源差异。';
  const body=$('sources');body.replaceChildren();
  if(!latest){const tr=document.createElement('tr'),td=document.createElement('td');td.colSpan=5;td.textContent='还没有观测数据';tr.append(td);body.append(tr);}
  else for(const source of latest.sources) {
    const observation=latest.observations.find(o=>o.id===source.id),error=observation?.error;
    const state=error?error.message:source.exclusion??observation?.skipped??(
      consensus?.survivors.includes(source.id)?'纳入共识':consensus?.rejected.includes(source.id)?'未纳入共识':
      source.estimate?'已收到 · '+(source.estimate.validSamples??1)+' 样本':'暂无样本');
    const tr=document.createElement('tr');
    for(const text of [source.id,ms(source.estimate?.offsetSeconds),ms(source.estimate?.delaySeconds),ms(source.rootDistanceSeconds),state]) {
      const td=document.createElement('td');td.textContent=text;tr.append(td);
    }body.append(tr);
  }
  $('download').disabled=!rows.length;draw();
}
function draw() {
  const canvas=$('chart'),rect=canvas.getBoundingClientRect(),scale=window.devicePixelRatio||1;
  canvas.width=Math.max(1,Math.floor(rect.width*scale));canvas.height=Math.floor(190*scale);
  const ctx=canvas.getContext('2d');ctx.scale(scale,scale);
  const w=rect.width,h=190,points=rows.flatMap(r=>r.sources.filter(s=>s.estimate).map(s=>s.estimate.offsetSeconds*1000));
  $('chart-empty').hidden=!!points.length;
  if(!points.length)return;
  let low=Math.min(...points),high=Math.max(...points),pad=Math.max(.2,(high-low)*.12);low-=pad;high+=pad;
  const left=43,right=w-10,top=18,bottom=h-24;
  ctx.font='10px system-ui';ctx.lineWidth=1;
  for(let i=0;i<4;i++) {
    const y=top+(bottom-top)*i/3;
    ctx.strokeStyle='#273b47';ctx.beginPath();ctx.moveTo(left,y);ctx.lineTo(right,y);ctx.stroke();
    ctx.fillStyle='#819eaf';ctx.fillText((high-(high-low)*i/3).toFixed(1),0,y+3);
  }
  const x=round=>left+(right-left)*(round-1)/Math.max(1,rows.at(-1).round-1);
  const y=value=>bottom-(value*1000-low)/(high-low)*(bottom-top);
  const names=[...new Set(rows.flatMap(r=>r.sources.map(s=>s.id)))];
  names.forEach((name,index)=>{
    ctx.strokeStyle=ctx.fillStyle=colors[index%colors.length];ctx.lineWidth=1.7;ctx.beginPath();let started=false;
    for(const row of rows) {
      const point=row.sources.find(s=>s.id===name)?.estimate;
      if(!point){started=false;continue;}
      if(!started)ctx.moveTo(x(row.round),y(point.offsetSeconds));else ctx.lineTo(x(row.round),y(point.offsetSeconds));started=true;
    }ctx.stroke();
    for(const row of rows) {const point=row.sources.find(s=>s.id===name)?.estimate;if(point){ctx.beginPath();ctx.arc(x(row.round),y(point.offsetSeconds),2.6,0,Math.PI*2);ctx.fill();}}
  });
  ctx.fillStyle='#819eaf';ctx.fillText('第 1 轮',left,h-6);
  if(rows.length>1)ctx.fillText('第 '+rows.at(-1).round+' 轮',Math.max(left,right-44),h-6);
}
new ResizeObserver(draw).observe($('chart'));
function addresses(){const list=$('servers').value.split(/\r?\n/).map(s=>s.trim()).filter(Boolean);if(!list.length||list.length>8)throw Error('请输入 1 至 8 个时间源地址');return list;}
async function jsonResponse(response){const data=await response.json();if(!response.ok||!data.ok)throw Error(data.error??'本地服务请求失败');return data.value;}
async function run(mode) {
  control=new AbortController();busy(true);reset(mode);
  try {
    const servers=addresses(),options={version:Number($('version').value),...(auth?{auth}:{})};
    status(mode==='单次查询'?'正在查询…':'正在采样；默认遵守服务器公布的轮询间隔。');
    if(mode==='单次查询') {
      if(servers.length!==1)throw Error('单次查询需要一个地址；多个来源请使用采样。');
      const value=await jsonResponse(await fetch('/api/query',{method:'POST',headers:{'Content-Type':'application/json'},
        body:JSON.stringify({server:servers[0],options}),signal:control.signal}));
      rows.push({round:1,elapsedSeconds:value.elapsedSeconds,observations:[{id:servers[0],result:value}],
        sources:[{id:servers[0],estimate:value,rootDistanceSeconds:value.rootDistanceSeconds,exclusion:null}],consensus:null});render();
      status('查询完成 · NTP v'+value.version+' · stratum '+value.stratum+(value.authenticated?' · 认证通过':' · 未认证'));
    }else {
      const response=await fetch('/api/sample',{method:'POST',headers:{'Content-Type':'application/json'},signal:control.signal,
        body:JSON.stringify({servers,options:{rounds:Number($('rounds').value),intervalMs:Number($('interval').value),
          minimum:Number($('minimum').value),respectPoll:!$('fast').checked,queryOptions:options}})});
      if(!response.ok)throw Error((await response.json()).error);
      const reader=response.body.getReader(),decoder=new TextDecoder('utf-8',{fatal:true});let buffer='',done=false;
      try {
        for(;;) {
          const part=await reader.read();buffer+=decoder.decode(part.value,{stream:!part.done});
          if(buffer.length>1048576)throw Error('采样响应超出限制');
          let split;while((split=buffer.indexOf('\n'))>=0) {
            const line=buffer.slice(0,split);buffer=buffer.slice(split+1);if(!line)continue;
            const data=JSON.parse(line);
            if(data.type==='error')throw Error(data.error);
            if(data.type==='done')done=true;
            else if(data.type==='round') {rows.push(data);render();status('已收到第 '+data.round+' 轮，等待后续采样…');}
          }
          if(part.done)break;
        }
        if(buffer.trim()||!done)throw Error('采样流意外中断，已保留收到的结果');
      }finally {await reader.cancel().catch(()=>{});reader.releaseLock();}
      status(rows.at(-1)?.consensus?'采样完成，已形成来源共识。':'采样完成，未形成共识；请查看各来源状态。');
    }
  }catch(error){status(control.signal.aborted?'已停止采样，已收到的结果可继续导出。':error.message,!control.signal.aborted);}
  finally {control=null;busy(false);}
}
$('query').onclick=()=>run('单次查询');$('sample').onclick=()=>run('连续采样');$('cancel').onclick=()=>control?.abort();
$('demo').onclick=async()=>{
  busy(true);$('cancel').disabled=true;reset('离线示例 · 合成数据');
  try {rows=await compute('demo');render();status('离线示例：3 个相近来源和 1 个偏离来源，所有数值均为合成数据。');}
  catch(error){status(error.message,true);}finally {busy(false);}
};
$('download').onclick=()=>{
  const blob=new Blob([JSON.stringify({format:'moonbit-ntp-observations/1',kind,exportedAt:new Date().toISOString(),rounds:rows},null,2)+'\n'],{type:'application/json'});
  const url=URL.createObjectURL(blob),a=document.createElement('a');a.href=url;a.download='ntp-observations.json';a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
};
$('auth').onchange=async()=>{
  auth=undefined;const file=$('auth').files[0];if(!file)return;
  try {
    if(file.size>4096)throw Error('认证文件上限为 4 KiB');
    const value=JSON.parse(new TextDecoder('utf-8',{fatal:true}).decode(await file.arrayBuffer()));
    if(!value||typeof value!=='object'||Array.isArray(value)||Object.keys(value).some(k=>!['type','key','keyID'].includes(k))||
      typeof value.key!=='string'||!['MD5','SHA1','SHA256','SHA512','AES128','AES256'].includes(value.type)||
      !Number.isInteger(value.keyID)||value.keyID<0||value.keyID>65535)throw Error('认证文件格式无效');
    auth=value;$('auth-state').textContent=value.type+' · Key ID '+value.keyID+' · 已加载';
  }catch(error){$('auth-state').textContent=error.message;$('auth').value='';}
};
$('clear-auth').onclick=()=>{auth=undefined;$('auth').value='';$('auth-state').textContent='已清除认证配置';};
$('packet').value=config.example;
$('decode').onclick=async()=>{
  $('decode').disabled=true;
  try {
    const hex=$('packet').value;if(hex.length>300000)throw Error('报文文本过长');
    $('decoded').textContent=JSON.stringify(await compute('decode',{hex,macLength:Number($('mac-length').value)}),null,2);
  }catch(error){$('decoded').textContent='错误：'+error.message;}finally{$('decode').disabled=false;}
};
fetch('/api/status').then(r=>{if(!r.ok)throw Error();return r.json();}).then(()=>{$('host-state').textContent='● 本地服务已连接';})
  .catch(()=>{$('host-state').textContent='本地服务不可用 · 可使用离线示例';});
window.addEventListener('pagehide',()=>{control?.abort();worker.terminate();});
render();
