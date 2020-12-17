import XCTest

import Renga

final class ChunkTests: XCTestCase {

  typealias TestChunk = Chunk<TestVoxel>

  struct TestVoxel: Voxel, Equatable, CustomStringConvertible, Hashable {

    static var _nextID: Int = 0

    static var nextID: Int {
      _nextID += 1

      return _nextID
    }

    let chunk: TestChunk
    let offset: Offset

    let transparent: Bool

    let id: Int = Self.nextID

    init(chunk: TestChunk, offset: Offset, transparent: Bool = false) {
      self.chunk = chunk
      self.offset = offset
      self.transparent = transparent
    }

    static func == (a: TestVoxel, b: TestVoxel) -> Bool {
      a.id == b.id
    }

    var description: String {
      "Block #\(id)"
    }

    func hash(into hasher: inout Hasher) {
      id.hash(into: &hasher)
    }

  }

  let testOffset = Offset(x: 2, y: 2, z: 2)

  func testReplace() {
    let chunk = TestChunk()

    let firstBlock = TestVoxel(chunk: chunk, offset: testOffset)
    let secondBlock = TestVoxel(chunk: chunk, offset: testOffset)

    XCTAssertNil(chunk[testOffset])
    XCTAssertNil(firstBlock.commit())
    XCTAssertEqual(chunk[testOffset], firstBlock)
    XCTAssertEqual(secondBlock.commit(), firstBlock)
    XCTAssertEqual(chunk[testOffset], secondBlock)
  }

  func testAccess() {
    let chunk = TestChunk()

    TestVoxel(chunk: chunk, offset: testOffset).commit()
    TestVoxel(chunk: chunk, offset: testOffset + .top).commit()

    var n = 0

    for i in 0..<Renga.lineCount {
      for j in 0..<Renga.lineCount {
        for k in 0..<Renga.lineCount {
          if chunk[i, j, k] != nil {
            n += 1
          }
        }
      }
    }

    XCTAssertEqual(n, 2)
  }

  func testNeighbours() {
    let chunk = TestChunk()

    let firstBlock = TestVoxel(chunk: chunk, offset: testOffset)
    firstBlock.commit()

    XCTAssertEqual(firstBlock.neighbours, [
      .top: nil,
      .bottom: nil,
      .north: nil,
      .south: nil,
      .east: nil,
      .west: nil,
    ])

    let secondBlock = TestVoxel(chunk: chunk, offset: testOffset + .up)
    secondBlock.commit()

    XCTAssertEqual(firstBlock.neighbours, [
      .top: secondBlock,
      .bottom: nil,
      .north: nil,
      .south: nil,
      .east: nil,
      .west: nil,
    ])
  }

  func testExposed() {
    let chunk = TestChunk()

    let firstBlock = TestVoxel(chunk: chunk, offset: testOffset)
    firstBlock.commit()

    XCTAssertEqual(firstBlock.exposedFaces, Set(Face.allCases))

    let secondBlock = TestVoxel(chunk: chunk, offset: testOffset + .up)
    secondBlock.commit()

    let thirdBlock = TestVoxel(chunk: chunk, offset: testOffset + .down, transparent: true)
    thirdBlock.commit()

    XCTAssertEqual(firstBlock.exposedFaces, Set(Face.allCases).subtracting([.top]))

    XCTAssertEqual(Set(chunk.exposedBlocks), [firstBlock, secondBlock, thirdBlock])
  }

}
