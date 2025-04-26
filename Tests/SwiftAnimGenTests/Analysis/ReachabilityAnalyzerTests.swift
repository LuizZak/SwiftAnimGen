import Testing

@testable import SwiftAnimGen

struct ReachabilityAnalyzerTests {
    @Test
    func diagnose_emptyFile() {
        let file = AnimationsFile(options: .init(animationNameKind: .constant), constants: .init(stateMachine: [], animationNames: []), states: [])
        let sut = makeSut()
        sut.populate(file)

        let result = sut.diagnose()

        #expect(result.isEmpty)
    }

    @Test
    func diagnose_unreachable_withCycle() {
        let file = AnimationsFile(
            options: .init(animationNameKind: .constant),
            constants: .init(stateMachine: [], animationNames: []),
            states: [
                .init(name: "state0", animationName: "anim0", transitions: [
                    .init(state: "state1")
                ]),
                .init(name: "state1", animationName: "anim1", transitions: [
                    .init(state: "state0")
                ]),
            ]
        )
        let sut = makeSut()
        sut.populate(file)

        let result = sut.diagnose()

        #expect(Set(result) == [.unreachableState(stateName: "state0"), .unreachableState(stateName: "state1")])
    }

    @Test
    func diagnose_unreachable() {
        let file = AnimationsFile(
            options: .init(animationNameKind: .constant),
            constants: .init(stateMachine: [], animationNames: []),
            states: [
                .init(name: "state0", animationName: "anim0"),
            ]
        )
        let sut = makeSut()
        sut.populate(file)

        let result = sut.diagnose()

        #expect(result == [.unreachableState(stateName: "state0")])
    }

    @Test
    func diagnose_reachableByEntryPoint() {
        let file = AnimationsFile(
            options: .init(animationNameKind: .constant),
            constants: .init(stateMachine: [], animationNames: []),
            entryPoints: [
                .init(name: "state0")
            ],
            states: [
                .init(name: "state0", animationName: "anim0"),
            ]
        )
        let sut = makeSut()
        sut.populate(file)

        let result = sut.diagnose()

        #expect(result.isEmpty)
    }
}

// MARK: - Test internals

private func makeSut() -> ReachabilityAnalyzer {
    return ReachabilityAnalyzer()
}
