///|
let filters : Map[Int, @lib.ClockFilter] = Map([])

///|
let next_filter : Ref[Int] = Ref(1)

///|
fn[T : @json.FromJson] field(
  fields : Map[String, Json],
  key : String,
) -> T raise {
  @json.from_json(fields.get(key).unwrap_or(Json::null()))
}

///|
fn number(
  fields : Map[String, Json],
  key : String,
  default : Double,
) -> Double raise {
  @json.from_json(fields.get(key).unwrap_or(default.to_json()))
}

///|
fn packet_json(p : @lib.Packet) -> Json {
  {
    "leap": p.leap.to_json(),
    "version": p.version.to_json(),
    "mode": p.mode.to_json(),
    "stratum": p.stratum.to_json(),
    "poll": p.poll.to_json(),
    "precision": p.precision.to_json(),
    "rootDelaySeconds": (p.root_delay.to_double() / 65536.0).to_json(),
    "rootDispersionSeconds": (p.root_dispersion.to_double() / 65536.0).to_json(),
    "referenceID": p.reference_id.to_double().to_json(),
    "referenceString": p.reference_string().to_json(),
    "kissCode": p.kiss_code().unwrap_or("").to_json(),
  }
}

///|
fn filter_json(value : @lib.FilterEstimate?) -> Json {
  match value {
    None => Json::null()
    Some(v) =>
      {
        "offsetSeconds": v.offset_seconds.to_json(),
        "delaySeconds": v.delay_seconds.to_json(),
        "dispersionSeconds": v.dispersion_seconds.to_json(),
        "jitterSeconds": v.jitter_seconds.to_json(),
        "selectedAt": v.selected_at.to_json(),
        "evaluatedAt": v.evaluated_at.to_json(),
        "validSamples": v.valid_samples.to_json(),
        "reach": v.reach.to_json(),
        "fresh": v.fresh.to_json(),
      }
  }
}

///|
fn extensions(fields : Map[String, Json]) -> Array[@lib.ExtensionField] raise {
  let values : Array[Json] = @json.from_json(
    fields.get("extensions").unwrap_or(Json::array([])),
  )
  values.map(value => {
    guard value is Object(data) else { fail("extension object required") }
    for name, _ in data {
      if !["type", "valueHex"].contains(name) {
        fail("unknown extension option")
      }
    }
    { field_type: field(data, "type"), value: unhex(field(data, "valueHex")), }
  })
}

///|
pub fn protocol(input : String) -> String {
  try {
    if input.length() > 300000 {
      fail("protocol request too long")
    }
    guard @json.parse(input) is Object(fields) else {
      fail("request object required")
    }
    let op : String = field(fields, "op")
    let allowed = match op {
      "decode" => ["op", "hex", "macLength"]
      "encode" => ["op", "headerHex", "extensions", "macHex"]
      "analyze" =>
        [
          "op", "sentHex", "sentUnix", "receivedUnix", "replyHex", "macLength", "validate",
        ]
      "filterOpen" => ["op", "precision", "tolerance"]
      "filterPoll" | "filterState" => ["op", "id", "now"]
      "filterObserve" => ["op", "id", "offset", "delay", "dispersion", "now"]
      "filterDistance" => ["op", "id", "now", "rootDelay", "rootDispersion"]
      "filterClose" => ["op", "id"]
      "combine" =>
        ["op", "peers", "minimum", "clusterMinimum", "maximumDistance"]
      _ => fail("unknown protocol operation")
    }
    for key, _ in fields {
      if !allowed.contains(key) {
        fail("unknown protocol option: " + key)
      }
    }
    let value : Json = match op {
      "decode" => {
        let size : Int = @json.from_json(
          fields.get("macLength").unwrap_or((0).to_json()),
        )
        let d = @lib.decode_datagram(
          unhex(field(fields, "hex")),
          mac_length=size,
        )
        {
          "header": packet_json(d.header),
          "headerHex": hex(d.header.encode()).to_json(),
          "extensions": d.extensions
          .map(e => {
            (
              {
                "type": e.field_type.to_json(),
                "valueHex": hex(e.value).to_json(),
              } : Json)
          })
          .to_json(),
          "macHex": hex(d.mac).to_json(),
        }
      }
      "encode" => {
        let mac : String = @json.from_json(
          fields.get("macHex").unwrap_or("".to_json()),
        )
        let d : @lib.Datagram = {
          header: @lib.decode(unhex(field(fields, "headerHex"))),
          extensions: extensions(fields),
          mac: unhex(mac),
        }
        hex(d.encode()).to_json()
      }
      "analyze" => {
        let sent = @lib.decode(unhex(field(fields, "sentHex"))).transmit
        let size : Int = @json.from_json(
          fields.get("macLength").unwrap_or((0).to_json()),
        )
        let reply = @lib.decode_datagram(
          unhex(field(fields, "replyHex")),
          mac_length=size,
        )
        let p = reply.header
        if p.origin != sent {
          fail("origin mismatch")
        }
        let sent_unix : Double = field(fields, "sentUnix")
        let received : Double = field(fields, "receivedUnix")
        let actual = @lib.from_unix(sent_unix).0
        let analysis = @lib.analyze(
          actual,
          { ..p, origin: actual, },
          @lib.from_unix(received).0,
          received,
        )
        let health = try {
          p.validate_health()
          None
        } catch {
          e => Some(Repr(e).to_string())
        }
        let validate : Bool = @json.from_json(
          fields.get("validate").unwrap_or(true.to_json()),
        )
        if validate && health is Some(message) {
          fail(
            if p.stratum == 0 {
              "Kiss-of-death: " + p.kiss_code().unwrap_or("unknown")
            } else {
              message
            },
          )
        }
        {
          "header": packet_json(p),
          "offsetSeconds": analysis.sample.offset_seconds.to_json(),
          "delaySeconds": analysis.sample.delay_seconds.to_json(),
          "serverTransmitUnix": analysis.server_transmit_unix.to_json(),
          "referenceUnix": analysis.reference_unix.to_json(),
          "precisionSeconds": analysis.precision_seconds.to_json(),
          "pollSeconds": analysis.poll_seconds.to_json(),
          "minimumErrorSeconds": analysis.minimum_error_seconds.to_json(),
          "rootDistanceSeconds": analysis.root_distance_seconds.to_json(),
          "healthError": health.to_json(),
          "extensions": reply.extensions
          .map(e => {
            (
              {
                "type": e.field_type.to_json(),
                "valueHex": hex(e.value).to_json(),
              } : Json)
          })
          .to_json(),
        }
      }
      "filterOpen" => {
        if filters.length() >= 256 || next_filter.val >= 1000000000 {
          fail("filter handle limit")
        }
        let value = @lib.ClockFilter::new(
          precision_seconds=number(fields, "precision", 0.000001),
          frequency_tolerance=number(fields, "tolerance", 0.000015),
        )
        let id = next_filter.val
        next_filter.val += 1
        filters[id] = value
        id.to_json()
      }
      "filterPoll"
      | "filterState"
      | "filterObserve"
      | "filterClose"
      | "filterDistance" => {
        let id : Int = field(fields, "id")
        guard filters.get(id) is Some(filter) else {
          fail("unknown filter handle")
        }
        if op == "filterClose" {
          filters.remove(id)
          Json::null()
        } else {
          let now : Double = field(fields, "now")
          if op == "filterPoll" {
            filter.begin_poll(now)
            Json::null()
          } else if op == "filterObserve" {
            filter_json(
              filter.observe({
                offset_seconds: field(fields, "offset"),
                delay_seconds: field(fields, "delay"),
                dispersion_seconds: field(fields, "dispersion"),
                received_at: now,
              }),
            )
          } else if op == "filterDistance" {
            match filter.estimate(now) {
              Some(value) =>
                value
                .root_distance(
                  field(fields, "rootDelay"),
                  field(fields, "rootDispersion"),
                )
                .to_json()
              None => Json::null()
            }
          } else {
            filter_json(filter.estimate(now))
          }
        }
      }
      "combine" => {
        let list : Array[Json] = field(fields, "peers")
        let peers : Array[@lib.PeerEstimate] = list.map(value => {
          guard value is Object(p) else { fail("peer object required") }
          for key, _ in p {
            if ![
                "id", "offsetSeconds", "rootDistanceSeconds", "jitterSeconds", "stratum",
              ].contains(key) {
              fail("unknown peer option")
            }
          }
          {
            id: field(p, "id"),
            offset_seconds: field(p, "offsetSeconds"),
            root_distance_seconds: field(p, "rootDistanceSeconds"),
            jitter_seconds: field(p, "jitterSeconds"),
            stratum: field(p, "stratum"),
          }
        })
        let minimum : Int = @json.from_json(
          fields.get("minimum").unwrap_or((1).to_json()),
        )
        let cluster : Int = @json.from_json(
          fields.get("clusterMinimum").unwrap_or((3).to_json()),
        )
        match
          @lib.combine_peers(
            peers,
            minimum~,
            cluster_minimum=cluster,
            maximum_distance=number(fields, "maximumDistance", 1.0),
          ) {
          None => Json::null()
          Some(v) =>
            {
              "offsetSeconds": v.offset_seconds.to_json(),
              "jitterSeconds": v.jitter_seconds.to_json(),
              "selectionJitterSeconds": v.selection_jitter_seconds.to_json(),
              "intervalLow": v.interval_low.to_json(),
              "intervalHigh": v.interval_high.to_json(),
              "systemPeer": v.system_peer.to_json(),
              "survivors": v.survivors.to_json(),
              "rejected": v.rejected.to_json(),
            }
        }
      }
      _ => fail("unknown operation")
    }
    ({ "ok": true.to_json(), "value": value } : Json).stringify()
  } catch {
    error =>
      (
        { "ok": false.to_json(), "error": Repr(error).to_string().to_json() } :
        Json).stringify()
  }
}
