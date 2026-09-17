# Node 宿主、认证与运行限制

## 认证

`query(server,{auth:{type,keyID,key}})` 支持 `MD5/SHA1/SHA256/SHA512/AES128/AES256`。密钥编码跟随 beevik/ntp 1.5.0：`HEX:` 表示十六进制，`ASCII:` 后按 UTF-8 编码；无前缀且 UTF-8 长度大于 20 字节时按十六进制解析。

哈希算法密钥至少 4 字节，最多使用前 32 字节；AES128/256 至少分别 16/32 字节，超长截到该长度。MD5/AES MAC 为 16 字节，SHA 系列 MAC 截到 20 字节，之前加 4 字节 Key ID。支持的 Key ID 范围 0–65535。哈希认证是 `hash(key || packet)`，不是 HMAC。MD5/SHA1 是遗留协议兼容选项，不是新部署建议。

CLI 从文件读取认证，避免把密钥放入命令行：

```json
{"type":"AES128","keyID":104,"key":"HEX:000102030405060708090a0b0c0d0e0f"}
```

上面是公开测试值。`node tools/ntp.mjs query SERVER --auth-file FILE`。应自行保护真实密钥文件的权限。认证配置只留在进程或页面会话内，不写入结果、日志、浏览器存储或导出文件。结果包含算法和 Key ID。接收方先核对 origin 和 MAC，再信任健康/KoD 字段。未启用认证时，随机 nonce 仅防误匹配，不能证明来源身份。

## 采样

`sampleServers` 最多 64 来源、4096 轮、32 并发。默认 8 轮、64000 ms、最多 4 并发，`minimum` 默认 min(3,来源数)，`maximumDistance` 默认 1 秒。配置来源可用字符串或 `{id,address,options}`，其中 options 为该来源的 query 选项。

每个来源保留八级过滤器及相应报文元数据，根距离使用被选中样本的根延迟/离散度。重复解析到同一 IP:端口的来源不重复投票。RATE 至少退避两倍公布的 poll；DENY/RSTR 停用该来源。取消时传入 AbortSignal；单独调用异步迭代器 return 不能抢占正在等待的 next。

CLI 配置：`{"servers":[...],"options":{"rounds":8,"minimum":3}}`。文件读取限制 2 MiB、严格 UTF-8、只接受普通文件。replay 接受最多 4096 个 JSON 协议请求。退出码 0 成功、1 输入/传输错误、2 最终没有共识、130 被中断。

## 本地 HTTP

`node tools/serve.mjs [PORT]` 仅绑定 127.0.0.1。Host 必须是打印的地址，跨来源请求拒绝；只服务明确列出的静态资产和文档，不暴露 Git、工具文件或密钥。输入 16 KiB、并发 4 任务、单任务 15 分钟；慢请求头/上传有超时。

- `POST /api/query`：`{server,options}`，单次 UDP 查询。
- `POST /api/sample`：`{servers,options}`，逐轮 NDJSON，末尾明确输出 done；中途错误有 error 行。
- `GET /api/status`：服务版本与活动任务数。

网页 API 最多 8 来源、32 轮、4 并发；每次 UDP 超时最多 10 秒。HTTP 断开和服务器停止会取消关联 UDP 与轮询等待；输出等待背压。浏览器 Worker 负责离线分析，10 秒无响应会重启计算进程。页面文件认证上限 4 KiB。

该服务为本地个人工具，不包含公开服务所需的账户、TLS、授权和持久限流设施。启动时不连接外部时间服务器；使用者点击提交后才向指定地址查询。
