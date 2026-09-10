///|
test "unix epoch and era rollover" {
  let pair = @ntp.from_unix(0.5)
  assert_eq(pair.0.seconds, 2208988800U)
  assert_eq(pair.0.fraction, 2147483648U)
  assert_eq(pair.0.unix_seconds(pair.1), 0.5)
  let later = @ntp.from_unix(2085978496.0)
  assert_eq(later.1, 1)
  assert_eq(later.0.seconds, 0U)
  let early = @ntp.from_unix(2085978495.0)
  assert_eq(later.0.difference(early.0), 1.0)
}

///|
test "golden request header and packet roundtrip" {
  let p = @ntp.request(@ntp.from_unix(0.0).0)
  let wire = p.encode()
  assert_eq(wire.length(), 48)
  assert_eq(wire[:4].to_owned(), b"\x23\x00\x06\xec")
  assert_eq(wire[40:].to_owned(), b"\x83\xaa\x7e\x80\x00\x00\x00\x00")
  assert_eq(@ntp.decode(wire), p)
}

///|
test "known offset delay and response validation" {
  let t1 = @ntp.from_unix(1000.0).0
  let reply : @ntp.Packet = {
    leap: 0,
    version: 4,
    mode: 4,
    stratum: 2,
    poll: 6,
    precision: -20,
    root_delay: -100,
    root_dispersion: 42U,
    reference_id: 7U,
    reference: t1,
    origin: t1,
    receive: @ntp.from_unix(1001.25).0,
    transmit: @ntp.from_unix(1001.5).0,
  }
  let sample = @ntp.measure(t1, reply, @ntp.from_unix(1000.75).0)
  assert_eq(sample.offset_seconds, 1.0)
  assert_eq(sample.delay_seconds, 0.5)
  assert_eq(@ntp.decode(reply.encode()), reply)
  assert_true(
    try {
      ignore(@ntp.measure(@ntp.Timestamp::zero(), reply, t1))
      false
    } catch {
      _ => true
    },
  )
}

///|
test "truncation extensions and invalid timestamp" {
  for len in [0, 47, 49, 100] {
    assert_true(
      try {
        ignore(@ntp.decode(Bytes::from_array(Array::make(len, 0))))
        false
      } catch {
        _ => true
      },
    )
  }
  assert_true(
    try {
      ignore(@ntp.from_unix(1.0 / 0.0))
      false
    } catch {
      _ => true
    },
  )
}
