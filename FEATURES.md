# 功能与兼容性边界

## 新增能力

增加最低有效往返延迟样本选择，过滤 NaN、无穷和负延迟。

## 尚未达到上游的部分

单阶段选择器，不是完整 RFC 时钟过滤算法；已提供 Node UDP 查询；不操作系统时钟。已有基础能力参见 README 与生成的 `pkg.generated.mbti`。

## 工程交付范围

独立 Git 仓库、独立构建目录、可执行文档、Wasm-GC/JS 测试、真实编译的浏览器与 CLI、边界输入检查、样例基准、CI 配置均随仓库交付。运行记录见 evidence；配置 CI 不代表远端 CI 已运行。没有公开发布或比赛验收结论。


0.3.0：新增真实 UDP 查询、IPv4/IPv6、超时/取消、origin 匹配、KoD 错误码、四时间戳结果。只完成针对性本机测试；完整时钟过滤、认证与扩展、第三方 daemon 互操作仍待补齐。


开发更新：`Packet::validate_health()` 检查参考时间非零、不得晚于发送时间、年龄不超过 131072 秒，以及根延迟的一半加根离散度不超过 16 秒。`root_distance(sample)` 返回单样本总同步距离。UDP 查询现在执行这些检查，并返回 `rootDistanceSeconds`。阈值依据 [beevik/ntp Validate](https://github.com/beevik/ntp/blob/main/ntp.go)；这里按公开行为重新实现，没有复制源代码。尚不包括认证有效性、多样本抖动、系统时钟驯服或全部上游查询选项。

本次仅运行新增 health limits 测试组（4 类错误及 1 个独立数值结果），通过；旧测试未重复运行，未重新打包。
