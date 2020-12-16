public struct Path: Codable, Hashable {
  let elements: [Direction]

  func offset(from start: Offset = Offset()) ->  Offset {
    elements.reduce(start, +)
  }

  public static func + (a: Self, b: Self) -> Self {
    Self(elements: a.elements + b.elements)
  }

  public static func + (path: Self, direction: Direction) -> Self {
    path + Self(direction)
  }

  public static func + (path: Self, face: Face) -> Self {
    path + face.direction
  }
}

public extension Path {

  init() {
    self.init(elements: [])
  }

  init(_ elements: [Direction]) {
    self.init(elements: elements)
  }

  init(_ elements: Direction...) {
    self.init(elements)
  }

  init(_ faces: [Face]) {
    self.init(faces.map(\.direction))
  }

  init(_ faces: Face...) {
    self.init(faces)
  }

}
