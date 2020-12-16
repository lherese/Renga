public enum Face: Int, Hashable, Codable, RawRepresentable {
  case top    =  0b001
  case north  =  0b100
  case east   = -0b010
  case south  = -0b100
  case west   =  0b010
  case bottom = -0b001

  public static var down: Self {
    .bottom
  }

  public static var up: Self {
    .top
  }

  public var direction: Direction {
    Direction(integerLiteral: self.rawValue)
  }

}
