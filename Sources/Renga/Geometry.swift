public enum GeometryError: Error {
  case invalidFace(x: Magnitude, y: Magnitude, z: Magnitude)
  case invalidDirectionElements(count: Int)
}
