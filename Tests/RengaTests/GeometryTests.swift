import XCTest

import Renga

final class GeometryTests: XCTestCase {

  func testTraverse() {
    let start = Offset()
    let end = start + .top

    XCTAssertEqual(end, Offset(z: 1))
  }

  func testPath() {
    let start = Offset(x: 1)
    let path = Path(.up, .up, .west, .down)

    XCTAssertEqual(start + path, Offset(x: 1, y: 1, z: 1))
  }

  func testBuildPath() {
    let path1 = Path(.top, .west, .west)
    let path2 = Path() + .top + .west + .west

    XCTAssertEqual(path1, path2)
  }

}
