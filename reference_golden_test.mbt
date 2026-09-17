// Generated from official beevik/ntp v1.5.0 captures. Do not hand edit.

///|
test "official reference offset=-4 rtt=0.001 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x00\x20\xc4\x00\xee\xf4\x50\x7c\x00\x20\xc4\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.999500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, -4.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.0005, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.001 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x00\x20\xc4\x00\xee\xf4\x50\x7c\x00\x20\xc4\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.999500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, -4.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.0005, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.001 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x00\x20\xc4\x00\xee\xf4\x50\x7c\x00\x20\xc4\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.999500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, -4.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.0005, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.001 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x00\x20\xc4\x00\xee\xf4\x50\x7c\x05\x3f\x7c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.999500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, -4.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.0205, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.001 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x00\x20\xc4\x00\xee\xf4\x50\x7c\x05\x3f\x7c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.999500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, -4.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.0205, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.001 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x00\x20\xc4\x00\xee\xf4\x50\x7c\x05\x3f\x7c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.999500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, -4.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.0205, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.05 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x06\x66\x68\x00\xee\xf4\x50\x7c\x06\x66\x68\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.974999905, tolerance=0.0000015)
  near(a.sample.offset_seconds, -3.999999881, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.025, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.05 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x06\x66\x68\x00\xee\xf4\x50\x7c\x06\x66\x68\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.974999905, tolerance=0.0000015)
  near(a.sample.offset_seconds, -3.999999881, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.025, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.05 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x06\x66\x68\x00\xee\xf4\x50\x7c\x06\x66\x68\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.974999905, tolerance=0.0000015)
  near(a.sample.offset_seconds, -3.999999881, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.025, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.05 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x06\x66\x68\x00\xee\xf4\x50\x7c\x0b\x85\x20\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.974999905, tolerance=0.0000015)
  near(a.sample.offset_seconds, -3.999999881, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.045, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.05 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x06\x66\x68\x00\xee\xf4\x50\x7c\x0b\x85\x20\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.974999905, tolerance=0.0000015)
  near(a.sample.offset_seconds, -3.999999881, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.045, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.05 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x06\x66\x68\x00\xee\xf4\x50\x7c\x0b\x85\x20\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.974999905, tolerance=0.0000015)
  near(a.sample.offset_seconds, -3.999999881, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.045, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.4 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x33\x33\x34\x00\xee\xf4\x50\x7c\x33\x33\x34\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.799999952, tolerance=0.0000015)
  near(a.sample.offset_seconds, -4.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.2, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.4 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x33\x33\x34\x00\xee\xf4\x50\x7c\x33\x33\x34\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.799999952, tolerance=0.0000015)
  near(a.sample.offset_seconds, -4.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.2, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.4 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x33\x33\x34\x00\xee\xf4\x50\x7c\x33\x33\x34\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.799999952, tolerance=0.0000015)
  near(a.sample.offset_seconds, -4.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.2, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.4 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x33\x33\x34\x00\xee\xf4\x50\x7c\x38\x51\xec\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.799999952, tolerance=0.0000015)
  near(a.sample.offset_seconds, -4.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.22, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.4 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x33\x33\x34\x00\xee\xf4\x50\x7c\x38\x51\xec\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.799999952, tolerance=0.0000015)
  near(a.sample.offset_seconds, -4.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.22, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-4 rtt=0.4 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7c\x33\x33\x34\x00\xee\xf4\x50\x7c\x38\x51\xec\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 3.799999952, tolerance=0.0000015)
  near(a.sample.offset_seconds, -4.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999996.22, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.001 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7f\xe0\x20\xc4\x00\xee\xf4\x50\x7f\xe0\x20\xc4\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.124500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.125, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999999.8755, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.001 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7f\xe0\x20\xc4\x00\xee\xf4\x50\x7f\xe0\x20\xc4\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.124500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.125, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999999.8755, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.001 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7f\xe0\x20\xc4\x00\xee\xf4\x50\x7f\xe0\x20\xc4\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.124500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.125, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999999.8755, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.001 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7f\xe0\x20\xc4\x00\xee\xf4\x50\x7f\xe5\x3f\x7c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.124500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.125, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999999.8955, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.001 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7f\xe0\x20\xc4\x00\xee\xf4\x50\x7f\xe5\x3f\x7c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.124500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.125, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999999.8955, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.001 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7f\xe0\x20\xc4\x00\xee\xf4\x50\x7f\xe5\x3f\x7c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.124500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.125, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999999.8955, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.05 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7f\xe6\x66\x68\x00\xee\xf4\x50\x7f\xe6\x66\x68\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.099999905, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.124999881, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999999.9, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.05 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7f\xe6\x66\x68\x00\xee\xf4\x50\x7f\xe6\x66\x68\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.099999905, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.124999881, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999999.9, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.05 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7f\xe6\x66\x68\x00\xee\xf4\x50\x7f\xe6\x66\x68\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.099999905, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.124999881, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999999.9, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.05 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7f\xe6\x66\x68\x00\xee\xf4\x50\x7f\xeb\x85\x20\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.099999905, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.124999881, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999999.92, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.05 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7f\xe6\x66\x68\x00\xee\xf4\x50\x7f\xeb\x85\x20\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.099999905, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.124999881, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999999.92, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.05 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x7f\xe6\x66\x68\x00\xee\xf4\x50\x7f\xeb\x85\x20\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.099999905, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.124999881, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1799999999.92, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.4 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x13\x33\x34\x00\xee\xf4\x50\x80\x13\x33\x34\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.125, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.075, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.4 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x13\x33\x34\x00\xee\xf4\x50\x80\x13\x33\x34\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.125, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.075, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.4 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x13\x33\x34\x00\xee\xf4\x50\x80\x13\x33\x34\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.125, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.075, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.4 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x13\x33\x34\x00\xee\xf4\x50\x80\x18\x51\xec\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.125, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.095, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.4 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x13\x33\x34\x00\xee\xf4\x50\x80\x18\x51\xec\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.125, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.095, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=-0.125 rtt=0.4 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x13\x33\x34\x00\xee\xf4\x50\x80\x18\x51\xec\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, -0.125, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.095, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.001 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x00\x20\xc4\x00\xee\xf4\x50\x80\x00\x20\xc4\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0005, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.001 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x00\x20\xc4\x00\xee\xf4\x50\x80\x00\x20\xc4\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0005, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.001 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x00\x20\xc4\x00\xee\xf4\x50\x80\x00\x20\xc4\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0005, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.001 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x00\x20\xc4\x00\xee\xf4\x50\x80\x05\x3f\x7c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0205, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.001 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x00\x20\xc4\x00\xee\xf4\x50\x80\x05\x3f\x7c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0205, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.001 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x00\x20\xc4\x00\xee\xf4\x50\x80\x05\x3f\x7c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0205, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.05 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x06\x66\x68\x00\xee\xf4\x50\x80\x06\x66\x68\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 1.19e-07, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.025, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.05 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x06\x66\x68\x00\xee\xf4\x50\x80\x06\x66\x68\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 1.19e-07, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.025, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.05 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x06\x66\x68\x00\xee\xf4\x50\x80\x06\x66\x68\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 1.19e-07, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.025, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.05 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x06\x66\x68\x00\xee\xf4\x50\x80\x0b\x85\x20\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 1.19e-07, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.045, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.05 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x06\x66\x68\x00\xee\xf4\x50\x80\x0b\x85\x20\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 1.19e-07, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.045, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.05 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x06\x66\x68\x00\xee\xf4\x50\x80\x0b\x85\x20\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 1.19e-07, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.045, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.4 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x34\x00\xee\xf4\x50\x80\x33\x33\x34\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.2, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.4 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x34\x00\xee\xf4\x50\x80\x33\x33\x34\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.2, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.4 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x34\x00\xee\xf4\x50\x80\x33\x33\x34\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.2, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.4 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x34\x00\xee\xf4\x50\x80\x38\x51\xec\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.22, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.4 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x34\x00\xee\xf4\x50\x80\x38\x51\xec\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.22, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0 rtt=0.4 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x34\x00\xee\xf4\x50\x80\x38\x51\xec\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.22, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.001 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x00\x62\x4c\x00\xee\xf4\x50\x80\x00\x62\x4c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.000499963, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.000999927, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0015, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.001 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x00\x62\x4c\x00\xee\xf4\x50\x80\x00\x62\x4c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.000499963, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.000999927, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0015, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.001 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x00\x62\x4c\x00\xee\xf4\x50\x80\x00\x62\x4c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.000499963, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.000999927, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0015, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.001 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x00\x62\x4c\x00\xee\xf4\x50\x80\x05\x81\x04\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.000499964, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.000999928, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0214999, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.001 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x00\x62\x4c\x00\xee\xf4\x50\x80\x05\x81\x04\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.000499964, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.000999928, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0214999, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.001 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x00\x62\x4c\x00\xee\xf4\x50\x80\x05\x81\x04\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.000499964, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.000999928, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0214999, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.05 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x06\xa7\xf0\x00\xee\xf4\x50\x80\x06\xa7\xf0\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.001000047, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.026, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.05 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x06\xa7\xf0\x00\xee\xf4\x50\x80\x06\xa7\xf0\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.001000047, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.026, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.05 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x06\xa7\xf0\x00\xee\xf4\x50\x80\x06\xa7\xf0\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.001000047, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.026, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.05 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x06\xa7\xf0\x00\xee\xf4\x50\x80\x0b\xc6\xa8\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.001000047, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0460002, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.05 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x06\xa7\xf0\x00\xee\xf4\x50\x80\x0b\xc6\xa8\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.001000047, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0460002, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.05 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x06\xa7\xf0\x00\xee\xf4\x50\x80\x0b\xc6\xa8\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.001000047, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.0460002, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.4 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x74\xbc\x00\xee\xf4\x50\x80\x33\x74\xbc\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.000999928, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.201, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.4 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x74\xbc\x00\xee\xf4\x50\x80\x33\x74\xbc\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.000999928, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.201, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.4 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x74\xbc\x00\xee\xf4\x50\x80\x33\x74\xbc\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.000999928, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.201, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.4 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x74\xbc\x00\xee\xf4\x50\x80\x38\x93\x74\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.000999928, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.221, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.4 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x74\xbc\x00\xee\xf4\x50\x80\x38\x93\x74\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.000999928, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.221, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=0.001 rtt=0.4 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x74\xbc\x00\xee\xf4\x50\x80\x38\x93\x74\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.000999928, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.221, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.001 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x00\x20\xc4\x00\xee\xf4\x50\x83\x00\x20\xc4\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.999500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.0005, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.001 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x00\x20\xc4\x00\xee\xf4\x50\x83\x00\x20\xc4\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.999500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.0005, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.001 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x00\x20\xc4\x00\xee\xf4\x50\x83\x00\x20\xc4\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.001).0,
    1800000000.001,
  )
  near(a.sample.delay_seconds, 0.000999928, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.999500036, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491785, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.0005, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.001 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x00\x20\xc4\x00\xee\xf4\x50\x83\x05\x3f\x7c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.999500037, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.0205, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.001 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x00\x20\xc4\x00\xee\xf4\x50\x83\x05\x3f\x7c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.999500037, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.0205, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.001 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x00\x20\xc4\x00\xee\xf4\x50\x83\x05\x3f\x7c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.021).0,
    1800000000.021,
  )
  near(a.sample.delay_seconds, 0.000999927, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.999500037, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.001491784, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.0205, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.05 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x06\x66\x68\x00\xee\xf4\x50\x83\x06\x66\x68\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.975000143, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.000000119, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.025, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.05 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x06\x66\x68\x00\xee\xf4\x50\x83\x06\x66\x68\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.975000143, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.000000119, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.025, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.05 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x06\x66\x68\x00\xee\xf4\x50\x83\x06\x66\x68\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.05).0,
    1800000000.05,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.975000143, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.000000119, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.025, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.05 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x06\x66\x68\x00\xee\xf4\x50\x83\x0b\x85\x20\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.975000143, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.000000119, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.045, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.05 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x06\x66\x68\x00\xee\xf4\x50\x83\x0b\x85\x20\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.975000143, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.000000119, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.045, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.05 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x06\x66\x68\x00\xee\xf4\x50\x83\x0b\x85\x20\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.07).0,
    1800000000.07,
  )
  near(a.sample.delay_seconds, 0.049999952, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.975000143, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.000000119, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.025991797, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.045, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.4 processing=0 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x33\x33\x34\x00\xee\xf4\x50\x83\x33\x33\x34\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.799999953, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.2, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.4 processing=0 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x33\x33\x34\x00\xee\xf4\x50\x83\x33\x33\x34\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.799999953, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.2, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.4 processing=0 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x33\x33\x34\x00\xee\xf4\x50\x83\x33\x33\x34\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.4).0,
    1800000000.4,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.799999953, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.2, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.4 processing=0.02 v=2" {
  let p = @ntp.decode(
    b"\x14\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x33\x33\x34\x00\xee\xf4\x50\x83\x38\x51\xec\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.799999953, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.22, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 2)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.4 processing=0.02 v=3" {
  let p = @ntp.decode(
    b"\x1c\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x33\x33\x34\x00\xee\xf4\x50\x83\x38\x51\xec\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.799999953, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.22, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 3)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference offset=3 rtt=0.4 processing=0.02 v=4" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x83\x33\x33\x34\x00\xee\xf4\x50\x83\x38\x51\xec\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.42).0,
    1800000000.42,
  )
  near(a.sample.delay_seconds, 0.400000095, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 2.799999953, tolerance=0.0000015)
  near(a.sample.offset_seconds, 3.0, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.200991868, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000003.22, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference stratum-one reference" {
  let p = @ntp.decode(
    b"\x24\x01\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x47\x50\x53\x00\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x30\x00\xee\xf4\x50\x80\x35\xc2\x8c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.21).0,
    1800000000.21,
  )
  near(a.sample.delay_seconds, 0.200000047, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.099999786, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 1196446464.0, tolerance=0.0000015)
  assert_eq(a.reference_string, ".GPS.")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.100991844, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.2099998, tolerance=0.0000015)
  assert_eq(p.stratum, 1)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference negative signed root delay" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\xff\xff\xc0\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x30\x00\xee\xf4\x50\x80\x35\xc2\x8c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.21).0,
    1800000000.21,
  )
  near(a.sample.delay_seconds, 0.200000047, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.099999786, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  // Documented reference difference: rootDelaySeconds
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  // Documented reference difference: rootDistanceSeconds
  near(a.server_transmit_unix, 1800000000.2099998, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
}

///|
test "official reference fractional poll exponent" {
  let p = @ntp.decode(
    b"\x24\x02\xfa\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x30\x00\xee\xf4\x50\x80\x35\xc2\x8c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.21).0,
    1800000000.21,
  )
  near(a.sample.delay_seconds, 0.200000047, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.099999786, tolerance=0.0000015)
  near(a.poll_seconds, 0.015625, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.100991844, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.2099998, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference very fine precision" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xd8\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x30\x00\xee\xf4\x50\x80\x35\xc2\x8c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.21).0,
    1800000000.21,
  )
  near(a.sample.delay_seconds, 0.200000047, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.099999786, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 0.0, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.100991844, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.2099998, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference leap unsynchronized" {
  let p = @ntp.decode(
    b"\xe4\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x30\x00\xee\xf4\x50\x80\x35\xc2\x8c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.21).0,
    1800000000.21,
  )
  near(a.sample.delay_seconds, 0.200000047, tolerance=0.0000015)
  assert_eq(p.leap, 3)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.099999786, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.100991844, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.2099998, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, false)
}

///|
test "official reference invalid stratum" {
  let p = @ntp.decode(
    b"\x24\x10\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x30\x00\xee\xf4\x50\x80\x35\xc2\x8c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.21).0,
    1800000000.21,
  )
  near(a.sample.delay_seconds, 0.200000047, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.099999786, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.100991844, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.2099998, tolerance=0.0000015)
  assert_eq(p.stratum, 16)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, false)
}

///|
test "official reference excessive root dispersion" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x11\x00\x00\x7f\x00\x00\x01\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x30\x00\xee\xf4\x50\x80\x35\xc2\x8c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.21).0,
    1800000000.21,
  )
  near(a.sample.delay_seconds, 0.200000047, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.099999786, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(p.root_dispersion.to_double() / 65536.0, 17.0, tolerance=0.0000015)
  near(a.root_distance_seconds, 17.100000023, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.2099998, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, false)
}

///|
test "official reference kiss RATE" {
  let p = @ntp.decode(
    b"\x24\x00\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x52\x41\x54\x45\xee\xf4\x50\x62\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\xf4\x50\x80\x33\x33\x30\x00\xee\xf4\x50\x80\x35\xc2\x8c\x00",
  )
  let sent = @ntp.from_unix(1800000000.0).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1800000000.21).0,
    1800000000.21,
  )
  near(a.sample.delay_seconds, 0.200000047, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.099999786, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 1380013125.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "RATE")
  near(a.reference_unix, 1799999970.0, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.100991844, tolerance=0.0000015)
  near(a.server_transmit_unix, 1800000000.2099998, tolerance=0.0000015)
  assert_eq(p.stratum, 0)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, false)
}

///|
test "official reference era pivot 2085978495.875" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xff\xff\xff\xe1\xe0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x65\x1e\xb8\x00",
  )
  let sent = @ntp.from_unix(2085978495.875).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(2085978496.395).0,
    2085978496.395,
  )
  near(a.sample.delay_seconds, 0.5, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  // Documented reference difference: minimumErrorSeconds
  near(a.sample.offset_seconds, 0.25, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 2085978465.875, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.250991821, tolerance=0.0000015)
  near(a.server_transmit_unix, 2085978496.395, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference era pivot 2085978496.25" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\xff\xff\xff\xe2\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\x00\x00\x00\x00\x00\x00\x00\xc5\x1e\xb8\x00",
  )
  let sent = @ntp.from_unix(2085978496.25).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(2085978496.77).0,
    2085978496.77,
  )
  near(a.sample.delay_seconds, 0.5, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.25, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 2085978466.2499998, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.250991821, tolerance=0.0000015)
  near(a.server_transmit_unix, 2085978496.77, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference era pivot 1000.25" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\x83\xaa\x82\x4a\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x83\xaa\x82\x68\xc0\x00\x00\x00\x83\xaa\x82\x68\xc5\x1e\xb8\x51",
  )
  let sent = @ntp.from_unix(1000.25).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(1000.77).0,
    1000.77,
  )
  near(a.sample.delay_seconds, 0.5, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.25, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  near(a.reference_unix, 970.25, tolerance=0.0000015)
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.250991821, tolerance=0.0000015)
  near(a.server_transmit_unix, 1000.77, tolerance=0.0000015)
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}

///|
test "official reference era pivot -1.25" {
  let p = @ntp.decode(
    b"\x24\x02\x06\xec\x00\x00\x00\x00\x00\x00\x00\x41\x7f\x00\x00\x01\x83\xaa\x7e\x60\xc0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x83\xaa\x7e\x7f\x40\x00\x00\x00\x83\xaa\x7e\x7f\x45\x1e\xb8\x51",
  )
  let sent = @ntp.from_unix(-1.25).0
  let a = @ntp.analyze(
    sent,
    { ..p, origin: sent, },
    @ntp.from_unix(-0.73).0,
    -0.73,
  )
  near(a.sample.delay_seconds, 0.5, tolerance=0.0000015)
  assert_eq(p.leap, 0)
  near(a.minimum_error_seconds, 0.0, tolerance=0.0000015)
  near(a.sample.offset_seconds, 0.25, tolerance=0.0000015)
  near(a.poll_seconds, 64.0, tolerance=0.0000015)
  near(a.precision_seconds, 9.53e-07, tolerance=0.0000015)
  near(p.reference_id.to_double(), 2130706433.0, tolerance=0.0000015)
  assert_eq(a.reference_string, "127.0.0.1")
  // Documented reference difference: referenceUnix
  near(p.root_delay.to_double() / 65536.0, 0.0, tolerance=0.0000015)
  near(
    p.root_dispersion.to_double() / 65536.0,
    0.000991821,
    tolerance=0.0000015,
  )
  near(a.root_distance_seconds, 0.250991821, tolerance=0.0000015)
  // Documented reference difference: serverTransmitUnix
  assert_eq(p.stratum, 2)
  assert_eq(p.version, 4)
  let healthy = try {
    p.validate_health()
    true
  } catch {
    _ => false
  }
  assert_eq(healthy, true)
}
