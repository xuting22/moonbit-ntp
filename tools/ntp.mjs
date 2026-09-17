import {readInput as read} from './read-input.mjs';
import {query} from './udp-client.mjs';
import {sampleServers} from './sampler.mjs';
import {protocol} from './protocol.mjs';

const control=new AbortController();
const interrupt=()=>control.abort(Error('Interrupted'));
process.once('SIGINT',interrupt);
process.once('SIGTERM',interrupt);
const write=value=>new Promise((resolve,reject)=>process.stdout.write(JSON.stringify(value)+'\n',
  error=>error?reject(error):resolve()));
let failed=false;
try {
  const args=process.argv.slice(2),mode=args.shift();
  if(!mode||mode==='--help') {
    console.log('Usage: node tools/ntp.mjs query SERVER [--timeout MS] [--version 2|3|4] [--family 4|6] [--auth-file FILE]\n'+
      '       node tools/ntp.mjs sample SERVER... [--rounds N] [--interval MS] [--minimum N] [--concurrency N] [--no-poll-wait] [--config FILE]\n'+
      '       node tools/ntp.mjs decode --file HEX_FILE [--mac-length 0|4|20|24]\n'+
      '       node tools/ntp.mjs replay --file JSON_FILE\n'+
      'JSON output; samples stream one round per line with stdout backpressure.\n'+
      'Config: {servers:[address or {id,address,options}],options:{...sampler options}}.\n'+
      'Authentication file: {type,keyID,key}; never put secret keys on a command line.\n'+
      'Defaults: 8 rounds, 64000ms interval, advertised poll spacing respected.\n'+
      '--no-poll-wait explicitly disables advertised spacing; KoD backoff always applies.\n'+
      'Exit codes: 0 success, 1 input/transport error, 2 no final consensus, 130 interrupted.');
  }else {
    if(!['query','sample','decode','replay'].includes(mode))throw Error('Unknown command');
    const addresses=[],flags={};
    for(let i=0;i<args.length;i++) {
      const value=args[i];
      if(value==='--no-poll-wait') {
        if(flags.noPollWait)throw Error('Duplicate option '+value);
        flags.noPollWait=true;continue;
      }
      if(value.startsWith('--')) {
        if(!['--timeout','--version','--family','--auth-file','--rounds','--interval','--minimum',
          '--concurrency','--config','--file','--mac-length'].includes(value)||i+1>=args.length)
          throw Error('Unknown or incomplete option '+value);
        if(value in flags)throw Error('Duplicate option '+value);
        flags[value]=args[++i];
      }else addresses.push(value);
    }
    const allowed={
      query:['--timeout','--version','--family','--auth-file'],
      sample:['--timeout','--version','--family','--auth-file','--rounds','--interval','--minimum','--concurrency','--config','noPollWait'],
      decode:['--file','--mac-length'],replay:['--file'],
    }[mode];
    if(Object.keys(flags).some(key=>!allowed.includes(key)))throw Error('Option does not apply to this command');
    if(mode==='decode'||mode==='replay') {
      if(addresses.length)throw Error('Unexpected positional argument');
      const input=await read(flags['--file']);
      if(mode==='decode')await write(protocol({op:'decode',hex:input,macLength:Number(flags['--mac-length']??0)}));
      else {
        const value=JSON.parse(input);
        if(!Array.isArray(value)||value.length>4096)throw Error('Replay must be an array of up to 4096 protocol requests');
        for(const request of value) {
          if(control.signal.aborted)throw Error('Interrupted');
          try{await write({ok:true,value:protocol(request)});}catch(error){failed=true;await write({ok:false,error:error.message});}
        }
        process.exitCode=failed?1:0;
      }
    }else {
      const queryOptions={};
      for(const [flag,key] of [['--timeout','timeoutMs'],['--version','version'],['--family','family']])
        if(flag in flags)queryOptions[key]=Number(flags[flag]);
      if(flags['--auth-file'])queryOptions.auth=JSON.parse(await read(flags['--auth-file']));
      if(mode==='query') {
        if(addresses.length!==1)throw Error('query requires exactly one server');
        await write(await query(addresses[0],{...queryOptions,signal:control.signal}));
      }else {
        let servers=addresses,options={};
        if(flags['--config']) {
          if(addresses.length)throw Error('Do not mix config and positional servers');
          const config=JSON.parse(await read(flags['--config']));
          if(!config||typeof config!=='object'||Array.isArray(config)||
             Object.keys(config).some(key=>!['servers','options'].includes(key)))throw Error('Invalid sampler config');
          servers=config.servers;options=config.options??{};
          if(!options||typeof options!=='object'||Array.isArray(options)||
             Object.keys(options).some(key=>!['rounds','intervalMs','concurrency','minimum','maximumDistance','respectPoll','queryOptions'].includes(key)))
            throw Error('Invalid sampler config options');
        }
        options={...options,queryOptions:{...options.queryOptions,...queryOptions},signal:control.signal};
        for(const [flag,key] of [['--rounds','rounds'],['--interval','intervalMs'],['--minimum','minimum'],['--concurrency','concurrency']])
          if(flag in flags)options[key]=Number(flags[flag]);
        if(flags.noPollWait)options.respectPoll=false;
        let last;
        for await(const round of sampleServers(servers,options)) {last=round;await write(round);}
        process.exitCode=last?.consensus?0:2;
      }
    }
  }
}catch(error) {
  process.stderr.write(JSON.stringify({ok:false,error:error.message,code:error.code??'INPUT'})+'\n');
  process.exitCode=control.signal.aborted?130:1;
}finally {
  process.removeListener('SIGINT',interrupt);
  process.removeListener('SIGTERM',interrupt);
}
