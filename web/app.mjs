import config from './config.mjs';
import {run} from './engine.mjs';
const $=id=>document.getElementById(id);
$('title').textContent=config.title+' · '+config.version;
$('scope').textContent=config.scope;
$('limits').textContent='当前不包含：'+config.limitations;
$('input').value=config.example;
function execute(){
 try{const start=performance.now(),output=run($('input').value);$('output').textContent=output;$('output').className=output.startsWith('ERROR:')?'error':'';$('status').textContent='执行 '+(performance.now()-start).toFixed(2)+' ms';$('tiles').hidden=true;
 if(config.slug==='wfc'&&!output.startsWith('ERROR:')){const rows=output.split('\n').slice(0,12);if(rows.every(x=>/^[~.^]{16}$/.test(x))){$('tiles').replaceChildren();for(const c of rows.join('')){const tile=document.createElement('span');tile.style.background={'~':'#446e83','.':'#99b984','^':'#c3b999'}[c];$('tiles').append(tile)}$('tiles').hidden=false}}
 }catch(e){$('output').textContent=String(e);$('output').className='error'}
}
$('run').onclick=execute;$('reset').onclick=()=>{$('input').value=config.example;execute()};execute();
