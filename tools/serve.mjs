import http from 'node:http';
import fs from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import {query} from './udp-client.mjs';
import {sampleServers} from './sampler.mjs';

const root=new URL('../',import.meta.url);
const assets=new Map([
  ['/','web/index.html'],['/web/','web/index.html'],
  ...['index.html','app.mjs','engine.mjs','worker.mjs','style.css','config.mjs'].map(n=>['/web/'+n,'web/'+n]),
  ...['README.md','HOST.md','pkg.generated.mbti'].map(n=>['/'+n,n]),
]);
function fail(status,message) {throw Object.assign(Error(message),{status});}
function object(value,keys) {
  if(!value||typeof value!=='object'||Array.isArray(value)||Object.keys(value).some(k=>!keys.includes(k)))
    fail(400,'Invalid request options');
}
function integer(value,min,max,name) {
  if(!Number.isInteger(value)||value<min||value>max)fail(400,'Invalid '+name);
}
async function body(request) {
  if(!/^application\/json(?:\s*;|$)/i.test(request.headers['content-type']??''))fail(415,'JSON content type required');
  if(Number(request.headers['content-length'])>16384)fail(413,'Request exceeds 16 KiB');
  let size=0;const chunks=[];
  for await(const chunk of request) {
    size+=chunk.length;if(size>16384)fail(413,'Request exceeds 16 KiB');chunks.push(chunk);
  }
  try{return JSON.parse(new TextDecoder('utf-8',{fatal:true}).decode(Buffer.concat(chunks)));}
  catch{fail(400,'Invalid UTF-8 JSON');}
}
function queryOptions(options={}) {
  object(options,['timeoutMs','version','family','auth','extensions']);
  if(options.timeoutMs!==undefined)integer(options.timeoutMs,1,10000,'timeout');
  return {...options,timeoutMs:options.timeoutMs??3000};
}
function sampleOptions(value) {
  object(value,['servers','options']);
  if(!Array.isArray(value.servers)||!value.servers.length||value.servers.length>8||
     value.servers.some(s=>typeof s!=='string'||s.length>1024))fail(400,'Provide 1 to 8 server addresses');
  const options=value.options??{};
  object(options,['rounds','intervalMs','minimum','concurrency','maximumDistance','respectPoll','queryOptions']);
  integer(options.rounds??8,1,32,'rounds');
  integer(options.intervalMs??64000,0,64000,'interval');
  integer(options.concurrency??4,1,4,'concurrency');
  integer(options.minimum??Math.min(3,value.servers.length),1,value.servers.length,'minimum');
  return {...options,queryOptions:queryOptions(options.queryOptions)};
}
async function line(response,value,signal) {
  if(signal.aborted||response.destroyed)throw Error('Client disconnected');
  if(response.write(JSON.stringify(value)+'\n'))return;
  await new Promise((resolve,reject)=>{
    const cleanup=()=>{response.off('drain',drain);response.off('close',close);signal.removeEventListener('abort',close);};
    const drain=()=>{cleanup();resolve();},close=()=>{cleanup();reject(Error('Stream closed'));};
    response.once('drain',drain);response.once('close',close);signal.addEventListener('abort',close,{once:true});
    if(signal.aborted||response.destroyed)close();
  });
}

/** Local-only adapter. No network request starts until a validated POST arrives. */
export async function startServer({port=8775}={}) {
  integer(port,0,65535,'port');
  const jobs=new Set();
  const server=http.createServer(async(request,response)=>{
    response.setHeader('X-Content-Type-Options','nosniff');
    response.setHeader('Cache-Control','no-store');
    response.setHeader('Content-Security-Policy',"default-src 'self'; script-src 'self'; style-src 'self'; connect-src 'self'; worker-src 'self'; object-src 'none'; base-uri 'none'; frame-ancestors 'none'");
    let controller,timer;
    const disconnect=()=>{if(!response.writableEnded)controller?.abort(Error('Client disconnected'));};
    response.once('close',disconnect);
    try {
      const authority='127.0.0.1:'+server.address().port;
      if(request.headers.host!==authority)fail(403,'Use the loopback address printed by this server');
      const origin=request.headers.origin;
      if((origin&&origin!=='http://'+authority)||request.headers['sec-fetch-site']==='cross-site')fail(403,'Cross-origin request denied');
      const pathname=request.url.split('?')[0];
      if(request.method==='GET'&&pathname==='/api/status') {
        response.setHeader('Content-Type','application/json');
        response.end(JSON.stringify({ok:true,activeJobs:jobs.size,maximumJobs:4,version:'0.4.0'}));return;
      }
      if(pathname.startsWith('/api/')) {
        if(request.method!=='POST')fail(405,'POST required');
        if(!['/api/query','/api/sample'].includes(pathname))fail(404,'Not found');
        // Reserve before reading the body, so slow uploads also consume a slot.
        if(jobs.size>=4)fail(429,'Four jobs already running');
        controller=new AbortController();jobs.add(controller);
        timer=setTimeout(()=>{controller.abort(Error('Job time limit reached'));response.destroy();},900000);
        const value=await body(request);
        if(controller.signal.aborted)throw Error('Client disconnected');
        if(pathname==='/api/query') {
          object(value,['server','options']);
          const result=await query(value.server,{...queryOptions(value.options),signal:controller.signal});
          response.setHeader('Content-Type','application/json');response.end(JSON.stringify({ok:true,value:result}));
        }else {
          const options=sampleOptions(value);
          response.setHeader('Content-Type','application/x-ndjson; charset=utf-8');
          for await(const round of sampleServers(value.servers,{...options,signal:controller.signal}))
            await line(response,{type:'round',...round},controller.signal);
          await line(response,{type:'done'},controller.signal);response.end();
        }
      }else {
        if(request.method!=='GET'&&request.method!=='HEAD')fail(405,'GET required');
        const asset=assets.get(pathname);if(!asset)fail(404,'Not found');
        const contents=await fs.readFile(new URL(asset,root));
        const extension=path.extname(asset);
        response.setHeader('Content-Type',({'.html':'text/html','.mjs':'text/javascript','.css':'text/css'}[extension]??'text/plain')+'; charset=utf-8');
        response.end(request.method==='HEAD'?undefined:contents);
      }
    }catch(error) {
      if(!response.destroyed) {
        if(response.headersSent)response.end(JSON.stringify({type:'error',error:error.message,code:error.code??'INPUT'})+'\n');
        else {
          response.statusCode=error.status??400;response.setHeader('Content-Type','application/json');
          response.end(JSON.stringify({ok:false,error:error.message,code:error.code??'INPUT'}));
        }
      }
    }finally {
      clearTimeout(timer);response.off('close',disconnect);
      if(controller){controller.abort();jobs.delete(controller);}
    }
  });
  server.requestTimeout=15000;server.headersTimeout=10000;server.keepAliveTimeout=2000;
  server.maxHeadersCount=40;server.maxRequestsPerSocket=200;
  await new Promise((resolve,reject)=>{server.once('error',reject);server.listen(port,'127.0.0.1',resolve);});
  return {
    server,url:'http://127.0.0.1:'+server.address().port,
    close:async()=>{
      for(const controller of jobs)controller.abort();
      server.closeAllConnections();
      await new Promise(resolve=>server.close(resolve));
    },
  };
}
if(process.argv[1]&&path.resolve(process.argv[1])===fileURLToPath(import.meta.url)) {
  if(process.argv.length>3)throw Error('Usage: node tools/serve.mjs [PORT]');
  const host=await startServer({port:Number(process.argv[2]??8775)});
  console.log('NTP workbench: '+host.url+'/web/');
  const stop=()=>{host.close().catch(error=>{console.error(error.message);process.exitCode=1;});};
  process.once('SIGINT',stop);process.once('SIGTERM',stop);
}
