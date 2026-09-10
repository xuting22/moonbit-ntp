# Contributing locally

This is an independent repository. Do not import or reference sibling repositories. Run `./verify.ps1 -MoonPath /absolute/path/to/moon` before committing. Add public-API regressions for behavioral changes; document unsupported syntax and observable errors. `moon fmt` and `moon info` must be idempotent. Generated JS must be rebuilt with the library.

Use `node tools/cli.mjs --help` for real file/stdin usage, `node tools/robustness.mjs` for bounded malformed inputs, and `node tools/benchmark.mjs` for the repeatable JS example benchmark. Benchmarks record the runtime and CPU and are not upstream performance comparisons.
