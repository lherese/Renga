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
      throw GeometryError.invalidDirection(x: x, y: y, z: z)
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

  init(integerLiteral value: Int) {
    let magnitude: Magnitude = value > 0
      ? .positive
      : .negative

    switch abs(value) {
    case 4:
      try! self.init(x: magnitude)
    case 2:
      try! self.init(y: magnitude)
    case 1:
      try! self.init(z: magnitude)
    default:
      preconditionFailure("Invalid direction specifier")
    }
  }

}
