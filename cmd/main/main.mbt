///|
fn main raise {
  let stamp = @lib.from_unix(1788998400.25)
  let packet = @lib.request(stamp.0)
  println("NTP request bytes: \{packet.encode().length()}, era: \{stamp.1}")
  println(
    "Recovered Unix seconds: \{@lib.decode(packet.encode()).transmit.unix_seconds(stamp.1)}",
  )
}
