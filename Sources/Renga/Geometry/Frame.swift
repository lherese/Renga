struct Frame: Codable, Hashable {
  let least: Offset
  let most: Offset

  init (least: Offset, most: Offset) {
    guard
      least.x <= most.x,
      least.y <= most.y,
      least.z <= most.z
    else {
      preconditionFailure("Invalid Frame: \(least) is bigger than \(most)")
    }

    self.least = least
    self.most = most
  }

  func contains(offset: Offset) -> Bool {
    ![\Offset.x, \Offset.y, \Offset.z]
      .map {
        (least[keyPath: $0]..<most[keyPath: $0]).contains(offset[keyPath: $0])
      }
      .contains(false)
  }

}
