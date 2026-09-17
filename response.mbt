///|
/// Returns an ASCII kiss-of-death code for stratum-zero replies.
pub fn Packet::kiss_code(self : Packet) -> String? {
  if self.stratum != 0 {
    return None
  }
  let chars = []
  for shift in [24, 16, 8, 0] {
    let n = ((self.reference_id >> shift) & 255U).reinterpret_as_int()
    if n < 32 || n > 126 {
      return None
    }
    chars.push(n.unsafe_to_char())
  }
  Some(String::from_array(chars))
}

///|
/// Check synchronization health in addition to measure's request/time validation.
/// Freshness and peer-distance limits follow beevik/ntp's Validate defaults.
pub fn Packet::validate_health(self : Packet) -> Unit raise NtpError {
  if self.version < 2 || self.version > 4 || self.mode != 4 {
    raise Invalid("not an NTPv2/v3/v4 server response")
  }
  if self.stratum < 1 || self.stratum > 15 || self.leap < 0 || self.leap > 2 {
    raise Invalid("unsynchronized or kiss-of-death response")
  }
  if self.reference == Timestamp::zero() || self.transmit == Timestamp::zero() {
    raise Invalid("missing reference or transmit timestamp")
  }
  let age = self.transmit.difference(self.reference)
  if age < 0.0 {
    raise Invalid("reference timestamp follows transmit timestamp")
  }
  if age > 131072.0 {
    raise Invalid("stale server reference timestamp")
  }
  let distance = self.root_delay.to_double().max(0.0) / 131072.0 +
    self.root_dispersion.to_double() / 65536.0
  if distance > 16.0 {
    raise Invalid("excessive root synchronization distance")
  }
}

///|
/// Single-sample root distance; excludes multi-sample jitter and clock filtering.
pub fn Packet::root_distance(self : Packet, sample : Sample) -> Double {
  (sample.delay_seconds + self.root_delay.to_double() / 65536.0).max(0.0) / 2.0 +
  self.root_dispersion.to_double() / 65536.0
}
