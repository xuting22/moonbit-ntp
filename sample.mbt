///|
pub struct Sample {
  offset_seconds : Double
  delay_seconds : Double
} derive(Debug)

///|
/// Verifies basic server reply and computes RFC four-timestamp estimates.
/// Caller supplies the original request timestamp and local receipt timestamp.
pub fn measure(
  sent : Timestamp,
  reply : Packet,
  arrived : Timestamp,
) -> Sample raise NtpError {
  if reply.version < 3 || reply.version > 4 || reply.mode != 4 {
    raise Invalid("not an NTPv3/v4 server response")
  }
  if reply.leap < 0 || reply.leap > 2 || reply.stratum < 1 || reply.stratum > 15 {
    raise Invalid("unsynchronized or kiss-of-death response")
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
    processing > elapsed {
    raise Invalid("invalid time ordering or negative delay")
  }
  {
    offset_seconds: (
      reply.receive.difference(sent) + reply.transmit.difference(arrived)
    ) /
    2.0,
    delay_seconds: elapsed - processing,
  }
}
