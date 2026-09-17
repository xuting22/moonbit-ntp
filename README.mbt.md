# 可执行 API 示例

MoonBit API 示例随两个后端测试运行。Node UDP、认证和浏览器宿主另有集成检查。

```mbt check
///|
test "empty measurement selection" {
  assert_true(@ntp.lowest_delay([]) is None)
}

///|
test "eight-stage clock filter example" {
  let filter = @ntp.ClockFilter::new()
  for i = 1; i <= 8; i = i + 1 {
    let now = i.to_double()
    filter.begin_poll(now)
    ignore(
      filter.observe({
        offset_seconds: 0.01,
        delay_seconds: 0.02,
        dispersion_seconds: 0.000001,
        received_at: now,
      }),
    )
  }
  let result = filter.estimate(8.0).unwrap()
  assert_eq(result.valid_samples, 8)
  assert_eq(result.reach, 255)
  assert_eq(result.offset_seconds, 0.01)
  assert_true(!result.fresh)
}
```

过滤器返回统计估计；`fresh=false` 表示最佳样本没有更新。这里不修改操作系统时钟，也不实现完整 NTP daemon。
