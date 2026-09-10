# 可执行 API 示例

增加最低有效往返延迟样本选择，过滤 NaN、无穷和负延迟。这些例子调用公开 API，并随 `moon test` 执行。

```mbt check
///|
test "empty measurement selection" {
  assert_true(@ntp.lowest_delay([]) is None)
}
```

限制：单阶段选择器，不是完整 RFC 时钟过滤算法；没有 UDP 和系统校时。
