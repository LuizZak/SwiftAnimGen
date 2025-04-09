import XCTest

@testable import SwiftAnimGen

class AnimationsFileTests: XCTestCase {
    func testLoadData() throws {
        let data = makeDummyJsonData()

        let file = try JSONDecoder().decode(AnimationsFile.self, from: data)

        XCTAssertEqual(file.options.animationNameKind, .constant)
        XCTAssertEqual(file.constants.stateMachine.count, 7)
        XCTAssertEqual(file.constants.animationNames.count, 18)

        XCTAssertEqual(file.states[0].transitions?[0].conditions, .constants([.init(isNegated: false, entry: "SM_WALKING")]))
    }
}
