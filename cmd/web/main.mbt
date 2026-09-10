///|
pub fn run(input : String) -> String {
  try {
    let p = @lib.decode(unhex(input))
    Repr(p).to_string() + "\n\nRe-encoded: " + hex(p.encode())
  } catch {
    e => "ERROR: " + Repr(e).to_string()
  }
}

///|
fn main {

}

///|
fn unhex(text : String) -> Bytes raise {
  let out : Array[Byte] = []
  let mut high = -1
  if text.length() > 200000 {
    raise Failure("input too long")
  }
  for c in text.iter() {
    if c == ' ' || c == '\n' || c == '\r' || c == '\t' {
      continue
    }
    let n = if c >= '0' && c <= '9' {
      c.to_int() - 48
    } else if c >= 'a' && c <= 'f' {
      c.to_int() - 87
    } else if c >= 'A' && c <= 'F' {
      c.to_int() - 55
    } else {
      raise Failure("invalid hex character")
    }
    if high < 0 {
      high = n
    } else {
      out.push((high * 16 + n).to_byte())
      high = -1
    }
  }
  if high >= 0 {
    raise Failure("odd hex length")
  }
  Bytes::from_array(out)
}

///|
fn hex(data : Bytes) -> String {
  let alphabet = "0123456789abcdef"
  let out = []
  for b in data {
    let n = b.to_int()
    out.push(
      alphabet[n / 16:n / 16 + 1].to_owned() +
      alphabet[n % 16:n % 16 + 1].to_owned(),
    )
  }
  out.join("")
}

///|
pub fn query_request(unix_seconds : Double) -> String {
  try {
    let (stamp, _) = @lib.from_unix(unix_seconds)
    hex(@lib.request(stamp).encode())
  } catch {
    e => "ERROR: " + Repr(e).to_string()
  }
}

///|
fn query_result(
  sent_hex : String,
  received_unix : Double,
  reply_hex : String,
  local_sent : Double?,
) -> String {
  try {
    let sent = @lib.decode(unhex(sent_hex)).transmit
    let reply = @lib.decode(unhex(reply_hex))
    if reply.origin != sent {
      raise Failure("origin mismatch")
    }
    if reply.stratum == 0 {
      raise Failure(
        "Kiss-of-death: " +
        (match reply.kiss_code() {
          Some(c) => c
          None => "unknown"
        }),
      )
    }
    let (arrived, _) = @lib.from_unix(received_unix)
    let actual_sent = match local_sent {
      Some(value) => @lib.from_unix(value).0
      None => sent
    }
    let timed_reply = { ..reply, origin: actual_sent, }
    let sample = @lib.measure(actual_sent, timed_reply, arrived)
    reply.validate_health()
    let server_time = received_unix + reply.transmit.difference(arrived)
    "{\"offsetSeconds\":" +
    sample.offset_seconds.to_string() +
    ",\"delaySeconds\":" +
    sample.delay_seconds.to_string() +
    ",\"serverTransmitUnix\":" +
    server_time.to_string() +
    ",\"rootDistanceSeconds\":" +
    reply.root_distance(sample).to_string() +
    ",\"stratum\":" +
    reply.stratum.to_string() +
    ",\"leap\":" +
    reply.leap.to_string() +
    ",\"rootDelaySeconds\":" +
    (reply.root_delay.to_double() / 65536.0).to_string() +
    ",\"rootDispersionSeconds\":" +
    (reply.root_dispersion.to_double() / 65536.0).to_string() +
    "}"
  } catch {
    e => "ERROR: " + Repr(e).to_string()
  }
}

///|
pub fn query_response(
  sent_hex : String,
  received_unix : Double,
  reply_hex : String,
) -> String {
  query_result(sent_hex, received_unix, reply_hex, None)
}

///|
pub fn query_response_at(
  sent_hex : String,
  sent_unix : Double,
  received_unix : Double,
  reply_hex : String,
) -> String {
  query_result(sent_hex, received_unix, reply_hex, Some(sent_unix))
}
