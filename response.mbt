///|
/// Returns an ASCII kiss-of-death code for stratum-zero replies.
pub fn Packet::kiss_code(self : Packet) -> String? {
  if self.stratum != 0 {
    return None
  }
  let chars = []
  for shift in [24, 16, 8, 0] {
    let n = ((self.reference_id >> shift) & 255U).reinterpret_as_int()
    if n < 32 || n > 126 {
      return None
    }
    chars.push(n.unsafe_to_char())
  }
  Some(String::from_array(chars))
}
