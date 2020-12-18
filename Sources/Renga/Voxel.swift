public protocol Voxel {

  typealias ChunkType = Chunk<Self>

  var chunk: ChunkType { get }
  var offset: Offset { get }

  var transparent: Bool { get }

}

public extension Voxel {

  var neighbours: [Face: Self?] {
    chunk.neighbours(block: self)
  }

  var exposedFaces: Set<Face> {
    Set(Face.allCases).subtracting(
      neighbours
        .compactMapValues { $0?.transparent ?? true ? nil : $0 }
        .keys
    )
  }

}
