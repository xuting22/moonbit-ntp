"""Verify downloaded reference materials. Run with an external reference folder."""
import hashlib,json,shutil,sys,zipfile
from pathlib import Path
from urllib.parse import urlsplit
root=Path(__file__).resolve().parents[1]
source=Path(sys.argv[1]).resolve()
digest=lambda b:hashlib.sha256(b).hexdigest()
sources=json.loads((source/'sources.json').read_text(encoding='utf8'))
dependencies=json.loads((source/'dependencies.json').read_text(encoding='utf8'))
for item in sources:
    assert digest((source/item['file']).read_bytes())==item['sha256'],item['file']
for item in dependencies:
    file=source/'proxy'/urlsplit(item['url']).path.lstrip('/')
    assert digest(file.read_bytes())==item['sha256'],str(file)
count=0
with zipfile.ZipFile(source/'beevik-v1.5.0.zip') as archive:
    for entry in archive.infolist():
        if entry.is_dir():continue
        assert archive.read(entry)==(source/entry.filename).read_bytes(),entry.filename
        count+=1
target=root/'tools/reference-probe';target.mkdir(exist_ok=True)
for name in ['main.go','go.sum']:
    (target/name).write_text((source/'probe'/name).read_text(encoding='utf8'),encoding='utf8',newline='\n')
mod=(source/'probe/go.mod').read_text(encoding='utf8').split('\nreplace ')[0].rstrip()+'\n'
(target/'go.mod').write_text(mod,encoding='utf8',newline='\n')
record={'sources':sources,'dependencies':dependencies,'unchangedUpstreamFiles':count,
        'helperSHA256':digest((target/'main.go').read_bytes()),
        'executedHelperSHA256':digest((source/'probe/main.go').read_bytes()),
        'reference':'beevik/ntp v1.5.0', 'goRuntime':'go1.26.0 linux/amd64',
        'build':'Official source extracted externally; local go.mod replace only. Dependency file proxy; unchanged upstream bytes verified against archive. No upstream implementation bundled in this repository.',
        'algorithms':'Authored MoonBit implementation from RFC 5905 sections 10/11.2 and verified erratum 5600; Python filter oracle is an independent mathematical model, not an ntpd execution.',
        'erratum':'https://errata.rfc-editor.org/eid5600/',
        'chrony':'Chrony 4.8 Ubuntu package, independent unprivileged process with -x, loopback UDP 43123, local stratum 10. Does not establish UTC accuracy.'}
(root/'evidence/reference-provenance.json').write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf8',newline='\n')
print(count,'upstream files and',len(sources)+len(dependencies),'download hashes verified')
