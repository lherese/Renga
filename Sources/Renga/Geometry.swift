public enum GeometryError: Error {
  case invalidDirection(x: Magnitude, y: Magnitude, z: Magnitude)
  case invalidDirectionElements(count: Int)
}
