fileprivate func linearize(x: Int, y: Int, z: Int) -> Int {
  x + y * Renga.lineCount + z * Renga.sheetCount
}

fileprivate func linearize(offset: Offset) -> Int {
  linearize(x: offset.x, y: offset.y, z: offset.z)
}

public class Chunk<Block: Voxel> {

  var blocks: [Block?] = Array(repeating: nil, count: Renga.blockCount)
  var defaultBlock: Block? = nil

  public struct GeometryFragment {
    public let block: Block
    public let offset: Offset
    public let exposedFaces: Set<Face>
  }

  public private(set) var geometry: [GeometryFragment] = []

  let frame = Frame(
    least: Offset(x: 0, y: 0, z: 0),
    most: Offset(x: Renga.blockPitch, y: Renga.blockPitch, z: Renga.blockPitch)
  )

  public private(set) subscript(offset: Offset) -> Block? {
    get {
      frame.contains(offset: offset)
        ? blocks[linearize(offset: offset)] ?? defaultBlock
        : nil
    }
    set (block) {
      guard
        frame.contains(offset: offset)
      else {
        preconditionFailure("Invalid block coordinates \(offset)")
      }

      blocks[linearize(offset: offset)] = block
    }
  }

  public private(set) subscript(x: Int, y: Int, z: Int) -> Block? {
    get {
      self[Offset(x: x, y: y, z: z)]
    }
    set (block) {
      self[Offset(x: x, y: y, z: z)] = block
    }
  }

  public init() { }

  public var allBlocks: [Block] {
    blocks.compactMap { $0 ?? defaultBlock }
  }

}

extension Chunk {

  func neighbours(offset: Offset) -> [Face: Block?] {
    var neighbourhood: [Face: Block?] = [:]

    for face in Face.allCases {
      neighbourhood[face] = self[offset + face]
    }

    return neighbourhood
  }

  func neighbours(block: Block) -> [Face: Block?] {
    neighbours(offset: block.offset)
  }

  private func updateGeometry() {
    geometry = allBlocks
      .compactMap {
        let faces = $0.exposedFaces

        return faces.count > 0
          ? GeometryFragment(block: $0, offset: $0.offset, exposedFaces: faces)
          : nil
      }
  }

  private func doCommit(block: Block?, offset: Offset) -> Block? {
    defer {
      self[offset] = block
    }

    return self[offset]
  }
}

public extension Chunk {

  @discardableResult
  func commit(block: Block?, offset: Offset? = nil) throws -> Block? {
    guard
      let offset = offset ?? block?.offset
    else {
      throw RengaError.noOffsetWhenErasingBlock
    }

    defer {
      updateGeometry()
    }

    return doCommit(block: block, offset: offset)
  }

  @discardableResult
  func commit(_ blocks: [Block]) -> [Block?] {
    defer {
      updateGeometry()
    }

    return blocks.map {
      doCommit(block: $0, offset: $0.offset)
    }
  }

  @discardableResult
  func commit(_ blocks: Block...) -> [Block?] {
    commit(blocks)
  }

}
