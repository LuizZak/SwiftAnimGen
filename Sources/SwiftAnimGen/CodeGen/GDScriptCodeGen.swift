class GDScriptCodeGen {
    let buffer: CodeStringBuffer
    var animationNamesByState: [String: String] = [:]
    var animationConstants: [String: String] = [:]

    init() {
        buffer = CodeStringBuffer()
    }

    func generate(_ animationsFile: AnimationsFile) -> String {
        buffer.resetState()

        _populateAnimationConstants(animationsFile)
        _populateAnimationNamesByState(animationsFile)

        for state in animationsFile.states {
            emitState(state)

            buffer.ensureEmptyLine()
        }

        return buffer.finishBuffer()
    }

    func _populateAnimationConstants(_ animationsFile: AnimationsFile) {
        animationConstants = [:]

        for animationConstant in animationsFile.constants.animationNames {
            animationConstants[animationConstant.key] = animationConstant.value
        }
    }

    func _populateAnimationNamesByState(_ animationsFile: AnimationsFile) {
        animationNamesByState = [:]

        for state in animationsFile.states {
            animationNamesByState[state.name] = state.animationName
        }
    }
}

private extension GDScriptCodeGen {
    func emitState(_ state: AnimationState) {
        var commentHeader: String = ""

        if let description = state.description {
            commentHeader += description + "\n"
        }

        if let animName = animationNamesByState[state.name], let constantValue = animationConstants[animName] {
            commentHeader += """
            Handles:
            \(constantValue)
            """
        }

        if !commentHeader.isEmpty {
            buffer.emitCommentBlock(commentHeader)
        }

        buffer.emit("class \(state.name) extends AnimationState")
        buffer.emitBlock {
            emitGetAnimationName(state)

            if let transitions = state.transitions {
                emitApplyTransitions(state, transitions: transitions)
            }
            if let onEnd = state.onEnd {
                emitOnAnimationFinished(state, transitions: onEnd)
            }
        }
    }

    func emitGetAnimationName(_ state: AnimationState) {
        buffer.emitBlock("func get_animation_name() -> String") {
            buffer.emitLine("return \(state.animationName)")
        }
    }

    func emitApplyTransitions(_ state: AnimationState, transitions: [AnimationTransition]) {
        buffer.emitBlock("func apply_transitions(stack, state_machine)") {
            buffer.emitBlock("if !push_and_check(stack, \(state.name), state_machine)") {
                buffer.emitLine("return")
            }
            buffer.ensureEmptyLine()

            buffer.emitLine("var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer")
            buffer.ensureEmptyLine()

            for transition in transitions {
                if let animName = animationNamesByState[transition.state] {
                    if let constantValue = animationConstants[animName] {
                        buffer.emitComment("-> \(constantValue)")
                    } else {
                        buffer.emitComment("-> \(animName)")
                    }
                }

                if let conditions = transition.conditions {
                    buffer.emit("if ")
                    emitTransitionConditions(conditions)
                    buffer.emitBlock {
                        emitTransition(transition, stackParam: "stack")
                    }
                } else {
                    emitTransition(transition, stackParam: "stack")
                }
            }
        }
    }

    func emitOnAnimationFinished(_ state: AnimationState, transitions: [AnimationTransition]) {
        buffer.emitBlock("func on_animation_finished(animation_name, state_machine)") {
            buffer.emitLine("var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer")
            buffer.ensureEmptyLine()

            for transition in transitions {
                if let animName = animationNamesByState[transition.state] {
                    if let constantValue = animationConstants[animName] {
                        buffer.emitComment("-> \(constantValue)")
                    } else {
                        buffer.emitComment("-> \(animName)")
                    }
                }

                if let conditions = transition.conditions {
                    buffer.emit("if ")
                    emitTransitionConditions(conditions)
                    buffer.emitBlock {
                        emitTransition(transition, stackParam: "[]")
                    }
                } else {
                    emitTransition(transition, stackParam: "[]")
                }
            }
        }
    }

    func emitTransition(_ transition: AnimationTransition, stackParam: String) {
        buffer.emitLine("state_machine.transition(")
        buffer.indented {
            buffer.emitLine("\(stackParam),")
            emitTransitionInitializer(transition)
            buffer.emitNewline()
        }
        buffer.emitLine(")")
        buffer.emitLine("return")
    }

    func emitTransitionInitializer(_ transition: AnimationTransition) {
        buffer.emit(transition.state)

        if let initializer = transition.options?.initializer {
            buffer.emit(initializer)
        } else {
            buffer.emit(".new()")
        }
    }

    func emitTransitionConditions(_ conditions: AnimationTransition.Conditions) {
        switch conditions {
        case .constants(let constants):
            let andEmitter = buffer.startConditionalEmitter()

            for constant in constants {
                andEmitter.emit(" and ")

                emitConditionalConstant(constant)
            }
        }
    }

    func emitConditionalConstant(_ constant: AnimationTransition.Conditions.ConstantEntry) {
        if constant.isNegated {
            buffer.emit("!")
        }

        buffer.emit("state_machine.parameters[\(constant.entry)]")
    }
}
