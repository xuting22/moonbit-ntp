///|
/// Choose the valid measurement with minimum observed network delay.
/// This is a single-stage selector, not the complete RFC clock-filter algorithm.
pub fn lowest_delay(samples : Array[Sample]) -> Sample? {
  let mut best : Sample? = None
  for s in samples {
    if (s.delay_seconds.is_nan() || s.delay_seconds.is_inf()) ||
      (s.offset_seconds.is_nan() || s.offset_seconds.is_inf()) ||
      s.delay_seconds < 0.0 {
      continue
    }
    match best {
      None => best = Some(s)
      Some(old) => if s.delay_seconds < old.delay_seconds { best = Some(s) }
    }
  }
  best
}
