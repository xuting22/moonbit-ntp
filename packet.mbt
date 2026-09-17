///|
pub suberror NtpError {
  Invalid(String)
} derive(Debug)

///|
pub(all) struct Timestamp {
  seconds : UInt
  fraction : UInt
} derive(Debug, Eq)

///|
pub(all) struct Packet {
  leap : Int
  version : Int
  mode : Int
  stratum : Int
  poll : Int
  precision : Int
  root_delay : Int
  root_dispersion : UInt
  reference_id : UInt
  reference : Timestamp
  origin : Timestamp
  receive : Timestamp
  transmit : Timestamp
} derive(Debug, Eq)

///|
pub fn Timestamp::zero() -> Timestamp {
  { seconds: 0U, fraction: 0U, }
}

///|
/// NTP era is supplied by the caller: 0 before 2036 rollover, 1 afterwards.
pub fn Timestamp::unix_seconds(
  self : Timestamp,
  era : Int,
) -> Double raise NtpError {
  if era < 0 || era > 1 {
    raise Invalid("only eras 0 and 1 supported")
  }
  era.to_double() * 4294967296.0 +
  self.seconds.to_double() -
  2208988800.0 +
  self.fraction.to_double() / 4294967296.0
}

///|
pub fn from_unix(seconds : Double) -> (Timestamp, Int) raise NtpError {
  if !finite(seconds) || seconds < -2208988800.0 || seconds >= 6380945792.0 {
    raise Invalid("time outside supported eras")
  }
  let integer = seconds.floor()
  let whole = (integer + 2208988800.0).to_uint64()
  let era = (whole / 4294967296UL).to_int()
  let stamp : Timestamp = {
    seconds: whole.to_uint(),
    fraction: ((seconds - integer) * 4294967296.0).to_uint(),
  }
  (stamp, era)
}

///|
/// Modular signed seconds handle era rollover; intervals must be less than 2^31 seconds.
pub fn Timestamp::difference(self : Timestamp, earlier : Timestamp) -> Double {
  (self.seconds - earlier.seconds).reinterpret_as_int().to_double() +
  (self.fraction.to_double() - earlier.fraction.to_double()) / 4294967296.0
}

///|
fn read32(bytes : Bytes, pos : Int) -> UInt {
  (bytes[pos].to_uint() << 24) |
  (bytes[pos + 1].to_uint() << 16) |
  (bytes[pos + 2].to_uint() << 8) |
  bytes[pos + 3].to_uint()
}

///|
fn write32(out : Array[Byte], n : UInt) -> Unit {
  out.push((n >> 24).to_byte())
  out.push((n >> 16).to_byte())
  out.push((n >> 8).to_byte())
  out.push(n.to_byte())
}

///|
fn stamp(bytes : Bytes, pos : Int) -> Timestamp {
  { seconds: read32(bytes, pos), fraction: read32(bytes, pos + 4), }
}

///|
pub fn decode(bytes : Bytes) -> Packet raise NtpError {
  if bytes.length() != 48 {
    raise Invalid("expected base 48-byte NTP packet; extensions unsupported")
  }
  let signed = fn(b : Byte) {
    let n = b.to_int()
    if n >= 128 {
      n - 256
    } else {
      n
    }
  }
  {
    leap: bytes[0].to_int() >> 6,
    version: (bytes[0].to_int() >> 3) & 7,
    mode: bytes[0].to_int() & 7,
    stratum: bytes[1].to_int(),
    poll: signed(bytes[2]),
    precision: signed(bytes[3]),
    root_delay: read32(bytes, 4).reinterpret_as_int(),
    root_dispersion: read32(bytes, 8),
    reference_id: read32(bytes, 12),
    reference: stamp(bytes, 16),
    origin: stamp(bytes, 24),
    receive: stamp(bytes, 32),
    transmit: stamp(bytes, 40),
  }
}

///|
pub fn Packet::encode(self : Packet) -> Bytes raise NtpError {
  if self.leap < 0 ||
    self.leap > 3 ||
    self.version < 1 ||
    self.version > 4 ||
    self.mode < 0 ||
    self.mode > 7 ||
    self.stratum < 0 ||
    self.stratum > 255 ||
    self.poll < -128 ||
    self.poll > 127 ||
    self.precision < -128 ||
    self.precision > 127 {
    raise Invalid("invalid packet field")
  }
  let out : Array[Byte] = [
    ((self.leap << 6) | (self.version << 3) | self.mode).to_byte(),
    self.stratum.to_byte(),
    self.poll.to_byte(),
    self.precision.to_byte(),
  ]
  write32(out, self.root_delay.reinterpret_as_uint())
  write32(out, self.root_dispersion)
  write32(out, self.reference_id)
  for t in [self.reference, self.origin, self.receive, self.transmit] {
    write32(out, t.seconds)
    write32(out, t.fraction)
  }
  Bytes::from_array(out)
}

///|
pub fn request(transmit : Timestamp) -> Packet {
  {
    leap: 0,
    version: 4,
    mode: 3,
    stratum: 0,
    poll: 6,
    precision: -20,
    root_delay: 0,
    root_dispersion: 0U,
    reference_id: 0U,
    reference: Timestamp::zero(),
    origin: Timestamp::zero(),
    receive: Timestamp::zero(),
    transmit,
  }
}
