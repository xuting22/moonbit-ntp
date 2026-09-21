# MoonBit NTP 时间观测库 · 项目申报书

## 一、项目名称

MoonBit NTP 时间观测库

## 二、项目说明

MoonBit 实现 NTP 报文、时间戳、八级过滤和多来源选择；Node 提供 UDP 查询、连续采样与本地观测台。只返回估计值，不修改系统时钟。

## 三、方向与通用性

网络协议与可观测性。用于授权服务器的偏移测量、时钟健康诊断及算法教学；不等同于完整校时守护进程或 NTS 实现。

## 四、应用场景

query 获取 offset/delay；sample 按轮询约束进行多源采样，未知样本保留不确定度；本地网页可导出观测数据，页面打开不会自动查询外部服务器。

## 五、功能与验证边界

核心、宿主及 Chrony 互通分别留有记录。beevik/ntp 的 156 个比较中 153 个在记录容差内一致、3 项差异单列；认证、KoD 退避和取消有显式约束，不将有限互通视为所有服务器保证。

## 六、原创性与参考材料

原创代码 MIT。依据 RFC 5905/7822/8573 与勘误实现；行为参考 beevik/ntp（BSD-2-Clause，https://github.com/beevik/ntp），Chrony（https://chrony-project.org/）为独立互通依赖。参考程序未并入生产实现，来源哈希见 reference-provenance 证据。

## 七、仓库链接

https://github.com/xuting22/moonbit-ntp
