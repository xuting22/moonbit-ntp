# 多来源 NTP 时钟健康观测

**本项目仓库：[https://github.com/xuting22/moonbit-ntp](https://github.com/xuting22/moonbit-ntp)**

模块 `xuting22/ntp`，本地版本 **0.4.0**，MIT。当前评审状态：**保留候选**。本文件是当前入口，旧轮次说明与详细用法保存在 [历史/完整使用说明](README-BEFORE-VALUE-REWORK.md)。

## 解决什么任务

应用节点需要知道与时间源的偏差、往返延迟及不确定度，而无需本工具直接修改系统时钟。多源过滤可以暴露单个异常时间源。

需要应用层时钟健康指标、保留多源观测及不确定度时使用；不取代操作系统的 chronyd/NTS 校时。

## 直接复现

安装 MoonBit 和 Node.js 24，在本仓库根目录运行：

```sh
moon build --target js
node -e "require('node:fs').copyFileSync('_build/js/debug/build/cmd/web/web.js','web/engine.mjs')"
node examples/run-use-case.mjs
```

流程：**多时间源估计的离线复核**。运行器创建新的系统临时目录，保留每一步的 stdout/stderr、产物及 `report.json`，打印实际目录；重复运行不会覆盖之前产物。它只执行仓库内的本地样例，不连接公网或发送消息。`report.json` 的 `expected` 是应观察的结果，实际结果在各步输出中；成功退出不替代内容核对。

输入性质：原创合成观测值；不连接公共时间源、不修改系统时钟。

应观察：保留约 10/20/30 ms 的一致来源，排除偏离 1 秒的 clock3；输出不确定度。

具体命令和输入路径见 [使用任务](USE-CASE.md) 与 [机器可读流程](examples/use-case.json)。只把这个脚本当复现入口，不把通用运行器计作核心技术贡献。

## 实现与已有项目的关系

MoonBit 负责报文/时间戳、八级过滤和多来源选择；Node 负责 UDP、认证 MAC 和采样调度。

本轮未找到同范围 MoonBit NTP/SNTP 包。贡献是观测接口和组合采样工作流，不是发明 NTP 或替代系统校时守护程序。

同类项目和检索边界见 [DUPLICATION](DUPLICATION.md)。查重用于避免错误的首创表述；关键词零结果不能证明生态空白，Node 宿主能力也不计为 MoonBit 原生 I/O。

库使用从 [公共 API](pkg.generated.mbti) 和根包源码开始；可在本 checkout 的消费包中导入 `"xuting22/ntp"`。源码中的网络/文件宿主入口及完整参数仍见 [完整使用说明](README-BEFORE-VALUE-REWORK.md)。是否已发布到 Mooncakes 需另核实，本文不把 `moon add` 的下载成功作为已完成事项。

## 验证与边界

前一轮工程验证 8 组真实本机 UDP/MAC、多源异常钟剔除、KoD 和 CLI 检查通过，不连接公共 NTP 服务。

[上一轮工程验证](evidence/innovation-review-20260922/results.json) 与 [本轮最小任务回执](evidence/value-rework-20260922/use-case.json) 分开。历史参考版本、golden 重放、本机 peer、真实第三方服务端和本次样例是不同证据，不能合并成“全部生产验证”。

常规核心检查可运行 `moon check --target js`、`moon test --target js`、`moon test --target wasm-gc`。专项命令：

```sh
node tools/test-sync.mjs
```

专项所需的参考环境和历史版本见原使用说明及 TESTING 文档；本轮回执只记录实际执行项，不声称上面所有参考服务在任意环境即装即跑。

没有 NTS，不等同 chronyd；估计值会受网络不对称等影响。认证 MAC 的覆盖与系统时钟精度分开。

## 复审材料状态

无生产精度或公共时间源稳定性承诺，网络不对称会影响结果。

2026-09-22 匿名新克隆成功；默认分支 `main`，核验公开提交 `8bac5002d565d77aba8d68985fee402a62870714`。本轮源码修订仅在本地，尚未推送；此记录不证明当时报名表中的地址正确，也不证明新修订已上线。

[申报草稿](PROPOSAL.md) 已压缩为 30 行以内，并单独标明本项目仓库；[复核说明](REVIEW-RESPONSE.md) 区分材料错误、功能变化及尚未解决的问题。没有编造用户、设备接入、生产部署或评审认可。
