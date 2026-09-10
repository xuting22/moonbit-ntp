import {run} from '../web/engine.mjs';
import config from '../web/config.mjs';
const result=run(config.example);
if(!result||result.startsWith('ERROR:'))throw Error(result);
console.log(config.slug+': standalone engine passed');
