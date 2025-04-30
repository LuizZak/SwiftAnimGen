import Foundation

@testable import SwiftAnimGen

func parseCondition(_ condition: String) throws -> ConditionGrammar.Condition {
    let tokenizer = ConditionParserRawTokenizer(source: condition)
    let parser = ConditionParser(raw: tokenizer)

    guard let condition = try parser.start(), try parser.isEOF() else {
        throw parser.makeSyntaxError()
    }

    return condition
}

func makeDummyAnimationsFile() -> AnimationsFile {
    let data = makeDummyJsonData()
    return try! JSONDecoder().decode(AnimationsFile.self, from: data)
}

func makeDummyJsonData() -> Data {
    return makeDummyJson().data(using: .utf8)!
}

func makeDummyJson() -> String {
    return #"""
    {
        "class_name": "ExampleAnimationStateMachine",
        "options": {
            "animation_name_kind": "constant"
        },
        "constants": {
            "state_machine": [
                { "constant": { "SM_CROUCHING": "crouching" }, "type": "bool" },
                { "constant": { "SM_WALKING": "walking" }, "type": "bool" },
                { "constant": { "SM_ON_AIR": "on_air" }, "type": "bool" }
            ],
            "animation_names": [
                { "ANIM_IDLE": "idle" },
                { "ANIM_CROUCH": "crouch" },
                { "ANIM_RUN": "run" },
                { "ANIM_JUMP": "jump" }
            ]
        },
        "entry_points": [
            { "name": "IdleState" },
            { "name": "CrouchState" },
            { "name": "RunState" },
            { "name": "JumpState" }
        ],
        "states": [
            {
                "name": "IdleState",
                "description": "Idle, not running",
                "animation_name": "ANIM_IDLE",
                "transitions": [
                    { "state": "RunState", "conditions": "SM_WALKING" },
                    { "state": "CrouchState", "conditions": "SM_CROUCHING" }
                ]
            },
            {
                "name": "CrouchState",
                "description": "Crouching, not running",
                "animation_name": "ANIM_CROUCH",
                "transitions": [
                    { "state": "IdleState", "conditions": "not SM_CROUCHING" }
                ]
            },
            {
                "name": "RunState",
                "description": "Run state",
                "animation_name": "ANIM_RUN",
                "transitions": [
                    { "state": "IdleState", "conditions": "not SM_WALKING" }
                ]
            },
            {
                "name": "JumpState",
                "description": "On air",
                "animation_name": "ANIM_JUMP",
                "transitions": [
                    { "state": "IdleState", "conditions": "not SM_ON_AIR" }
                ],
                "on_end": [
                    { "state": "IdleState" }
                ]
            }
        ]
    }
    """#
}
