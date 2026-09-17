///|
fn near(
  a : Double,
  b : Double,
  tolerance? : Double = 0.000000001,
) -> Unit raise {
  assert_true((a - b).abs() <= tolerance)
}

///|
test "fraction conversion keeps sub microsecond data and nearest era" {
  let t = @ntp.from_unix(0.1).0
  assert_eq(t.fraction, 429496729U)
  assert_eq(@ntp.from_unix(-0.1).0.fraction, 3865470566U)
  near(t.unix_seconds(0), 0.1)
  let rollover = @ntp.from_unix(2085978496.25).0
  near(rollover.near_unix(2085978495.0), 2085978496.25)
}

///|
test "extension datagrams preserve padding and explicit MAC boundary" {
  let header = @ntp.request(@ntp.from_unix(1.0).0)
  let fields : Array[@ntp.ExtensionField] = [
    { field_type: 258, value: b"0123456789ab", },
    { field_type: 65535, value: b"0123456789abcdefghijklmn", },
  ]
  let d : @ntp.Datagram = { header, extensions: fields, mac: b"", }
  let bytes = d.encode()
  assert_eq(bytes.length(), 92)
  assert_eq(bytes[48:52].to_owned(), b"\x01\x02\x00\x10")
  assert_eq(@ntp.decode_datagram(bytes), d)
  let signed : @ntp.Datagram = {
    header,
    extensions: [fields[0]],
    mac: Bytes::from_array(Array::make(20, 0)),
  }
  assert_eq(@ntp.decode_datagram(signed.encode(), mac_length=20), signed)
  assert_true(
    try {
      ignore(@ntp.decode_datagram(signed.encode()))
      false
    } catch {
      _ => true
    },
  )
  assert_true(
    try {
      ignore(
        ({ header, extensions: [fields[0]], mac: b"", } : @ntp.Datagram).encode(),
      )
      false
    } catch {
      _ => true
    },
  )
  assert_true(
    try {
      ignore(@ntp.decode_datagram(bytes, mac_length=12))
      false
    } catch {
      _ => true
    },
  )
}

///|
test "rich analysis accepts v2 and clamps quantized negative RTT while strict measure rejects it" {
  let sent = @ntp.from_unix(1000.0).0
  let reply : @ntp.Packet = {
    ..@ntp.request(sent),
    version: 2,
    mode: 4,
    stratum: 1,
    reference_id: 1196446464U,
    reference: @ntp.from_unix(999.0).0,
    origin: sent,
    receive: @ntp.from_unix(1000.1).0,
    transmit: @ntp.from_unix(1000.3).0,
  }
  let result = @ntp.analyze(sent, reply, @ntp.from_unix(1000.2).0, 1000.2)
  near(result.sample.offset_seconds, 0.1)
  assert_eq(result.sample.delay_seconds, 0.0)
  near(result.minimum_error_seconds, 0.1)
  assert_eq(result.reference_string, ".GPS.")
  reply.validate_health()
  assert_true(
    try {
      ignore(@ntp.measure(sent, reply, @ntp.from_unix(1000.2).0))
      false
    } catch {
      _ => true
    },
  )
}

///|
test "eight stage filter dispersion RMS epoch and validation" {
  let filter = @ntp.ClockFilter::new(frequency_tolerance=0.0)
  filter.begin_poll(1.0)
  let first = filter
    .observe({
      offset_seconds: 1.0,
      delay_seconds: 0.1,
      dispersion_seconds: 0.01,
      received_at: 1.0,
    })
    .unwrap()
  near(first.dispersion_seconds, 7.9425)
  assert_true(first.fresh)
  filter.begin_poll(2.0)
  let second = filter
    .observe({
      offset_seconds: 2.0,
      delay_seconds: 0.2,
      dispersion_seconds: 0.02,
      received_at: 2.0,
    })
    .unwrap()
  assert_false(second.fresh)
  near(second.jitter_seconds, 1.0)
  near(second.dispersion_seconds, 3.9475)
  assert_eq(second.reach, 3)
  assert_true(
    try {
      ignore(
        filter.observe({
          offset_seconds: 0.0,
          delay_seconds: 0.1,
          dispersion_seconds: 0.0,
          received_at: 0.0,
        }),
      )
      false
    } catch {
      _ => true
    },
  )
  assert_eq(filter.estimate(2.0).unwrap().valid_samples, 2)
}

///|
test "filter ages uncertainty rejects stale epochs and expires after missed polls" {
  let filter = @ntp.ClockFilter::new()
  for i in 1..<9 {
    let now = i.to_double()
    filter.begin_poll(now)
    ignore(
      filter.observe({
        offset_seconds: 0.001,
        delay_seconds: 0.01,
        dispersion_seconds: 0.0,
        received_at: now,
      }),
    )
  }
  let current = filter.estimate(8.0).unwrap()
  assert_eq(current.valid_samples, 8)
  assert_eq(current.reach, 255)
  assert_false(current.fresh)
  let older = filter.estimate(1008.0).unwrap()
  near(
    older.dispersion_seconds - current.dispersion_seconds,
    0.000015 * 1000.0 * 255.0 / 256.0,
  )
  assert_true(
    older.root_distance(0.01, 0.001) > current.root_distance(0.01, 0.001),
  )
  for i in 9..<20 {
    filter.begin_poll(i.to_double())
  }
  assert_true(filter.estimate(20.0) is None)
}

///|
test "majority intersection rejects falseticker and clustering removes outliers" {
  let peers : Array[@ntp.PeerEstimate] = [0.01, 0.02, 0.03, 2.0].mapi((i, x) => {
    id: i.to_string(),
    offset_seconds: x,
    root_distance_seconds: 0.1,
    jitter_seconds: 0.001,
    stratum: 2,
  })
  let answer = @ntp.combine_peers(peers, minimum=3).unwrap()
  assert_eq(answer.survivors, ["0", "1", "2"])
  assert_eq(answer.rejected, ["3"])
  near(answer.offset_seconds, 0.02)
  let wide : Array[@ntp.PeerEstimate] = [-0.09, -0.03, 0.0, 0.01, 0.02, 0.08].mapi((
      i,
      x,
    ) => {
      id: i.to_string(),
      offset_seconds: x,
      root_distance_seconds: 1.0,
      jitter_seconds: 0.001,
      stratum: 2,
    },
  )
  let clustered = @ntp.combine_peers(wide, minimum=3).unwrap()
  assert_eq(clustered.survivors, ["2", "3", "4"])
  near(clustered.offset_seconds, 0.01)
  assert_true(@ntp.combine_peers([peers[0], peers[3]]) is None)
}

///|
test "consensus validates identifiers and excludes nonfinite or unfit peers" {
  let good : @ntp.PeerEstimate = {
    id: "valid",
    offset_seconds: 0.0,
    root_distance_seconds: 0.1,
    jitter_seconds: 0.001,
    stratum: 2,
  }
  let bad = { ..good, id: "invalid", offset_seconds: 0.0 / 0.0, }
  let answer = @ntp.combine_peers([good, bad]).unwrap()
  assert_eq(answer.survivors, ["valid"])
  assert_eq(answer.rejected, ["invalid"])
  assert_true(
    try {
      ignore(@ntp.combine_peers([good, good]))
      false
    } catch {
      _ => true
    },
  )
  assert_true(@ntp.combine_peers([good], minimum=2) is None)
}

///|
test "era boundary minimum error and signed root metadata remain bounded" {
  let sent = @ntp.from_unix(2085978495.875).0
  let reply : @ntp.Packet = {
    ..@ntp.request(sent),
    mode: 4,
    stratum: 2,
    origin: sent,
    reference: @ntp.from_unix(2085978465.875).0,
    receive: @ntp.from_unix(2085978496.375).0,
    transmit: @ntp.from_unix(2085978496.395).0,
    root_delay: -16384,
    root_dispersion: 64U,
  }
  let value = @ntp.analyze(
    sent,
    reply,
    @ntp.from_unix(2085978496.395).0,
    2085978496.395,
  )
  near(value.minimum_error_seconds, 0.0)
  assert_true(value.root_distance_seconds >= 0.0)
  let bad = { ..reply, root_delay: -1073741824, root_dispersion: 1114112U, }
  assert_true(
    try {
      bad.validate_health()
      false
    } catch {
      _ => true
    },
  )
}
