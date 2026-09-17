///|
pub(all) struct PeerEstimate {
  id : String
  offset_seconds : Double
  root_distance_seconds : Double
  jitter_seconds : Double
  stratum : Int
} derive(Debug, Eq)

///|
pub(all) struct Consensus {
  offset_seconds : Double
  jitter_seconds : Double
  selection_jitter_seconds : Double
  interval_low : Double
  interval_high : Double
  system_peer : String
  survivors : Array[String]
  rejected : Array[String]
} derive(Debug)

///|
priv struct Endpoint {
  value : Double
  kind : Int
}

///|
/// RFC 5905 section 11.2 interval selection, iterative clustering and
/// inverse-root-distance combination. This does not perform clock discipline.
pub fn combine_peers(
  peers : Array[PeerEstimate],
  minimum? : Int = 1,
  cluster_minimum? : Int = 3,
  maximum_distance? : Double = 1.0,
) -> Consensus? raise NtpError {
  if peers.length() > 64 ||
    minimum < 1 ||
    minimum > 64 ||
    cluster_minimum < minimum ||
    cluster_minimum > 64 ||
    !finite(maximum_distance) ||
    maximum_distance <= 0.0 ||
    maximum_distance > 16.0 {
    raise Invalid("invalid consensus limits")
  }
  let ids : Map[String, Bool] = Map([])
  let valid = []
  let rejected = []
  for peer in peers {
    if peer.id.is_empty() || peer.id.length() > 256 || ids.contains(peer.id) {
      raise Invalid("invalid or duplicate peer identifier")
    }
    ids[peer.id] = true
    if !finite(peer.offset_seconds) ||
      peer.offset_seconds.abs() > 2147483648.0 ||
      !finite(peer.root_distance_seconds) ||
      peer.root_distance_seconds <= 0.0 ||
      peer.root_distance_seconds > maximum_distance ||
      !finite(peer.jitter_seconds) ||
      peer.jitter_seconds < 0.0 ||
      peer.jitter_seconds > 2147483648.0 ||
      peer.stratum < 1 ||
      peer.stratum > 15 {
      rejected.push(peer.id)
    } else {
      valid.push(peer)
    }
  }
  if valid.length() < minimum {
    return None
  }
  let endpoints : Array[Endpoint] = []
  for p in valid {
    endpoints.push({
      value: p.offset_seconds - p.root_distance_seconds,
      kind: -1,
    })
    endpoints.push({ value: p.offset_seconds, kind: 0, })
    endpoints.push({
      value: p.offset_seconds + p.root_distance_seconds,
      kind: 1,
    })
  }
  endpoints.sort_by((a, b) => {
    if a.value < b.value {
      -1
    } else if a.value > b.value {
      1
    } else {
      a.kind - b.kind
    }
  })
  let mut interval : (Double, Double)? = None
  let n = valid.length()
  for allowed = 0; allowed * 2 < n; allowed = allowed + 1 {
    let mut outside = 0
    let mut overlap = 0
    let mut low : Double? = None
    let mut high : Double? = None
    for edge in endpoints {
      overlap -= edge.kind
      if overlap >= n - allowed {
        low = Some(edge.value)
        break
      }
      if edge.kind == 0 {
        outside += 1
      }
    }
    overlap = 0
    for i = endpoints.length() - 1; i >= 0; i = i - 1 {
      let edge = endpoints[i]
      overlap += edge.kind
      if overlap >= n - allowed {
        high = Some(edge.value)
        break
      }
      if edge.kind == 0 {
        outside += 1
      }
    }
    if low is Some(l) && high is Some(h) && l < h && outside == allowed {
      interval = Some((l, h))
      break
    }
  }
  guard interval is Some((low, high)) else { return None }
  let survivors = []
  for peer in valid {
    if peer.offset_seconds >= low && peer.offset_seconds <= high {
      survivors.push(peer)
    } else {
      rejected.push(peer.id)
    }
  }
  if survivors.length() < minimum {
    return None
  }
  survivors.sort_by((a, b) => {
    let x = a.stratum.to_double() * maximum_distance + a.root_distance_seconds
    let y = b.stratum.to_double() * maximum_distance + b.root_distance_seconds
    if x < y {
      -1
    } else if x > y {
      1
    } else {
      a.id.compare(b.id)
    }
  })
  let mut selection_jitter = 0.0
  while true {
    let count = survivors.length()
    let mut maximum = -1.0
    let mut worst = 0
    let mut minimum_jitter = 2147483648.0
    for i in 0..<count {
      let peer = survivors[i]
      minimum_jitter = minimum_jitter.min(peer.jitter_seconds)
      let mut squared = 0.0
      for other in survivors {
        let delta = peer.offset_seconds - other.offset_seconds
        squared += delta * delta
      }
      let jitter = if count > 1 {
        (squared / (count - 1).to_double()).sqrt()
      } else {
        0.0
      }
      // Break exact ties by removing the worse-ranked peer.
      if jitter >= maximum {
        maximum = jitter
        worst = i
      }
    }
    selection_jitter = maximum
    if maximum < minimum_jitter || count <= cluster_minimum {
      break
    }
    rejected.push(survivors[worst].id)
    ignore(survivors.remove(worst))
  }
  let mut weights = 0.0
  let mut offset = 0.0
  let mut peer_jitter = 0.0
  // Scale by the smallest distance to avoid reciprocal overflow.
  let scale = survivors.fold(init=16.0, (n, p) => n.min(p.root_distance_seconds))
  for peer in survivors {
    let w = scale / peer.root_distance_seconds
    weights += w
    offset += w * peer.offset_seconds
    peer_jitter += w * peer.jitter_seconds * peer.jitter_seconds
  }
  Some({
    offset_seconds: offset / weights,
    jitter_seconds: (selection_jitter * selection_jitter + peer_jitter / weights).sqrt(),
    selection_jitter_seconds: selection_jitter,
    interval_low: low,
    interval_high: high,
    system_peer: survivors[0].id,
    survivors: survivors.map(p => p.id),
    rejected,
  })
}
