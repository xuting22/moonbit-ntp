///|
test "selector rejects invalid samples and chooses smallest delay" {
  let a : Sample = { offset_seconds: 1.0, delay_seconds: 0.5, }
  let b : Sample = { offset_seconds: 2.0, delay_seconds: 0.1, }
  let bad : Sample = { offset_seconds: 0.0 / 0.0, delay_seconds: 0.0, }
  let negative : Sample = { offset_seconds: 0.0, delay_seconds: -1.0, }
  let infinite : Sample = { offset_seconds: 0.0, delay_seconds: 1.0 / 0.0, }
  match lowest_delay([a, b, bad, negative, infinite]) {
    Some(s) => assert_eq(s.offset_seconds, 2.0)
    None => fail("missing sample")
  }
  assert_true(lowest_delay([bad, negative, infinite]) is None)
}
