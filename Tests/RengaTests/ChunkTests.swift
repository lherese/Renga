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
    XCTAssertNil(try? chunk.commit(block: firstBlock))
    XCTAssertEqual(chunk[testOffset], firstBlock)
    XCTAssertEqual(try? chunk.commit(block: secondBlock), firstBlock)
    XCTAssertEqual(chunk[testOffset], secondBlock)
  }

  func testAccess() {
    let chunk = TestChunk()

    chunk.commit(
      TestVoxel(chunk: chunk, offset: testOffset),
      TestVoxel(chunk: chunk, offset: testOffset + .top)
    )

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
    chunk.commit(firstBlock)

    XCTAssertEqual(firstBlock.neighbours, [
      .top: nil,
      .bottom: nil,
      .north: nil,
      .south: nil,
      .east: nil,
      .west: nil,
    ])

    let secondBlock = TestVoxel(chunk: chunk, offset: testOffset + .up)
    chunk.commit(secondBlock)

    XCTAssertEqual(firstBlock.neighbours, [
      .top: secondBlock,
      .bottom: nil,
      .north: nil,
      .south: nil,
      .east: nil,
      .west: nil,
    ])
  }

  func testGeometry() {
    let chunk = TestChunk()

    chunk.commit(TestVoxel(chunk: chunk, offset: testOffset))

    XCTAssertEqual(chunk.geometry.count, 1)
  }

  func testEraseBlock() throws {
    let chunk = TestChunk()

    XCTAssertThrowsError(try chunk.commit(block: nil)) { error in
      XCTAssertEqual(error as? RengaError, RengaError.noOffsetWhenErasingBlock)
    }

    try chunk.commit(block: TestVoxel(chunk: chunk, offset: testOffset))
    XCTAssertEqual(chunk.geometry.count, 1)

    try chunk.commit(block: nil, offset: testOffset)
    XCTAssertEqual(chunk.geometry.count, 0)
  }

}
