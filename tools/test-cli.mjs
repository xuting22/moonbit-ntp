import {spawnSync} from 'node:child_process';
import fs from 'node:fs';import os from 'node:os';import path from 'node:path';import assert from 'node:assert/strict';
import {fileURLToPath} from 'node:url';import config from '../web/config.mjs';import {run} from '../web/engine.mjs';
const here=path.dirname(fileURLToPath(import.meta.url)),cli=path.join(here,'cli.mjs');
function invoke(args,input){return spawnSync(process.execPath,[cli,...args],{input,encoding:'utf8',timeout:15000})}
const expected=run(config.example);assert(!expected.startsWith('ERROR:'));
for(const args of [['--input',config.example,'--json'],['--json']]){const r=invoke(args,config.example);assert.equal(r.status,0,r.stderr);assert.deepEqual(JSON.parse(r.stdout),{ok:true,output:expected})}
const folder=fs.mkdtempSync(path.join(os.tmpdir(),'moonbit-cli-'));const file=path.join(folder,'input.txt');
try{fs.writeFileSync(file,config.example);const r=invoke(['--file',file,'--json']);assert.equal(r.status,0,r.stderr);assert.equal(JSON.parse(r.stdout).output,expected)}finally{fs.unlinkSync(file);fs.rmdirSync(folder)}
assert.equal(invoke(['--help']).status,0);assert.equal(invoke(['--unknown']).status,1);assert.equal(invoke(['--file']).status,1);assert.equal(invoke(['--input','x','--input','y']).status,1);
const malformed=fs.readFileSync(path.join(here,'invalid-input.txt'),'utf8');const r=invoke(['--json'],malformed);assert.equal(r.status,2,r.stdout+r.stderr);assert.equal(JSON.parse(r.stdout).ok,false);
console.log(config.slug+': CLI input/file/stdin/error/exit-status checks passed');
