public struct Direction: Codable, Hashable {
  let x: Magnitude
  let y: Magnitude
  let z: Magnitude

  init(x: Magnitude = .neither, y: Magnitude = .neither, z: Magnitude = .neither) throws {
    self.x = x
    self.y = y
    self.z = z

    guard
      abs(self.x.rawValue) + abs(self.y.rawValue) + abs(self.z.rawValue) == 1
    else {
      throw GeometryError.invalidFace(x: x, y: y, z: z)
    }
  }

  init(directions: [Magnitude]) throws {
    guard
      directions.count == 3
    else {
      throw GeometryError.invalidDirectionElements(count: directions.count)
    }

    try self.init(x: directions[0], y: directions[1], z: directions[2])
  }
}

extension Direction: ExpressibleByStringLiteral {

  public init(stringLiteral: String) {
    let directions = Array(stringLiteral)
      .map {
        Magnitude(unicodeScalarLiteral: $0)
      }

    try! self.init(directions: directions)
  }

}
