"""Generate cross-backend cases from captured official Go outputs, not ours."""
import json
from pathlib import Path
root=Path(__file__).resolve().parents[1]
record=json.loads((root/'evidence/reference-comparison.json').read_text(encoding='utf8'))
mapping={
 'delaySeconds':'a.sample.delay_seconds','offsetSeconds':'a.sample.offset_seconds',
 'minimumErrorSeconds':'a.minimum_error_seconds','serverTransmitUnix':'a.server_transmit_unix',
 'referenceUnix':'a.reference_unix','precisionSeconds':'a.precision_seconds',
 'pollSeconds':'a.poll_seconds','rootDistanceSeconds':'a.root_distance_seconds',
 'rootDelaySeconds':'p.root_delay.to_double() / 65536.0',
 'rootDispersionSeconds':'p.root_dispersion.to_double() / 65536.0',
 'referenceID':'p.reference_id.to_double()',
}
lines=['// Generated from official beevik/ntp v1.5.0 captures. Do not hand edit.']
count=0
for row in record['rows']:
    if row['input']['kind']=='auth': continue
    assert 'error' not in row['reference']
    inp=row['input'];ref=row['reference'];skip={d['field'] for d in row['differences']}
    assert skip.issubset(set(inp.get('differenceFields',[])))
    name=json.dumps('official reference '+inp['name'])
    wire=''.join('\\x%02x'%b for b in bytes.fromhex(inp['replyHex']))
    lines+=['','///|',f'test {name} {{',f'  let p = @ntp.decode(b"{wire}")',
            f'  let sent = @ntp.from_unix({float(inp["sentUnix"])}).0',
            f'  let a = @ntp.analyze(sent, {{ ..p, origin: sent }}, @ntp.from_unix({float(inp["receivedUnix"])}).0, {float(inp["receivedUnix"])})']
    for key,value in ref['value'].items():
        if key in skip:
            lines.append('  // Documented reference difference: '+key)
        elif key in mapping:
            lines.append(f'  near({mapping[key]}, {float(value)}, tolerance=0.0000015)')
        elif key in ['version','leap','stratum']:
            lines.append(f'  assert_eq(p.{key}, {value})')
        elif key=='referenceString':
            lines.append('  assert_eq(a.reference_string, '+json.dumps(value,ensure_ascii=False)+')')
        else: raise ValueError(key)
    if 'health acceptance' not in skip:
        lines+=['  let healthy = try { p.validate_health(); true } catch { _ => false }',
                '  assert_eq(healthy, '+('false' if ref.get('healthError') else 'true')+')']
    lines.append('}')
    count+=1
(root/'reference_golden_test.mbt').write_text('\n'.join(lines)+'\n',encoding='utf8',newline='\n')
print(count,'official response cases generated; only documented fields excluded')
