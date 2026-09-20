# MoonBit NTP · 时间观测台

> 2026-09-21 本地构建修复：命令包 import 已同步到当前 moon.mod 模块名；moon info/check、JS 构建、MoonBit 示例和 Node 引擎示例通过。算法未改，本轮未重跑历史全部行为/性能套件。当前提交指纹见 evidence/module-import-fix.json。

本地版本 **0.4.0**。MoonBit 实现报文与时间戳计算、八级时钟过滤和多来源选择；Node 宿主提供带认证的 UDP 查询、连续采样和本地工作台。所有接口返回估计值，不修改系统时钟。

## 开始使用

安装 Node.js 20 或更新版本，无需安装 MoonBit 即可运行随仓库提供的真实编译产物：

```sh
node tools/serve.mjs 8775
```

打开 http://127.0.0.1:8775/web/ 。Windows 也可运行 `./start-review.ps1`。页面支持单次查询、实时采样、停止、认证文件、结果导出、离线合成示例与 Worker 报文检视。启动和打开页面不会自动查询时间服务器。

```sh
node tools/ntp.mjs query your-authorized-server.example --timeout 3000
node tools/ntp.mjs sample server-a.example server-b.example server-c.example --minimum 3
node tools/ntp.mjs decode --file sample.txt
node tools/ntp.mjs --help
```

采样默认 8 轮、间隔 64 秒，遵守服务器公布的最短轮询间隔。初始过滤器含未知样本，因此早期不确定度较大，可能暂时没有共识。`--no-poll-wait` 仅用于获准的测试服务；KoD 退避仍然生效。

## 作为库使用

```js
import {query} from './tools/udp-client.mjs';
import {sampleServers} from './tools/sampler.mjs';
const control = new AbortController();
const result = await query('your-authorized-server.example', {
  timeoutMs: 3000, version: 4, signal: control.signal,
});
console.log(result.offsetSeconds, result.delaySeconds);
for await (const round of sampleServers(['server-a.example','server-b.example','server-c.example'], {
  minimum: 3, signal: control.signal,
})) console.log(round.consensus);
// Call control.abort() to interrupt a pending query or poll wait.
```

MoonBit 公共 API、可执行示例分别见 [pkg.generated.mbti](pkg.generated.mbti) 和 [README.mbt.md](README.mbt.md)。旧 `tools/cli.mjs` 保留报文示例的参数、文件与 stdin 接口；新 `tools/ntp.mjs` 提供查询、采样、文件解析及 JSON 重放。

## 已验证的范围

- JS、Wasm-GC 都运行官方参考数值回归和独立数学模型回归。
- beevik/ntp 1.5.0 的 156 个官方执行结果：153 个在数值容差 1.5 µs 内一致，3 个字段级差异有记录，0 个未解释差异。
- 独立 Chrony 4.8：16 项本机互通检查，涵盖 NTP 2/3/4、六种认证、带认证的未知扩展字段和错误密钥拒绝。
- 24 条时钟过滤轨迹、1581 个操作及 192 个来源共识案例；宿主、CLI、HTTP、浏览器均有各自证据。

这些结果不等于完整 NTP daemon 兼容性或 UTC 精度证明。详见 [TESTING.md](TESTING.md)、[FEATURES.md](FEATURES.md)、[HOST.md](HOST.md) 和 [ROADMAP.md](ROADMAP.md)。

## 构建与审查

```sh
moon fmt
moon info
moon test --target js --deny-warn
moon test --target wasm-gc --deny-warn
moon build --target js --deny-warn
```

Windows 完整检查：`./verify.ps1 [-MoonPath /absolute/path/to/moon.exe]`。它重建网页引擎并执行本机检查，不需要公网时间服务。最终提交的证据可用 `python tools/check-proof.py` 验证 Git blob 哈希。参考比较可以完全离线重放。

本项目依据 [RFC 5905](https://www.rfc-editor.org/rfc/rfc5905)、[RFC 7822](https://www.rfc-editor.org/rfc/rfc7822)、[RFC 8573](https://www.rfc-editor.org/rfc/rfc8573) 和 [已确认勘误 5600](https://errata.rfc-editor.org/eid5600/) 独立实现。没有复制 beevik 或 Chrony 实现源码。参考调用助手是本项目编写，使用官方公开 API；来源完整性见 `evidence/reference-provenance.json`。

本目录为独立本地 Git 仓库，没有 remote、上传、公开发布或比赛提交。旧 ZIP/bundle 与旧批次目录保持历史状态；当前实现以本目录提交为准。MIT 适用于原创代码，第三方依赖保留各自许可证。
