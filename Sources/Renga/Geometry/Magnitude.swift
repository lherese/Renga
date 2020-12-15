public enum Magnitude: Int, Codable, Hashable {
  case positive = 1
  case neither = 0
  case negative = -1
}

extension Magnitude: ExpressibleByUnicodeScalarLiteral {

  public init(unicodeScalarLiteral value: Character) {
    switch value {
    case "0":
      self.init(rawValue: 0)!
      break
    case "-":
      self.init(rawValue: -1)!
      break
    case "+":
      self.init(rawValue: 1)!
      break
    default:
      preconditionFailure("Invalid direction character: '\(value)'")
    }
  }

}
