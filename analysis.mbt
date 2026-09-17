///|
pub(all) struct ResponseInfo {
  sample : Sample
  minimum_error_seconds : Double
  server_transmit_unix : Double
  reference_unix : Double
  precision_seconds : Double
  poll_seconds : Double
  root_distance_seconds : Double
  reference_string : String
} derive(Debug)

///|
fn finite(n : Double) -> Bool {
  !n.is_nan() && !n.is_inf()
}

///|
/// Resolve within half an NTP era of a trusted local pivot (pivot in eras 0/1).
pub fn Timestamp::near_unix(
  self : Timestamp,
  pivot : Double,
) -> Double raise NtpError {
  let (stamp, _) = from_unix(pivot)
  pivot + self.difference(stamp)
}

///|
pub fn Packet::reference_string(self : Packet) -> String {
  if self.stratum == 0 {
    return self.kiss_code().unwrap_or("")
  }
  let bytes = [24, 16, 8, 0].map(shift => {
    ((self.reference_id >> shift) & 255U).reinterpret_as_int()
  })
  if self.stratum == 1 {
    let text = StringBuilder()
    text.write_string(".")
    for byte in bytes {
      if byte == 0 {
        break
      }
      text.write_char(
        if byte >= 32 && byte <= 126 {
          byte.unsafe_to_char()
        } else {
          '⋅'
        },
      )
    }
    text.write_string(".")
    text.to_string()
  } else {
    bytes.map(n => n.to_string()).join(".")
  }
}

///|
/// Rich SNTP analysis. A small negative measured network delay is clamped to
/// zero, as in beevik/ntp; strict measure() retains its existing rejection.
pub fn analyze(
  sent : Timestamp,
  reply : Packet,
  arrived : Timestamp,
  pivot_unix : Double,
) -> ResponseInfo raise NtpError {
  if reply.version < 2 || reply.version > 4 || reply.mode != 4 {
    raise Invalid("not an NTPv2/v3/v4 server response")
  }
  if reply.origin != sent {
    raise Invalid("origin mismatch")
  }
  if reply.receive == Timestamp::zero() || reply.transmit == Timestamp::zero() {
    raise Invalid("missing server timestamp")
  }
  let elapsed = arrived.difference(sent)
  let processing = reply.transmit.difference(reply.receive)
  if elapsed < 0.0 ||
    elapsed > 86400.0 ||
    processing < 0.0 ||
    processing > 86400.0 {
    raise Invalid("invalid time ordering or excessive interval")
  }
  let a = reply.receive.difference(sent)
  let b = reply.transmit.difference(arrived)
  let sample : Sample = {
    offset_seconds: a / 2.0 + b / 2.0,
    delay_seconds: (elapsed - processing).max(0.0),
  }
  {
    sample,
    minimum_error_seconds: (-a).max(b).max(0.0),
    server_transmit_unix: reply.transmit.near_unix(pivot_unix),
    reference_unix: reply.reference.near_unix(pivot_unix),
    precision_seconds: @math.pow(2.0, reply.precision.to_double()),
    poll_seconds: @math.pow(2.0, reply.poll.to_double()),
    root_distance_seconds: reply.root_distance(sample),
    reference_string: reply.reference_string(),
  }
}
