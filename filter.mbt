///|
pub(all) struct FilterSample {
  offset_seconds : Double
  delay_seconds : Double
  dispersion_seconds : Double
  received_at : Double
} derive(Debug, Eq)

///|
pub(all) struct FilterEstimate {
  offset_seconds : Double
  delay_seconds : Double
  dispersion_seconds : Double
  jitter_seconds : Double
  selected_at : Double
  evaluated_at : Double
  valid_samples : Int
  reach : Int
  fresh : Bool
} derive(Debug)

///|
pub struct ClockFilter {
  entries : Array[FilterSample]
  precision : Double
  tolerance : Double
  mut last_time : Double?
  mut accepted : FilterEstimate?
  mut reach : Int
} derive(Debug)

///|
/// Eight stages, MAXDISP 16 seconds, PHI 15 ppm; no OS clock discipline.
pub fn ClockFilter::new(
  precision_seconds? : Double = 0.000001,
  frequency_tolerance? : Double = 0.000015,
) -> ClockFilter raise NtpError {
  if !finite(precision_seconds) ||
    precision_seconds <= 0.0 ||
    precision_seconds > 1.0 ||
    !finite(frequency_tolerance) ||
    frequency_tolerance < 0.0 ||
    frequency_tolerance > 0.001 {
    raise Invalid("invalid filter precision or frequency tolerance")
  }
  {
    entries: [],
    precision: precision_seconds,
    tolerance: frequency_tolerance,
    last_time: None,
    accepted: None,
    reach: 0,
  }
}

///|
fn ClockFilter::check_time(
  self : ClockFilter,
  now : Double,
) -> Unit raise NtpError {
  if !finite(now) ||
    now < 0.0 ||
    (self.last_time is Some(previous) && now < previous) {
    raise Invalid("filter requires finite monotonic arrival times")
  }
}

///|
fn ClockFilter::shift(self : ClockFilter, sample : FilterSample) -> Unit {
  self.entries.insert(0, sample)
  if self.entries.length() > 8 {
    ignore(self.entries.pop())
  }
  self.last_time = Some(sample.received_at)
}

///|
/// Call once when beginning a poll. After three missed polls a dummy is shifted
/// into the filter, so eight subsequent missing polls eventually replace it.
pub fn ClockFilter::begin_poll(
  self : ClockFilter,
  now : Double,
) -> Unit raise NtpError {
  self.check_time(now)
  self.reach = (self.reach << 1) & 255
  if (self.reach & 7) == 0 {
    self.shift({
      offset_seconds: 0.0,
      delay_seconds: 16.0,
      dispersion_seconds: 16.0,
      received_at: now,
    })
  } else {
    self.last_time = Some(now)
  }
}

///|
pub fn ClockFilter::observe(
  self : ClockFilter,
  sample : FilterSample,
) -> FilterEstimate? raise NtpError {
  self.check_time(sample.received_at)
  if !finite(sample.offset_seconds) ||
    sample.offset_seconds.abs() > 2147483648.0 ||
    !finite(sample.delay_seconds) ||
    !finite(sample.dispersion_seconds) ||
    sample.delay_seconds < 0.0 ||
    sample.delay_seconds >= 16.0 ||
    sample.dispersion_seconds < 0.0 ||
    sample.dispersion_seconds > 16.0 {
    raise Invalid("invalid or unfit filter sample")
  }
  self.reach = self.reach | 1
  self.shift(sample)
  let result = self.estimate(sample.received_at)
  if result is Some(value) && value.fresh {
    self.accepted = Some(value)
  }
  result
}

///|
/// Snapshot statistics age without mutating stage arrival times. The fresh flag
/// indicates whether this lowest-delay sample has advanced the accepted epoch.
pub fn ClockFilter::estimate(
  self : ClockFilter,
  now : Double,
) -> FilterEstimate? raise NtpError {
  self.check_time(now)
  let sorted = self.entries.copy()
  sorted.sort_by((a, b) => {
    if a.delay_seconds < b.delay_seconds {
      -1
    } else if a.delay_seconds > b.delay_seconds {
      1
    } else if a.received_at > b.received_at {
      -1
    } else if a.received_at < b.received_at {
      1
    } else {
      0
    }
  })
  let valid = sorted.filter(s => s.delay_seconds < 16.0)
  if valid.is_empty() {
    return None
  }
  let best = valid[0]
  let mut dispersion = 0.0
  let mut weight = 0.5
  for i in 0..<8 {
    let amount = if i < sorted.length() {
      let s = sorted[i]
      (s.dispersion_seconds + self.tolerance * (now - s.received_at)).min(16.0)
    } else {
      16.0
    }
    dispersion += amount * weight
    weight *= 0.5
  }
  let mut squares = 0.0
  for s in valid {
    let delta = s.offset_seconds - best.offset_seconds
    squares += delta * delta
  }
  // RMS normalization is inside the square root (RFC 5905 erratum 5600).
  let jitter = if valid.length() > 1 {
    (squares / (valid.length() - 1).to_double()).sqrt().max(self.precision)
  } else {
    self.precision
  }
  let fresh = match self.accepted {
    Some(old) => best.received_at > old.selected_at
    None => true
  }
  let result : FilterEstimate = {
    offset_seconds: best.offset_seconds,
    delay_seconds: best.delay_seconds,
    dispersion_seconds: dispersion,
    jitter_seconds: jitter,
    selected_at: best.received_at,
    evaluated_at: now,
    valid_samples: valid.length(),
    reach: self.reach,
    fresh,
  }
  // Keep only the accepted epoch; old candidates are still returned as a
  // diagnostic snapshot with fresh=false and cannot discipline a clock twice.
  Some(result)
}

///|
pub fn FilterEstimate::root_distance(
  self : FilterEstimate,
  root_delay_seconds : Double,
  root_dispersion_seconds : Double,
) -> Double raise NtpError {
  if !finite(root_delay_seconds) ||
    !finite(root_dispersion_seconds) ||
    root_dispersion_seconds < 0.0 {
    raise Invalid("invalid root metadata")
  }
  (root_delay_seconds + self.delay_seconds).max(0.005) / 2.0 +
  root_dispersion_seconds +
  self.dispersion_seconds +
  self.jitter_seconds
}
