# 功能与兼容性边界 · 0.4.0

| 层 | 当前能力 | 边界 |
|---|---|---|
| MoonBit 报文 | 48 字节头、带符号根延迟、era 0/1、围绕可信本地时间的 era 解析 | 单次时间间隔上限一天；可信 pivot 必须在支持范围内 |
| MoonBit Datagram | 16 字节起、4 字节对齐的扩展字段、显式 MAC 尾部、未知字段保留 | 不解释 NTS 字段；最多 64 字段、总计 65507 字节 |
| MoonBit 计算 | offset、clamped RTT、minimum error、根距离、精度/轮询指数、健康状态 | 旧 measure 保持严格负 RTT 拒绝；analyze 按客户端行为钳制 |
| 时钟过滤 | 八级最低延迟选择、15 ppm 老化、加权离散度、RMS 抖动、reach、旧样本 epoch 标记 | 统计模型，不是完整 RFC peer 状态机或时钟控制器 |
| 来源选择 | 正确性区间求交、falseticker 排除、聚类、按根距离加权 | 最多 64 来源；无系统主来源滞回、popcorn filter、PLL/FLL |
| Node UDP | v2/v3/v4、IPv4/IPv6、绑定源地址/端口、IPv4 TTL、超时/取消、随机 nonce、单调时长 | 客户端查询；无服务端、对称/广播/interleaved 模式 |
| 认证 | MD5、SHA1、SHA256、SHA512、AES128/AES256 CMAC；恒时 MAC 比较 | 共享密钥 MAC，不是 NTS；MD5/SHA1 只用于遗留互通 |
| 连续采样 | 并发、轮询间隔、RATE 退避、DENY/RSTR 停用、重复解析端点排除、NDJSON | 需要显式 AbortSignal 中断等待；不持久保存状态 |
| 工作台 | 本地 HTTP、查询/采样、停止、认证文件、曲线/表格、导出、Worker 离线工具 | 浏览器本身没有 UDP；不用于公开网络托管 |

`ClockFilter::estimate` 是诊断快照。`fresh=false` 表示最优样本未更新，不应当作新时钟控制输入；本仓库不实现系统时钟控制。未来时间的只读快照不会推进过滤器的可变时钟。

`decode` 保持严格 48 字节兼容性；扩展报文使用 `decode_datagram`。MAC 长度必须由调用方明确提供，避免把认证尾部猜成扩展字段。没有 MAC 时最后一段扩展至少 28 字节。

## 与官方客户端的三项已知差异

1. 负根延迟按 RFC 有符号 16.16 解码；参考客户端将该例解为很大的无符号值。健康检查禁止负根延迟抵消过大的根离散度。
2. 2036 年跨 era 案例按模块差值计算 minimum error，避免原始无符号秒数比较导致约 136 年误差。
3. 1970 年前的绝对时间围绕调用者 pivot 解析；该参考客户端的固定 era 启发式产生另一 era 的时间。

差异逐字段保留在 `evidence/reference-comparison.json`，仅这些字段不参与官方 golden 相等检查；独立手写测试覆盖本实现预期值。数值比较允许 1.5 µs 绝对容差，字符串和布尔接受状态精确比较。
