"""Project-authored public probe inputs; no upstream test corpus or keys."""
from pathlib import Path
import json
import math
import struct

def stamp(value):
    whole = math.floor(value)
    return struct.pack('!II', (whole + 2208988800) & 0xffffffff,
                       int((value - whole) * 2**32))

def reply(sent, offset=.1, rtt=.2, processing=.01, version=4,
          root_delay=0, dispersion=.001, precision=-20, poll=6,
          reference_id=0x7f000001, stratum=2, leap=0):
    end = sent + rtt + processing
    wire = struct.pack('!BBbbiII', (leap << 6) | (version << 3) | 4,
                       stratum, poll, precision, int(root_delay * 65536),
                       int(dispersion * 65536), reference_id)
    wire += stamp(sent - 30) + bytes(8)
    wire += stamp(sent + offset + rtt / 2)
    wire += stamp(sent + offset + rtt / 2 + processing)
    return wire, end

cases = []
def add(name, sent=1800000000.0, **options):
    raw, end = reply(sent, **options)
    row = dict(name=name, kind='response', replyHex=raw.hex(),
               sentUnix=sent, receivedUnix=end, version=options.get('version', 4))
    cases.append(row)
    return row

for offset in [-4, -.125, 0, .001, 3]:
    for rtt in [.001, .05, .4]:
        for processing in [0, .02]:
            for version in [2, 3, 4]:
                add(f'offset={offset} rtt={rtt} processing={processing} v={version}',
                    offset=offset, rtt=rtt, processing=processing, version=version)
for name, options in [
    ('stratum-one reference', dict(stratum=1, reference_id=0x47505300)),
    ('negative signed root delay', dict(root_delay=-.25)),
    ('fractional poll exponent', dict(poll=-6)),
    ('very fine precision', dict(precision=-40)),
    ('leap unsynchronized', dict(leap=3)),
    ('invalid stratum', dict(stratum=16)),
    ('excessive root dispersion', dict(dispersion=17)),
    ('kiss RATE', dict(stratum=0, reference_id=0x52415445)),
]:
    row = add(name, **options)
    if name == 'negative signed root delay':
        row['intentionalDifference'] = 'RFC signed 16.16 root delay versus beevik unsigned interpretation'
        row['differenceFields'] = ['rootDelaySeconds', 'rootDistanceSeconds', 'health acceptance']
    if name == 'very fine precision':
        row['intentionalDifference'] = 'Sub-nanosecond precision remains positive; Go duration truncates to zero'
        row['differenceFields'] = ['precisionSeconds']
for sent in [2085978495.875, 2085978496.25, 1000.25, -1.25]:
    row = add(f'era pivot {sent}', sent=sent, offset=.25, rtt=.5, processing=.02)
    if sent < 0:
        row['intentionalDifference'] = 'Local pivot resolves pre-1970; beevik absolute time assumes era 1 for raw values before 1970'
        row['differenceFields'] = ['referenceUnix', 'serverTransmitUnix']
    if sent == 2085978495.875:
        row['intentionalDifference'] = 'Modular first-order differences avoid the reference minError unsigned comparison across the 2036 era boundary'
        row['differenceFields'] = ['minimumErrorSeconds']
for kind, size in [('MD5', 16), ('SHA1', 20), ('SHA256', 20),
                   ('SHA512', 20), ('AES128', 16), ('AES256', 32)]:
    for label, key in [
        ('hex', 'HEX:' + bytes(range(size)).hex()),
        ('ascii', 'ASCII:' + 'k' * size),
        ('long', 'ASCII:' + 'z' * 80),
        ('short', 'ASCII:x'),
        ('malformed', 'HEX:0z'),
    ]:
        row = add(kind + ' ' + label)
        row['kind'] = 'auth'
        row['auth'] = dict(type=kind, key=key, keyID=12345)
    for length in [16, 20, 24, 28]:
        row = add(kind + ' extension bytes ' + str(length))
        row['kind'] = 'auth'
        row['auth'] = dict(type=kind, key='HEX:' + bytes(range(size)).hex(), keyID=12345)
        row['extensionHex'] = (struct.pack('!HH', 0x1234, length) + bytes(length-4)).hex()
path = Path(__file__).with_name('reference-cases.json')
path.write_text(json.dumps(cases, indent=2) + '\n', encoding='utf8', newline='\n')
print(len(cases), 'reference inputs')
