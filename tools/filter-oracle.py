"""Independent rational-input model of RFC 5905 sections 10/11.2.

The endpoint model counts interval membership directly, rather than running the
production endpoint scan. This is a specification oracle, not an ntpd binary.
"""
from pathlib import Path
import json
import math
import random

ROOT = Path(__file__).resolve().parents[1]
rng = random.Random(5905)

def snapshot(stages, now, accepted, reach, phi, precision):
    ordered = sorted(stages, key=lambda s: (s['delay'], -s['now']))
    valid = [s for s in ordered if s['delay'] < 16]
    if not valid:
        return None
    best = valid[0]
    errors = [min(16, s['dispersion'] + phi * (now - s['now'])) for s in ordered]
    errors += [16] * (8 - len(errors))
    dispersion = sum(v / 2 ** (i + 1) for i, v in enumerate(errors))
    jitter = max(precision, math.sqrt(sum((s['offset'] - best['offset']) ** 2
                                        for s in valid) / max(1, len(valid) - 1)))
    return dict(offset=best['offset'], delay=best['delay'], dispersion=dispersion,
                jitter=jitter, selected=best['now'], count=len(valid), reach=reach,
                fresh=accepted is None or best['now'] > accepted)

traces = []
for case in range(24):
    phi = [0, .000015, .00003][case % 3]
    stages, accepted, reach, operations = [], None, 0, []
    for step in range(24):
        now = 100 + step * 4
        reach = (reach << 1) & 255
        if reach & 7 == 0:
            stages.insert(0, dict(offset=0, delay=16, dispersion=16, now=now))
            stages = stages[:8]
        operations.append(dict(op='poll', now=now))
        # Include a long loss burst and ordinary gaps.
        if not (case % 4 == 0 and step >= 12) and rng.random() > .13:
            s = dict(offset=rng.randrange(-8, 9) / 4096,
                     delay=rng.randrange(1, 24) / 1024,
                     dispersion=rng.randrange(1, 8) / 1048576, now=now)
            stages.insert(0, s)
            stages = stages[:8]
            reach |= 1
            expected = snapshot(stages, now, accepted, reach, phi, .000001)
            operations.append(dict(op='observe', **s, expected=expected))
            if expected and expected['fresh']:
                accepted = expected['selected']
        operations.append(dict(op='state', now=now+2,
                               expected=snapshot(stages, now+2, accepted, reach, phi, .000001)))
    traces.append(dict(tolerance=phi, precision=.000001, operations=operations))

def combine(peers, minimum=1):
    valid = [p for p in peers if 0 < p['distance'] <= 1 and 1 <= p['stratum'] <= 15]
    if len(valid) < minimum:
        return None
    candidates = sorted({p['offset'] + sign * p['distance'] for p in valid for sign in [-1, 1]})
    interval = None
    for allowed in range((len(valid) - 1)//2 + 1):
        covered = [x for x in candidates if sum(p['offset']-p['distance'] <= x <=
                   p['offset']+p['distance'] for p in valid) >= len(valid)-allowed]
        if covered:
            low, high = min(covered), max(covered)
            outside = sum(not low <= p['offset'] <= high for p in valid)
            if low < high and outside == allowed:
                interval = low, high
                break
    if interval is None:
        return None
    low, high = interval
    survivors = sorted([p for p in valid if low <= p['offset'] <= high],
                       key=lambda p: (p['stratum']+p['distance'], len(p['id']), p['id']))
    rejected = [p['id'] for p in peers if p not in valid]
    rejected += [p['id'] for p in valid if p not in survivors]
    if len(survivors) < minimum:
        return None
    while True:
        n = len(survivors)
        jitters = [math.sqrt(sum((p['offset']-q['offset'])**2 for q in survivors) /
                            max(1, n-1)) for p in survivors]
        maximum = max(jitters)
        if n <= max(3, minimum) or maximum < min(p['jitter'] for p in survivors):
            break
        worst = max(i for i, value in enumerate(jitters) if value == maximum)
        rejected.append(survivors.pop(worst)['id'])
    scale = min(p['distance'] for p in survivors)
    weights = [scale / p['distance'] for p in survivors]
    total = sum(weights)
    return dict(offset=sum(w*p['offset'] for w,p in zip(weights,survivors))/total,
                jitter=math.sqrt(maximum**2+sum(w*p['jitter']**2 for w,p in zip(weights,survivors))/total),
                selectionJitter=maximum, low=low, high=high,
                peer=survivors[0]['id'], survivors=[p['id'] for p in survivors], rejected=rejected)

cases = []
for case in range(192):
    peers = []
    for i in range(1 + case % 12):
        peers.append(dict(id=f'p{i:02}', offset=rng.randrange(-16,17)/128 + (2 if i % 5 == 4 else 0),
                          distance=rng.randrange(1,65)/128,
                          jitter=rng.randrange(1,8)/4096, stratum=1+i%3))
    minimum = min(3, len(peers))
    cases.append(dict(peers=peers, minimum=minimum, expected=combine(peers,minimum)))

record = dict(source='Independent RFC 5905 statistical formulas with verified erratum 5600; explicit MAXDISP cap and deterministic tie policy',
              traces=traces, consensus=cases)
(ROOT/'evidence/filter-oracle.json').write_text(json.dumps(record, indent=2)+'\n',
                                               encoding='utf8', newline='\n')

def literal(value):
    raw = json.dumps(value, separators=(',',':'))
    return ' +\n    '.join(json.dumps(raw[i:i+1800]) for i in range(0,len(raw),1800))

code = '''// Generated from independent Python outcomes, not local engine output.
///|
fn[T : @json.FromJson] oracle_field(fields : Map[String, Json], name : String) -> T raise {
  @json.from_json(fields.get(name).unwrap_or(Json::null()))
}
///|
fn oracle_filter(actual : @ntp.FilterEstimate?, expected : Json) -> Unit raise {
  if expected == Json::null() { assert_true(actual is None); return }
  guard expected is Object(e) else { fail("expected oracle object") }
  let a = actual.unwrap()
  near(a.offset_seconds,oracle_field(e,"offset"))
  near(a.delay_seconds,oracle_field(e,"delay"))
  near(a.dispersion_seconds,oracle_field(e,"dispersion"))
  near(a.jitter_seconds,oracle_field(e,"jitter"))
  assert_eq(a.selected_at,oracle_field(e,"selected"))
  assert_eq(a.valid_samples,oracle_field(e,"count"))
  assert_eq(a.reach,oracle_field(e,"reach"))
  assert_eq(a.fresh,oracle_field(e,"fresh"))
}
///|
test "independent filter traces with loss aging and accepted epochs" {
  let source = TRACES
  let rows : Array[Json] = @json.from_json(@json.parse(source))
  for row in rows {
    guard row is Object(fields) else { fail("row object") }
    let filter = @ntp.ClockFilter::new(precision_seconds=oracle_field(fields,"precision"),frequency_tolerance=oracle_field(fields,"tolerance"))
    let operations : Array[Json] = oracle_field(fields,"operations")
    for operation in operations {
      guard operation is Object(o) else { fail("operation object") }
      let op : String = oracle_field(o,"op")
      let now : Double = oracle_field(o,"now")
      if op == "poll" { filter.begin_poll(now) }
      else if op == "observe" {
        oracle_filter(filter.observe({offset_seconds:oracle_field(o,"offset"),delay_seconds:oracle_field(o,"delay"),dispersion_seconds:oracle_field(o,"dispersion"),received_at:now}),o["expected"])
      } else { oracle_filter(filter.estimate(now),o["expected"]) }
    }
  }
}
///|
test "independent interval membership consensus and clustering" {
  let source = CONSENSUS
  let rows : Array[Json] = @json.from_json(@json.parse(source))
  for row in rows {
    guard row is Object(fields) else { fail("row object") }
    let values : Array[Json] = oracle_field(fields,"peers")
    let peers : Array[@ntp.PeerEstimate] = values.map(value => {
      guard value is Object(p) else { fail("peer object") }
      {id:oracle_field(p,"id"),offset_seconds:oracle_field(p,"offset"),
       root_distance_seconds:oracle_field(p,"distance"),jitter_seconds:oracle_field(p,"jitter"),stratum:oracle_field(p,"stratum")}
    })
    let answer=@ntp.combine_peers(peers,minimum=oracle_field(fields,"minimum"))
    if fields["expected"] == Json::null() { assert_true(answer is None) }
    else {
      guard fields["expected"] is Object(e) else { fail("result object") }
      let a=answer.unwrap()
      near(a.offset_seconds,oracle_field(e,"offset"))
      near(a.jitter_seconds,oracle_field(e,"jitter"))
      near(a.selection_jitter_seconds,oracle_field(e,"selectionJitter"))
      assert_eq(a.interval_low,oracle_field(e,"low"))
      assert_eq(a.interval_high,oracle_field(e,"high"))
      assert_eq(a.system_peer,oracle_field(e,"peer"))
      assert_eq(a.survivors,oracle_field(e,"survivors"))
      assert_eq(a.rejected,oracle_field(e,"rejected"))
    }
  }
}
'''
code = code.replace('TRACES',literal(traces)).replace('CONSENSUS',literal(cases))
(ROOT/'filter_golden_test.mbt').write_text(code,encoding='utf8',newline='\n')
print(len(traces),'filter traces,',sum(len(t['operations']) for t in traces),'operations,',len(cases),'consensus cases')
