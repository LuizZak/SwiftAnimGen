import Testing
import Foundation

@testable import SwiftAnimGen

struct AnimationsFileTests {
    @Test
    func loadData() throws {
        let data = makeDummyJsonData()

        let file = try JSONDecoder().decode(AnimationsFile.self, from: data)

        #expect(file.options.animationNameKind == .constant)
        #expect(file.constants.stateMachine.count == 3)
        #expect(file.constants.animationNames.count == 4)

        #expect(try file.states[0].transitions?[0].conditions == .expression(parseCondition("SM_WALKING")))
    }
}
