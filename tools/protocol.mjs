import {protocol as core} from '../web/engine.mjs';

export function protocol(request) {
  const result=JSON.parse(core(JSON.stringify(request)));
  if(!result.ok) throw Error(result.error);
  return result.value;
}

export class ClockFilter {
  #id;#closed=false;
  constructor({precision=0.000001,tolerance=0.000015}={}) {
    this.#id=protocol({op:'filterOpen',precision,tolerance});
  }
  #call(op,options={}) {
    if(this.#closed) throw Error('Filter is closed');
    return protocol({op,id:this.#id,...options});
  }
  beginPoll(now) { this.#call('filterPoll',{now}); }
  observe({offsetSeconds,delaySeconds,dispersionSeconds,receivedAt}) {
    return this.#call('filterObserve',{offset:offsetSeconds,delay:delaySeconds,dispersion:dispersionSeconds,now:receivedAt});
  }
  estimate(now) { return this.#call('filterState',{now}); }
  distance(now,rootDelay,rootDispersion) {return this.#call('filterDistance',{now,rootDelay,rootDispersion});}
  close() { if(!this.#closed) {this.#call('filterClose');this.#closed=true;} }
}
export function combinePeers(peers,options={}) {
  return protocol({op:'combine',peers,...options});
}
