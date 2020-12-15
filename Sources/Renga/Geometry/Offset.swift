public struct Offset: Codable, Hashable {
  let x: Int
  let y: Int
  let z: Int

  public init(x: Int = 0, y: Int = 0, z: Int = 0) {
    self.x = x
    self.y = y
    self.z = z
  }

  public static func + (offset: Self, direction: Direction) -> Self {
    Self(x: offset.x + direction.x.rawValue, y: offset.y + direction.y.rawValue, z: offset.z + direction.z.rawValue)
  }

  public static func + (offset: Self, face: Face) -> Self {
    offset + face.rawValue
  }

  public static func + (start: Self, path: Path) -> Self {
    path.offset(from: start)
  }
}
