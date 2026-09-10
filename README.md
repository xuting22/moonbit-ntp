# NTP/SNTP 协议核心

NTPv4 报文、时间戳与四时间戳校时算法。本地候选版 0.2.0，供比较和代码审查；尚未作为完整竞赛作品提交。

## 运行

安装 MoonBit 后在本目录执行：

```sh
moon check
moon test
moon run cmd/main
```

也可在本目录运行 `./verify.ps1` 验证本项目。`pkg.generated.mbti` 是真实工具链生成的公共 API。命名空间 `localreview` 仅用于本地，正式发布前应替换为申请人的账号。

## 本版范围

实现目标：48 字节包、era 显式时间戳、请求响应验证、offset/delay。

未承诺：UDP 适配器、NTS 认证、操作系统时钟修改、长期滤波。

## 来源与实现方式

规格/算法参考：https://www.rfc-editor.org/rfc/rfc5905。

当前代码是本地新写的 MoonBit 实现，不声称是上游完整移植；未复制上游源代码、词库或测试集。测试输入为本项目新写。MIT 仅适用于本目录原创代码。将来如移植上游文件，需要另行保存其版权声明并核查许可证，不能直接沿用当前说明。

## 审查

先看 `cmd/main/main.mbt` 的实际使用，再看公共 API 与测试文件。联网兼容性、性能数据或官方验收未执行的部分不得从本地单元测试成功推断。

## 下一阶段与明确限制

补 UDP 客户端、多服务器采样、KoD 类型处理、NTS 和时钟滤波。当前四时间戳算法要求网络耗时非负、单次采样不超过一天，显式拒绝扩展字段。

本分装包自带 `web/index.html`（用 `start-review.ps1` 启动）。`cmd/web/main.mbt` 为薄适配层，网页调用编译后的真实 MoonBit 模块。

## 独立分装使用

本文件夹可以单独移动或建立仓库，不依赖其他候选项目。浏览器演示已编译，无须安装 MoonBit 即可试用（需要 Python 3）：

```powershell
./start-review.ps1
```

打开 http://127.0.0.1:8775/web/ 。修改和测试源码需安装 MoonBit 与 Node.js，再运行 `./verify.ps1`。本机尚未将 MoonBit 加入 PATH 时，可传入 `-MoonPath`。独立包不捆绑编译器。

仅含本项目源码和构建产物；没有上传仓库或发布包。`DUPLICATION.md`、`evidence/current-validation.json` 和本次分装清单 提供查重、测试和完整性资料。

## 独立仓库工作流

本目录是该项目后续开发的唯一主仓库，旧批次目录及 ZIP 为历史审查快照。没有 Git remote，没有共享构建目录，没有上级 moon.work。

真实 CLI 支持输入参数、文件和标准输入：

```powershell
node tools/cli.mjs --help
node tools/cli.mjs --file sample.txt --json
```

需要安装 MoonBit 后传 `-MoonPath` 或将 moon 加入 PATH；不依赖工作区之外的私有脚本。详见 [TESTING.md](TESTING.md) 和 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 本轮功能升级

增加最低有效往返延迟样本选择，过滤 NaN、无穷和负延迟。

单阶段选择器，不是完整 RFC 时钟过滤算法；没有 UDP 和系统校时。

[可执行 API 示例](README.mbt.md)会随测试运行；[功能边界](FEATURES.md)和[测试说明](TESTING.md)用于独立审查。网页与 CLI 展示示例入口，新 API 的完整使用见可执行示例。


## 0.3.0 本地开发更新：UDP 查询

新增 `tools/udp-client.mjs`，Node 24 宿主调用真实 MoonBit 请求编解码和四时间戳计算。支持 IPv4/IPv6、端口、截止时间和 AbortSignal。连接式 UDP 只接收所选端点；核对 origin，识别 RATE 等拒绝码，拒绝未同步、错误模式和缺失时间戳。接收时间使用发送时墙钟加单调时钟间隔，避免查询途中系统时间跳变。

```js
import {query} from './tools/udp-client.mjs';
const sample = await query('your-ntp-server.example', {timeoutMs:3000});
console.log(sample.offsetSeconds, sample.delaySeconds);
```

返回时间偏移、往返延迟、发送时间、层级、闰秒标志及根延迟/离散度。不会调整操作系统时钟，不自动重试。当前只接受 48 字节基础报文；尚无 MAC/NTS、扩展字段、完整时钟过滤和独立 NTP daemon 互操作证明。

本轮只运行 `node tools/test-udp.mjs` 的 4 组本机 UDP 验证；未重跑双后端全套、性能、覆盖率或其他 19 仓库。原审查 ZIP/bundle 仍是前一打包版本，最新实现以本目录 Git 提交为准。


开发更新：`Packet::validate_health()` 检查参考时间非零、不得晚于发送时间、年龄不超过 131072 秒，以及根延迟的一半加根离散度不超过 16 秒。`root_distance(sample)` 返回单样本总同步距离。UDP 查询现在执行这些检查，并返回 `rootDistanceSeconds`。阈值依据 [beevik/ntp Validate](https://github.com/beevik/ntp/blob/main/ntp.go)；这里按公开行为重新实现，没有复制源代码。尚不包括认证有效性、多样本抖动、系统时钟驯服或全部上游查询选项。

本次仅运行新增 health limits 测试组（4 类错误及 1 个独立数值结果），通过；旧测试未重复运行，未重新打包。


查询更新：发送时间字段使用 64 位密码学随机值作响应匹配，真实本地发送时间不放到线路上；先核对服务器原样回显，再用本地时间计算偏移和延迟。`query` 新增 `version:3|4`、`localAddress`、`localPort`、`ttl`（IPv4，1–255）选项。地址族不符或无效选项会拒绝。相同本地时刻的重复请求也生成不同随机值；这不是 MAC/NTS 身份认证，不能替代它们。

本轮仅通过新增 nonce/source/version 测试组，覆盖两次独立匹配和时间计算、错误 origin 与无效选项。未重跑其他组或重打包。
