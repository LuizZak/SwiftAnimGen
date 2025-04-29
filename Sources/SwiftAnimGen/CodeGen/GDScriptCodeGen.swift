class GDScriptCodeGen {
    let buffer: CodeStringBuffer
    var stateMachineConstants: [StateMachineConstantEntry] = []
    var animationNamesByState: [String: String] = [:]
    var animationConstants: [String: String] = [:]

    init() {
        buffer = CodeStringBuffer()
    }

    func generate(_ animationsFile: AnimationsFile) -> String {
        buffer.resetState()

        _populateStateMachineConstants(animationsFile)
        _populateAnimationConstants(animationsFile)
        _populateAnimationNamesByState(animationsFile)

        emitAnimationsFile(animationsFile)

        return buffer.finishBuffer()
    }

    func _populateStateMachineConstants(_ animationsFile: AnimationsFile) {
        stateMachineConstants = []

        for constant in animationsFile.constants.stateMachine {
            stateMachineConstants.append(
                .init(
                    key: constant.constant.key,
                    value: constant.constant.value,
                    type: constant.type
                )
            )
        }
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

    struct StateMachineConstantEntry {
        var key: String
        var value: String
        var type: String
    }
}

private extension GDScriptCodeGen {
    func emitAnimationsFile(_ animationsFile: AnimationsFile) {
        emitClassHeader(animationsFile)
        emitConstants(animationsFile.constants)
        emitConstantSetters(animationsFile.constants)
        emitEntryPoints(animationsFile)

        buffer.ensureEmptyLine()

        for state in animationsFile.states {
            emitState(state)

            buffer.ensureEmptyLine()
        }
    }

    func emitClassHeader(_ animationsFile: AnimationsFile) {
        buffer.emitLine("class_name \(animationsFile.className)")
        if let superclass = animationsFile.superclass {
            buffer.emitLine("extends \(superclass)")
        } else {
            buffer.emitLine("extends AnimationStateMachine")
        }
    }

    func emitConstants(_ constants: AnimationsFile.Constants) {
        if !constants.stateMachine.isEmpty {
            buffer.ensureEmptyLine()
            buffer.emitLine("#region State Machine Constants")
            buffer.ensureEmptyLine()

            for constant in constants.stateMachine {
                buffer.emitLine("# Type: \(constant.type)")
                buffer.emitLine("const \(constant.constant.key) = \(constant.constant.value.debugDescription)")
            }

            buffer.ensureEmptyLine()
            buffer.emitLine("#endregion")
        }

        if !constants.animationNames.isEmpty {
            buffer.ensureEmptyLine()
            buffer.emitLine("#region Animation Name Constants")
            buffer.ensureEmptyLine()

            for constant in constants.animationNames {
                buffer.emitLine("const \(constant.key) = \(constant.value.debugDescription)")
            }

            buffer.ensureEmptyLine()
            buffer.emitLine("#endregion")
        }
    }

    func emitConstantSetters(_ constants: AnimationsFile.Constants) {
        for constant in constants.stateMachine {
            buffer.ensureEmptyLine()

            let functionName: String
            if let setterName = constant.setterName {
                functionName = setterName
            } else {
                functionName = "set_" + constant.constant.value
            }

            buffer.emitBlock("func \(functionName)(value: \(constant.type))") {
                buffer.emitLine("parameters[\(constant.constant.key)] = value")
            }
        }
    }

    func emitEntryPoints(_ animationsFile: AnimationsFile) {
        guard let entryPoints = animationsFile.entryPoints else {
            return
        }

        buffer.emitLine("#region Entry Points")
        buffer.ensureEmptyLine()

        for entryPoint in entryPoints {
            buffer.ensureEmptyLine()

            let functionName = "transition_" + entryPoint.name.lowercasedFirstLetter
            buffer.emitBlock("func \(functionName)()") {
                buffer.emitLine("transition([], \(entryPoint.name).new(0.0, true))")
            }
        }

        buffer.ensureEmptyLine()
        buffer.emitLine("#endregion")
    }

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
        case .expression(let expr):
            emitConditionalExpression(expr)

        case .constants(let constants):
            let andEmitter = buffer.startConditionalEmitter()

            for constant in constants {
                andEmitter.emit(" and ")

                emitConditionalConstant(constant)
            }
        }
    }

    func emitConditionalExpression(_ expression: ConditionGrammar.Condition) {
        let emitter = ConditionEmitter(buffer: buffer, constants: Set(stateMachineConstants.map(\.key)))
        emitter.unfoldConstants = true
        emitter.emit(expression)
    }

    func emitConditionalConstant(_ constant: AnimationTransition.Conditions.ConstantEntry) {
        if constant.isNegated {
            buffer.emit("!")
        }

        buffer.emit("state_machine.parameters[\(constant.entry)]")
    }

    private class ConditionEmitter {
        private var _contextStack: [ExpressionContext] = []
        var buffer: CodeStringBuffer
        var unfoldConstants: Bool = true
        var constants: Set<String>

        init(constants: Set<String>) {
            self.buffer = CodeStringBuffer()
            self.constants = constants
        }

        init(buffer: CodeStringBuffer, constants: Set<String>) {
            self.buffer = buffer
            self.constants = constants
        }

        func emit(_ condition: ConditionGrammar.Condition) {
            _emit(condition.expression)
        }

        private func _pushContext() {
            _contextStack.append(ExpressionContext())
        }

        private func _setExpressionMode(_ mode: ExpressionContext.Mode) {
            _contextStack.last?.mode = mode
        }

        private func _expressionMode() -> ExpressionContext.Mode {
            _contextStack.last?.mode ?? .unknown
        }

        private func _popContext() {
            _contextStack.removeLast()
        }

        private func _emit(_ exp: ConditionGrammar.Expression) {
            _pushContext()
            defer { _popContext() }

            switch exp {
            case .typeCast(let typeCast):
                _emit(typeCast)
            }
        }

        private func _emit(_ typeCasting: ConditionGrammar.TypeCastingExpression) {
            switch typeCasting {
            case .typeCast(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" as ")
                _emit(rhs)

            case .ternary(let ternary):
                _emit(ternary)
            }
        }

        private func _emit(_ ternary: ConditionGrammar.TernaryExpression) {
            switch ternary {
            case .ternary(let ifTrue, let condition, let ifFalse):
                _emit(ifTrue)
                buffer.emit(" if ")
                _emit(condition)
                buffer.emit(" else ")
                _emit(ifFalse)

            case .booleanOr(let booleanOr):
                _emit(booleanOr)
            }
        }

        private func _emit(_ booleanOr: ConditionGrammar.BooleanOrExpression) {
            switch booleanOr {
            case .or(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" or ")
                _emit(rhs)

            case .booleanAnd(let booleanAnd):
                _emit(booleanAnd)
            }
        }

        private func _emit(_ booleanAnd: ConditionGrammar.BooleanAndExpression) {
            switch booleanAnd {
            case .and(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" and ")
                _emit(rhs)

            case .booleanNot(let booleanNot):
                _emit(booleanNot)
            }
        }

        private func _emit(_ booleanNot: ConditionGrammar.BooleanNotExpression) {
            switch booleanNot {
            case .not(let value):
                buffer.emit("not ")
                _emit(value)

            case .inclusionCheck(let inclusionCheck):
                _emit(inclusionCheck)
            }
        }

        private func _emit(_ inclusion: ConditionGrammar.InclusionCheckExpression) {
            switch inclusion {
            case .in(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" in ")
                _emit(rhs)

            case .notIn(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" not in ")
                _emit(rhs)

            case .comparison(let comparison):
                _emit(comparison)
            }
        }

        private func _emit(_ comparison: ConditionGrammar.ComparisonExpression) {
            switch comparison {
            case .equals(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" == ")
                _emit(rhs)

            case .notEquals(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" != ")
                _emit(rhs)

            case .lessThan(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" < ")
                _emit(rhs)

            case .greaterThan(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" > ")
                _emit(rhs)

            case .lessThanOrEqual(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" <= ")
                _emit(rhs)

            case .greaterThanOrEqual(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" >= ")
                _emit(rhs)

            case .bitwiseOr(let bitwiseOr):
                _emit(bitwiseOr)
            }
        }

        private func _emit(_ bitwiseOr: ConditionGrammar.BitwiseOrExpression) {
            switch bitwiseOr {
            case .or(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" | ")
                _emit(rhs)

            case .bitwiseXor(let bitwiseXor):
                _emit(bitwiseXor)
            }
        }

        private func _emit(_ bitwiseXor: ConditionGrammar.BitwiseXorExpression) {
            switch bitwiseXor {
            case .xor(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" ^ ")
                _emit(rhs)

            case .bitwiseAnd(let bitwiseAnd):
                _emit(bitwiseAnd)
            }
        }

        private func _emit(_ bitwiseAnd: ConditionGrammar.BitwiseAndExpression) {
            switch bitwiseAnd {
            case .and(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" & ")
                _emit(rhs)

            case .bitShift(let bitShift):
                _emit(bitShift)
            }
        }

        private func _emit(_ bitShift: ConditionGrammar.BitShiftExpression) {
            switch bitShift {
            case .leftShift(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" << ")
                _emit(rhs)

            case .rightShift(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" >> ")
                _emit(rhs)

            case .addition(let addition):
                _emit(addition)
            }
        }

        private func _emit(_ addition: ConditionGrammar.AdditionExpression) {
            switch addition {
            case .add(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" + ")
                _emit(rhs)

            case .subtract(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" - ")
                _emit(rhs)

            case .multiplication(let multiplication):
                _emit(multiplication)
            }
        }

        private func _emit(_ multiplication: ConditionGrammar.MultiplicationExpression) {
            switch multiplication {
            case .multiply(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" * ")
                _emit(rhs)

            case .divide(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" / ")
                _emit(rhs)

            case .modulus(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" % ")
                _emit(rhs)

            case .identity(let identity):
                _emit(identity)
            }
        }

        private func _emit(_ identity: ConditionGrammar.IdentityExpression) {
            switch identity {
            case .identity(let value):
                buffer.emit("+")
                _emit(value)

            case .negation(let value):
                buffer.emit("-")
                _emit(value)

            case .bitwiseNot(let bitwiseNot):
                _emit(bitwiseNot)
            }
        }

        private func _emit(_ bitwiseNot: ConditionGrammar.BitwiseNotExpression) {
            switch bitwiseNot {
            case .bitwiseNot(let value):
                buffer.emit("~")
                _emit(value)

            case .power(let power):
                _emit(power)
            }
        }

        private func _emit(_ power: ConditionGrammar.PowerExpression) {
            switch power {
            case .power(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" ** ")
                _emit(rhs)

            case .typeCheck(let typeCheck):
                _emit(typeCheck)
            }
        }

        private func _emit(_ typeCheck: ConditionGrammar.TypeCheckExpression) {
            switch typeCheck {
            case .isType(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" is ")
                _emit(rhs)

            case .isNotType(let lhs, let rhs):
                _emit(lhs)
                buffer.emit(" is not ")
                _emit(rhs)

            case .await(let `await`):
                _emit(`await`)
            }
        }

        private func _emit(_ await: ConditionGrammar.AwaitExpression) {
            switch `await` {
            case .await(let `await`):
                buffer.emit("await ")
                _emit(`await`)

            case .postfix(let postfix):
                _emit(postfix)
            }
        }

        private func _emit(_ postfix: ConditionGrammar.PostfixExpression) {
            switch postfix {
            case .attribute(let base, let attribute):
                _setExpressionMode(.compound)
                _emit(base)

                buffer.emit(".")
                buffer.emit(attribute)

            case .functionCall(let base, let parameters):
                _setExpressionMode(.compound)
                _emit(base)

                buffer.emit("(")
                let comma = buffer.startConditionalEmitter()
                for param in parameters {
                    comma.emit(", ")

                    _emit(param)
                }
                buffer.emit(")")

            case .subscription(let base, let index):
                _setExpressionMode(.compound)
                _emit(base)
                buffer.emit("[")
                _emit(index)
                buffer.emit("]")

            case .grouping(let grouping):
                _emit(grouping)
            }
        }

        private func _emit(_ grouping: ConditionGrammar.GroupingExpression) {
            switch grouping {
            case .grouping(let expression):
                buffer.emit("(")
                _emit(expression)
                buffer.emit(")")

            case .atom(let atom):
                _emit(atom)
            }
        }

        private func _emit(_ atom: ConditionGrammar.AtomExpression) {
            switch atom {
            case .parens(let exp):
                buffer.emit("(")
                _emit(exp)
                buffer.emit(")")

            case .identifier(let ident):
                if unfoldConstants && _expressionMode() != .compound && constants.contains(ident) {
                    buffer.emit("state_machine.parameters[")
                    buffer.emit(ident)
                    buffer.emit("]")
                } else {
                    buffer.emit(ident)
                }

            case .literal(let literal):
                _emit(literal)
            }
        }

        private func _emit(_ literal: ConditionGrammar.Literal) {
            switch literal {
            case .string(let value):
                buffer.emit(value.debugDescription)

            case .integer(let value):
                buffer.emit(value.description)

            case .float(let value):
                buffer.emit(value.description)
            }
        }

        private class ExpressionContext {
            var mode: Mode = .unknown

            enum Mode {
                case unknown
                case bareIdentifier
                case compound
            }
        }
    }
}
