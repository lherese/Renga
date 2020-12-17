fileprivate func linearize(x: Int, y: Int, z: Int) -> Int {
  x + y * Renga.lineCount + z * Renga.sheetCount
}

fileprivate func linearize(offset: Offset) -> Int {
  linearize(x: offset.x, y: offset.y, z: offset.z)
}

public class Chunk<Block: Voxel> {

  var blocks: [Block?] = Array(repeating: nil, count: Renga.blockCount)
  var defaultBlock: Block? = nil

  let frame = Frame(
    least: Offset(x: 0, y: 0, z: 0),
    most: Offset(x: Renga.blockPitch, y: Renga.blockPitch, z: Renga.blockPitch)
  )

  public internal(set) subscript(offset: Offset) -> Block? {
    get {
      frame.contains(offset: offset)
        ? blocks[linearize(offset: offset)]
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

  public internal(set) subscript(x: Int, y: Int, z: Int) -> Block? {
    get {
      self[Offset(x: x, y: y, z: z)]
    }
    set (block) {
      self[Offset(x: x, y: y, z: z)] = block
    }
  }

  public init() { }

  public var allBlocks: [Block] {
    blocks.compactMap { $0 }
  }

  public var exposedBlocks: [Block] {
    allBlocks
      .filter {
        $0.exposedFaces.count > 0
      }
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

}
