"""Regenerate deterministic cases, format/APIs and engine; reject any byte drift."""
import hashlib,shutil,subprocess,sys
from pathlib import Path
root=Path(__file__).resolve().parents[1]
files=[p for p in root.rglob('*') if p.is_file() and
       not any(part in ['_build','.git','.mooncakes','target'] for part in p.relative_to(root).parts) and
       (p.suffix in ['.mbt','.mbti'] or p.name in ['moon.mod','moon.pkg','reference-cases.json','filter-oracle.json','engine.mjs'])]
digest=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
before={str(p.relative_to(root)):digest(p) for p in files}
for script in ['generate-reference-cases.py','generate-reference-golden.py','filter-oracle.py']:
    subprocess.run([sys.executable,str(root/'tools'/script)],cwd=root,check=True)
for args in [['fmt'],['info'],['build','--target','js','--deny-warn']]:
    subprocess.run(['moon',*args],cwd=root,check=True)
engine=root/'_build/js/debug/build/cmd/web/web.js'
assert engine.is_file(),str(engine)
shutil.copyfile(engine,root/'web/engine.mjs')
changed=[name for name,old in before.items() if digest(root/name)!=old]
if changed:raise RuntimeError('Generated drift: '+', '.join(changed))
print(len(files),'generator/format/API/engine files byte-idempotent')
