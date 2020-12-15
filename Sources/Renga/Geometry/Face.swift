public enum Face: Direction, Equatable {
  case top = "00+"
  case north = "+00"
  case east = "0-0"
  case south = "-00"
  case west = "0+0"
  case bottom = "00-"

  public static var down: Self {
    .bottom
  }

  public static var up: Self {
    .top
  }
}
