///|
pub(all) struct ExtensionField {
  field_type : Int
  // Includes any wire padding, which cannot be distinguished from payload.
  value : Bytes
} derive(Debug, Eq)

///|
pub(all) struct Datagram {
  header : Packet
  extensions : Array[ExtensionField]
  mac : Bytes
} derive(Debug, Eq)

///|
/// Explicit expected MAC size avoids guessing whether a tail is an extension.
/// Supports no MAC, a 4-byte crypto-NAK, or the common 20/24-byte MAC forms.
pub fn decode_datagram(
  bytes : Bytes,
  mac_length? : Int = 0,
) -> Datagram raise NtpError {
  if ![0, 4, 20, 24].contains(mac_length) {
    raise Invalid("unsupported MAC length")
  }
  if bytes.length() < 48 + mac_length || bytes.length() > 65507 {
    raise Invalid("expected 48-byte header and bounded datagram")
  }
  let end = bytes.length() - mac_length
  let fields = []
  let mut pos = 48
  while pos < end {
    if end - pos < 4 {
      raise Invalid("truncated extension header")
    }
    let kind = bytes[pos].to_int() * 256 + bytes[pos + 1].to_int()
    let length = bytes[pos + 2].to_int() * 256 + bytes[pos + 3].to_int()
    if length < 16 || length % 4 != 0 || length > end - pos {
      raise Invalid("invalid extension length")
    }
    if fields.length() >= 64 {
      raise Invalid("extension count limit")
    }
    if mac_length == 0 && pos + length == end && length < 28 {
      raise Invalid("last unauthenticated extension must be at least 28 bytes")
    }
    fields.push({
      field_type: kind,
      value: bytes[pos + 4:pos + length].to_owned(),
    })
    pos += length
  }
  if mac_length == 4 && read32(bytes, end) != 0U {
    raise Invalid("crypto-NAK must have a zero key identifier")
  }
  {
    header: decode(bytes[:48].to_owned()),
    extensions: fields,
    mac: bytes[end:].to_owned(),
  }
}

///|
pub fn Datagram::encode(self : Datagram) -> Bytes raise NtpError {
  if self.extensions.length() > 64 ||
    ![0, 4, 20, 24].contains(self.mac.length()) {
    raise Invalid("datagram field limit")
  }
  let out = self.header.encode().to_array()
  for field in self.extensions {
    let length = field.value.length() + 4
    if field.field_type < 0 ||
      field.field_type > 65535 ||
      length < 16 ||
      length > 65532 ||
      length % 4 != 0 {
      raise Invalid("invalid extension")
    }
    if out.length() + length + self.mac.length() > 65507 {
      raise Invalid("datagram size limit")
    }
    out.push((field.field_type >> 8).to_byte())
    out.push(field.field_type.to_byte())
    out.push((length >> 8).to_byte())
    out.push(length.to_byte())
    for byte in field.value {
      out.push(byte)
    }
  }
  for byte in self.mac {
    out.push(byte)
  }
  let bytes = Bytes::from_array(out)
  ignore(decode_datagram(bytes, mac_length=self.mac.length()))
  bytes
}
