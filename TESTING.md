# Validation contract · 0.4.0

Run `./verify.ps1` on Windows. It formats, regenerates APIs, checks warning-free code, runs explicit JS/Wasm-GC tests, builds and copies the real JS engine, then checks the legacy demo/CLI, UDP, official reference replay, authentication/sampler/CLI, HTTP, malformed inputs and local benchmarks.

## Independent evidence

| Evidence | Scope |
|---|---|
| `reference-comparison.json` | 156 live executions of unmodified beevik/ntp v1.5.0 public APIs; 102 response and 54 MAC/key cases |
| `reference-replay.json` | The captured official outputs replayed against the current compiled engine, without Go or network |
| `reference_golden_test.mbt` | 102 response cases generated from official values, checked on both MoonBit backends |
| `filter-oracle.json` / `filter_golden_test.mbt` | Independent Python formula model: 24 traces / 1581 operations, 192 consensus cases; not a daemon oracle |
| `chrony-validation.json` | 16 real Chrony 4.8 cases: v2/v3/v4, six shared-key algorithms, authenticated extensions, bad key |
| `sync-host-validation.json` | Real local UDP, multi-source consensus, authenticated KoD, cancellation/handle cleanup, CLI/file limits |
| `http-validation.json` | HTTP-to-UDP, streamed rounds, bounds/origin checks, concurrency saturation and disconnect cleanup |
| `browser-validation.json` | Actual in-app browser actions, real Chrony query/auth/sample/cancel, export, Worker errors and responsive layout |
| `protocol-robustness.json` | 1062 bounded protocol cases; 1024 seeded random frames plus framing/resource boundaries |
| `sync-benchmark.json` | Warm JS + JSON bridge: 102 response analyses and worst-size 64-source clustering; no upstream performance claim |

Numeric response comparisons use 1.5 microseconds absolute tolerance. Three documented, field-specific era/signed-root-delay differences remain visible; any other discrepancy fails. Handwritten tests verify our expected values for those exceptions. The reference capture includes public synthetic keys only.

Regenerate local deterministic inputs:

```sh
python tools/generate-reference-cases.py
python tools/generate-reference-golden.py
python tools/filter-oracle.py
moon fmt
node tools/compare-reference.mjs --replay
```

Check regenerated files after formatting against the committed bytes. The Python oracle uses a fixed seed and binary-fraction inputs. Consensus expected results use interval membership at candidate endpoints independently of the production endpoint sweep.

To refresh official captures, build `tools/reference-probe` with Go 1.24+ using `go build -mod=mod`. It pins beevik/ntp 1.5.0; the helper supplies an in-memory net.Conn and two deterministic system times. Set `NTP_REFERENCE_COMMAND_JSON` to a JSON command array, then run `node tools/compare-reference.mjs`. The helper also supports real-server mode for `tools/test-chrony.mjs`. Capturing again changes random request nonces and thus raw capture hashes.

Chrony checks are optional integration checks, not started by verify. Use a dedicated loopback daemon with `-x` (no clock control), local stratum 10 and the public fixture keys listed in the test. Set `NTP_DAEMON_ADDRESS` and `NTP_REFERENCE_COMMAND_JSON`. Stop only that test daemon afterwards. Local stratum is an interoperability fixture and establishes no UTC accuracy.

Provenance records archive/RFC/dependency SHA-256 and verifies every extracted upstream file unchanged. No upstream implementation, compiler or Go binary is bundled. The committed proof manifest hashes Git blobs, excluding itself. `python tools/check-proof.py` checks it without network.

Historical evidence and coverage files remain historical unless named in the new manifest's validation list. The older 307-input robustness suite exercises only the legacy hex demo. Remote CI and other repositories were not run.
