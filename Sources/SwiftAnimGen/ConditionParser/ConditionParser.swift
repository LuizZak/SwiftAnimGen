// HEADS UP! This is a generated file
import SwiftPEG

/// A parser for conditions in animation transitions.

public class ConditionParser<RawTokenizer: RawTokenizerType>: PEGParser<RawTokenizer> where RawTokenizer.RawToken == ConditionParserToken, RawTokenizer.Location == FileSourceLocation {
    public override func skipChannelSkipTokens(_ except: Set<RawToken.TokenKind>) throws -> Void {
        repeat {
            let next: Token? = try tokenizer.peekToken()

            guard
                let kind = next?.rawToken.kind,
                kind == .whitespace
            else {
                break
            }

            if except.contains(kind) {
                break
            }

            try tokenizer.skip()
        } while !tokenizer.isEOF
    }

    /// ```
    /// start[ConditionGrammar.Condition]:
    ///     | condition
    ///     ;
    /// ```
    @memoized("start")
    @inlinable
    public func __start() throws -> ConditionGrammar.Condition? {
        let _mark: Mark = self.mark()

        if let condition = try self.condition() {
            return condition
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// condition[ConditionGrammar.Condition]:
    ///     | expression { .init(expression: expression) }
    ///     ;
    /// ```
    @memoized("condition")
    @inlinable
    public func __condition() throws -> ConditionGrammar.Condition? {
        let _mark: Mark = self.mark()

        if let expression = try self.expression() {
            return .init(expression: expression)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// expression[ConditionGrammar.Expression]:
    ///     | typeCast { .typeCast(typeCast) }
    ///     ;
    /// ```
    @memoized("expression")
    @inlinable
    public func __expression() throws -> ConditionGrammar.Expression? {
        let _mark: Mark = self.mark()

        if let typeCast = try self.typeCast() {
            return .typeCast(typeCast)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// expressionList[[ConditionGrammar.Expression]]:
    ///     | ','.expression+ { expression }
    ///     ;
    /// ```
    @memoized("expressionList")
    @inlinable
    public func __expressionList() throws -> [ConditionGrammar.Expression]? {
        let _mark: Mark = self.mark()

        if
            let expression = try self.gather(separator: {
                try self.expect(kind: .comma)
            }, item: {
                try self.expression()
            })
        {
            return expression
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// typeCast[ConditionGrammar.TypeCastingExpression]:
    ///     | typeCast 'as' ternary { .typeCast(typeCast, ternary) }
    ///     | ternary { .ternary(ternary) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("typeCast")
    @inlinable
    public func __typeCast() throws -> ConditionGrammar.TypeCastingExpression? {
        let _mark: Mark = self.mark()

        if
            let typeCast = try self.typeCast(),
            let _ = try self.expect(kind: .as),
            let ternary = try self.ternary()
        {
            return .typeCast(typeCast, ternary)
        }

        self.restore(_mark)

        if let ternary = try self.ternary() {
            return .ternary(ternary)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// ternary[ConditionGrammar.TernaryExpression]:
    ///     | booleanOr 'if' expression 'else' ternary { .ternary(trueExpr: booleanOr, condition: expression, falseExpr: ternary) }
    ///     | booleanOr { .booleanOr(booleanOr) }
    ///     ;
    /// ```
    @memoized("ternary")
    @inlinable
    public func __ternary() throws -> ConditionGrammar.TernaryExpression? {
        let _mark: Mark = self.mark()

        if
            let booleanOr = try self.booleanOr(),
            let _ = try self.expect(kind: .if),
            let expression = try self.expression(),
            let _ = try self.expect(kind: .else),
            let ternary = try self.ternary()
        {
            return .ternary(trueExpr: booleanOr, condition: expression, falseExpr: ternary)
        }

        self.restore(_mark)

        if let booleanOr = try self.booleanOr() {
            return .booleanOr(booleanOr)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// booleanOr[ConditionGrammar.BooleanOrExpression]:
    ///     | booleanOr _=or booleanAnd { .or(booleanOr, booleanAnd) }
    ///     | booleanAnd { .booleanAnd(booleanAnd) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("booleanOr")
    @inlinable
    public func __booleanOr() throws -> ConditionGrammar.BooleanOrExpression? {
        let _mark: Mark = self.mark()

        if
            let booleanOr = try self.booleanOr(),
            let _ = try self.or(),
            let booleanAnd = try self.booleanAnd()
        {
            return .or(booleanOr, booleanAnd)
        }

        self.restore(_mark)

        if let booleanAnd = try self.booleanAnd() {
            return .booleanAnd(booleanAnd)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// booleanAnd[ConditionGrammar.BooleanAndExpression]:
    ///     | booleanAnd _=and booleanNot { .and(booleanAnd, booleanNot) }
    ///     | booleanNot { .booleanNot(booleanNot) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("booleanAnd")
    @inlinable
    public func __booleanAnd() throws -> ConditionGrammar.BooleanAndExpression? {
        let _mark: Mark = self.mark()

        if
            let booleanAnd = try self.booleanAnd(),
            let _ = try self.and(),
            let booleanNot = try self.booleanNot()
        {
            return .and(booleanAnd, booleanNot)
        }

        self.restore(_mark)

        if let booleanNot = try self.booleanNot() {
            return .booleanNot(booleanNot)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// booleanNot[ConditionGrammar.BooleanNotExpression]:
    ///     | _=not booleanNot { .not(booleanNot) }
    ///     | inclusionCheck { .inclusionCheck(inclusionCheck) }
    ///     ;
    /// ```
    @memoized("booleanNot")
    @inlinable
    public func __booleanNot() throws -> ConditionGrammar.BooleanNotExpression? {
        let _mark: Mark = self.mark()

        if
            let _ = try self.not(),
            let booleanNot = try self.booleanNot()
        {
            return .not(booleanNot)
        }

        self.restore(_mark)

        if let inclusionCheck = try self.inclusionCheck() {
            return .inclusionCheck(inclusionCheck)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// inclusionCheck[ConditionGrammar.InclusionCheckExpression]:
    ///     | inclusionCheck 'in' comparison { .in(inclusionCheck, comparison) }
    ///     | inclusionCheck 'not' 'in' comparison { .notIn(inclusionCheck, comparison) }
    ///     | comparison { .comparison(comparison) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("inclusionCheck")
    @inlinable
    public func __inclusionCheck() throws -> ConditionGrammar.InclusionCheckExpression? {
        let _mark: Mark = self.mark()

        if
            let inclusionCheck = try self.inclusionCheck(),
            let _ = try self.expect(kind: .in),
            let comparison = try self.comparison()
        {
            return .in(inclusionCheck, comparison)
        }

        self.restore(_mark)

        if
            let inclusionCheck = try self.inclusionCheck(),
            let _ = try self.expect(kind: .not),
            let _ = try self.expect(kind: .in),
            let comparison = try self.comparison()
        {
            return .notIn(inclusionCheck, comparison)
        }

        self.restore(_mark)

        if let comparison = try self.comparison() {
            return .comparison(comparison)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// comparison[ConditionGrammar.ComparisonExpression]:
    ///     | comparison '==' bitwiseOr { .equals(comparison, bitwiseOr) }
    ///     | comparison '!=' bitwiseOr { .notEquals(comparison, bitwiseOr) }
    ///     | comparison '<' bitwiseOr { .lessThan(comparison, bitwiseOr) }
    ///     | comparison '>' bitwiseOr { .greaterThan(comparison, bitwiseOr) }
    ///     | comparison '<=' bitwiseOr { .lessThanOrEqual(comparison, bitwiseOr) }
    ///     | comparison '>=' bitwiseOr { .greaterThanOrEqual(comparison, bitwiseOr) }
    ///     | bitwiseOr { .bitwiseOr(bitwiseOr) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("comparison")
    @inlinable
    public func __comparison() throws -> ConditionGrammar.ComparisonExpression? {
        let _mark: Mark = self.mark()

        if
            let comparison = try self.comparison(),
            let _ = try self.expect(kind: .equals),
            let bitwiseOr = try self.bitwiseOr()
        {
            return .equals(comparison, bitwiseOr)
        }

        self.restore(_mark)

        if
            let comparison = try self.comparison(),
            let _ = try self.expect(kind: .notEquals),
            let bitwiseOr = try self.bitwiseOr()
        {
            return .notEquals(comparison, bitwiseOr)
        }

        self.restore(_mark)

        if
            let comparison = try self.comparison(),
            let _ = try self.expect(kind: .leftAngle),
            let bitwiseOr = try self.bitwiseOr()
        {
            return .lessThan(comparison, bitwiseOr)
        }

        self.restore(_mark)

        if
            let comparison = try self.comparison(),
            let _ = try self.expect(kind: .rightAngle),
            let bitwiseOr = try self.bitwiseOr()
        {
            return .greaterThan(comparison, bitwiseOr)
        }

        self.restore(_mark)

        if
            let comparison = try self.comparison(),
            let _ = try self.expect(kind: .lessOrEquals),
            let bitwiseOr = try self.bitwiseOr()
        {
            return .lessThanOrEqual(comparison, bitwiseOr)
        }

        self.restore(_mark)

        if
            let comparison = try self.comparison(),
            let _ = try self.expect(kind: .greaterOrEquals),
            let bitwiseOr = try self.bitwiseOr()
        {
            return .greaterThanOrEqual(comparison, bitwiseOr)
        }

        self.restore(_mark)

        if let bitwiseOr = try self.bitwiseOr() {
            return .bitwiseOr(bitwiseOr)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// bitwiseOr[ConditionGrammar.BitwiseOrExpression]:
    ///     | bitwiseOr '|' bitwiseXor { .or(bitwiseOr, bitwiseXor) }
    ///     | bitwiseXor { .bitwiseXor(bitwiseXor) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("bitwiseOr")
    @inlinable
    public func __bitwiseOr() throws -> ConditionGrammar.BitwiseOrExpression? {
        let _mark: Mark = self.mark()

        if
            let bitwiseOr = try self.bitwiseOr(),
            let _ = try self.expect(kind: .bitwiseOr),
            let bitwiseXor = try self.bitwiseXor()
        {
            return .or(bitwiseOr, bitwiseXor)
        }

        self.restore(_mark)

        if let bitwiseXor = try self.bitwiseXor() {
            return .bitwiseXor(bitwiseXor)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// bitwiseXor[ConditionGrammar.BitwiseXorExpression]:
    ///     | bitwiseXor '^' bitwiseAnd { .xor(bitwiseXor, bitwiseAnd) }
    ///     | bitwiseAnd { .bitwiseAnd(bitwiseAnd) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("bitwiseXor")
    @inlinable
    public func __bitwiseXor() throws -> ConditionGrammar.BitwiseXorExpression? {
        let _mark: Mark = self.mark()

        if
            let bitwiseXor = try self.bitwiseXor(),
            let _ = try self.expect(kind: .bitwiseXor),
            let bitwiseAnd = try self.bitwiseAnd()
        {
            return .xor(bitwiseXor, bitwiseAnd)
        }

        self.restore(_mark)

        if let bitwiseAnd = try self.bitwiseAnd() {
            return .bitwiseAnd(bitwiseAnd)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// bitwiseAnd[ConditionGrammar.BitwiseAndExpression]:
    ///     | bitwiseAnd '&' bitShift { .and(bitwiseAnd, bitShift) }
    ///     | bitShift { .bitShift(bitShift) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("bitwiseAnd")
    @inlinable
    public func __bitwiseAnd() throws -> ConditionGrammar.BitwiseAndExpression? {
        let _mark: Mark = self.mark()

        if
            let bitwiseAnd = try self.bitwiseAnd(),
            let _ = try self.expect(kind: .bitwiseAnd),
            let bitShift = try self.bitShift()
        {
            return .and(bitwiseAnd, bitShift)
        }

        self.restore(_mark)

        if let bitShift = try self.bitShift() {
            return .bitShift(bitShift)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// bitShift[ConditionGrammar.BitShiftExpression]:
    ///     | bitShift '<<' addition { .leftShift(bitShift, addition) }
    ///     | bitShift '>>' addition { .rightShift(bitShift, addition) }
    ///     | addition { .addition(addition) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("bitShift")
    @inlinable
    public func __bitShift() throws -> ConditionGrammar.BitShiftExpression? {
        let _mark: Mark = self.mark()

        if
            let bitShift = try self.bitShift(),
            let _ = try self.expect(kind: .leftShift),
            let addition = try self.addition()
        {
            return .leftShift(bitShift, addition)
        }

        self.restore(_mark)

        if
            let bitShift = try self.bitShift(),
            let _ = try self.expect(kind: .rightShift),
            let addition = try self.addition()
        {
            return .rightShift(bitShift, addition)
        }

        self.restore(_mark)

        if let addition = try self.addition() {
            return .addition(addition)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// addition[ConditionGrammar.AdditionExpression]:
    ///     | addition '+' multiplication { .add(addition, multiplication) }
    ///     | addition '-' multiplication { .subtract(addition, multiplication) }
    ///     | multiplication { .multiplication(multiplication) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("addition")
    @inlinable
    public func __addition() throws -> ConditionGrammar.AdditionExpression? {
        let _mark: Mark = self.mark()

        if
            let addition = try self.addition(),
            let _ = try self.expect(kind: .plus),
            let multiplication = try self.multiplication()
        {
            return .add(addition, multiplication)
        }

        self.restore(_mark)

        if
            let addition = try self.addition(),
            let _ = try self.expect(kind: .minus),
            let multiplication = try self.multiplication()
        {
            return .subtract(addition, multiplication)
        }

        self.restore(_mark)

        if let multiplication = try self.multiplication() {
            return .multiplication(multiplication)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// multiplication[ConditionGrammar.MultiplicationExpression]:
    ///     | multiplication '*' identity { .multiply(multiplication, identity) }
    ///     | multiplication '/' identity { .divide(multiplication, identity) }
    ///     | multiplication '%' identity { .modulus(multiplication, identity) }
    ///     | identity { .identity(identity) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("multiplication")
    @inlinable
    public func __multiplication() throws -> ConditionGrammar.MultiplicationExpression? {
        let _mark: Mark = self.mark()

        if
            let multiplication = try self.multiplication(),
            let _ = try self.expect(kind: .star),
            let identity = try self.identity()
        {
            return .multiply(multiplication, identity)
        }

        self.restore(_mark)

        if
            let multiplication = try self.multiplication(),
            let _ = try self.expect(kind: .divide),
            let identity = try self.identity()
        {
            return .divide(multiplication, identity)
        }

        self.restore(_mark)

        if
            let multiplication = try self.multiplication(),
            let _ = try self.expect(kind: .modulus),
            let identity = try self.identity()
        {
            return .modulus(multiplication, identity)
        }

        self.restore(_mark)

        if let identity = try self.identity() {
            return .identity(identity)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// identity[ConditionGrammar.IdentityExpression]:
    ///     | '+' identity { .identity(identity) }
    ///     | '-' identity { .negation(identity) }
    ///     | bitwiseNot { .bitwiseNot(bitwiseNot) }
    ///     ;
    /// ```
    @memoized("identity")
    @inlinable
    public func __identity() throws -> ConditionGrammar.IdentityExpression? {
        let _mark: Mark = self.mark()

        if
            let _ = try self.expect(kind: .plus),
            let identity = try self.identity()
        {
            return .identity(identity)
        }

        self.restore(_mark)

        if
            let _ = try self.expect(kind: .minus),
            let identity = try self.identity()
        {
            return .negation(identity)
        }

        self.restore(_mark)

        if let bitwiseNot = try self.bitwiseNot() {
            return .bitwiseNot(bitwiseNot)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// bitwiseNot[ConditionGrammar.BitwiseNotExpression]:
    ///     | '~' bitwiseNot { .bitwiseNot(bitwiseNot) }
    ///     | power { .power(power) }
    ///     ;
    /// ```
    @memoized("bitwiseNot")
    @inlinable
    public func __bitwiseNot() throws -> ConditionGrammar.BitwiseNotExpression? {
        let _mark: Mark = self.mark()

        if
            let _ = try self.expect(kind: .tilde),
            let bitwiseNot = try self.bitwiseNot()
        {
            return .bitwiseNot(bitwiseNot)
        }

        self.restore(_mark)

        if let power = try self.power() {
            return .power(power)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// power[ConditionGrammar.PowerExpression]:
    ///     | power '**' typeCheck { .power(power, typeCheck) }
    ///     | typeCheck { .typeCheck(typeCheck) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("power")
    @inlinable
    public func __power() throws -> ConditionGrammar.PowerExpression? {
        let _mark: Mark = self.mark()

        if
            let power = try self.power(),
            let _ = try self.expect(kind: .doubleStar),
            let typeCheck = try self.typeCheck()
        {
            return .power(power, typeCheck)
        }

        self.restore(_mark)

        if let typeCheck = try self.typeCheck() {
            return .typeCheck(typeCheck)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// typeCheck[ConditionGrammar.TypeCheckExpression]:
    ///     | lhs=typeCheck 'is' rhs=await { .isType(lhs, rhs) }
    ///     | lhs=typeCheck 'is' 'not' rhs=await { .isNotType(lhs, rhs) }
    ///     | await_=await { .await(await_) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("typeCheck")
    @inlinable
    public func __typeCheck() throws -> ConditionGrammar.TypeCheckExpression? {
        let _mark: Mark = self.mark()

        if
            let lhs = try self.typeCheck(),
            let _ = try self.expect(kind: .is),
            let rhs = try self.await()
        {
            return .isType(lhs, rhs)
        }

        self.restore(_mark)

        if
            let lhs = try self.typeCheck(),
            let _ = try self.expect(kind: .is),
            let _ = try self.expect(kind: .not),
            let rhs = try self.await()
        {
            return .isNotType(lhs, rhs)
        }

        self.restore(_mark)

        if let await_ = try self.await() {
            return .await(await_)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// await[ConditionGrammar.AwaitExpression]:
    ///     | 'await' await_=await { .await(await_) }
    ///     | postfix { .postfix(postfix) }
    ///     ;
    /// ```
    @memoized("await")
    @inlinable
    public func __await() throws -> ConditionGrammar.AwaitExpression? {
        let _mark: Mark = self.mark()

        if
            let _ = try self.expect(kind: .await),
            let await_ = try self.await()
        {
            return .await(await_)
        }

        self.restore(_mark)

        if let postfix = try self.postfix() {
            return .postfix(postfix)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// postfix[ConditionGrammar.PostfixExpression]:
    ///     | postfix '.' IDENTIFIER { .attribute(postfix, "\(identifier)") }
    ///     | postfix '(' expressionList? ')' { .functionCall(postfix, expressionList ?? []) }
    ///     | postfix '[' expression ']' { .subscription(postfix, expression) }
    ///     | grouping { .grouping(grouping) }
    ///     ;
    /// ```
    @memoizedLeftRecursive("postfix")
    @inlinable
    public func __postfix() throws -> ConditionGrammar.PostfixExpression? {
        let _mark: Mark = self.mark()

        if
            let postfix = try self.postfix(),
            let _ = try self.expect(kind: .period),
            let identifier = try self.expect(kind: .identifier)
        {
            return .attribute(postfix, "\(identifier)")
        }

        self.restore(_mark)

        if
            let postfix = try self.postfix(),
            let _ = try self.expect(kind: .leftParen),
            case let expressionList = try self.expressionList(),
            let _ = try self.expect(kind: .rightParen)
        {
            return .functionCall(postfix, expressionList ?? [])
        }

        self.restore(_mark)

        if
            let postfix = try self.postfix(),
            let _ = try self.expect(kind: .leftSquare),
            let expression = try self.expression(),
            let _ = try self.expect(kind: .rightSquare)
        {
            return .subscription(postfix, expression)
        }

        self.restore(_mark)

        if let grouping = try self.grouping() {
            return .grouping(grouping)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// grouping[ConditionGrammar.GroupingExpression]:
    ///     | '(' expression ')' { .grouping(expression) }
    ///     | atom { .atom(atom) }
    ///     ;
    /// ```
    @memoized("grouping")
    @inlinable
    public func __grouping() throws -> ConditionGrammar.GroupingExpression? {
        let _mark: Mark = self.mark()

        if
            let _ = try self.expect(kind: .leftParen),
            let expression = try self.expression(),
            let _ = try self.expect(kind: .rightParen)
        {
            return .grouping(expression)
        }

        self.restore(_mark)

        if let atom = try self.atom() {
            return .atom(atom)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// atom[ConditionGrammar.AtomExpression]:
    ///     | '(' expression ')' { .parens(expression) }
    ///     | IDENTIFIER { .identifier("\(identifier)") }
    ///     | literal { .literal(literal) }
    ///     ;
    /// ```
    @memoized("atom")
    @inlinable
    public func __atom() throws -> ConditionGrammar.AtomExpression? {
        let _mark: Mark = self.mark()

        if
            let _ = try self.expect(kind: .leftParen),
            let expression = try self.expression(),
            let _ = try self.expect(kind: .rightParen)
        {
            return .parens(expression)
        }

        self.restore(_mark)

        if let identifier = try self.expect(kind: .identifier) {
            return .identifier("\(identifier)")
        }

        self.restore(_mark)

        if let literal = try self.literal() {
            return .literal(literal)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// literal[ConditionGrammar.Literal]:
    ///     | STRING { .string("\(string)") }
    ///     | INTEGER { .integer(Int("\(integer)") ?? 0) }
    ///     | FLOAT { .float(Double("\(float)") ?? 0.0) }
    ///     ;
    /// ```
    @memoized("literal")
    @inlinable
    public func __literal() throws -> ConditionGrammar.Literal? {
        let _mark: Mark = self.mark()

        if let string = try self.expect(kind: .string) {
            return .string("\(string)")
        }

        self.restore(_mark)

        if let integer = try self.expect(kind: .integer) {
            return .integer(Int("\(integer)") ?? 0)
        }

        self.restore(_mark)

        if let float = try self.expect(kind: .float) {
            return .float(Double("\(float)") ?? 0.0)
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// not[Token]:
    ///     | NOT='not' { NOT }
    ///     | NOT='!' { NOT }
    ///     ;
    /// ```
    @memoized("not")
    @inlinable
    public func __not() throws -> Token? {
        let _mark: Mark = self.mark()

        if let NOT = try self.expect(kind: .not) {
            return NOT
        }

        self.restore(_mark)

        if let NOT = try self.expect(kind: .booleanNot) {
            return NOT
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// or[Token]:
    ///     | OR='or' { OR }
    ///     | OR='||' { OR }
    ///     ;
    /// ```
    @memoized("or")
    @inlinable
    public func __or() throws -> Token? {
        let _mark: Mark = self.mark()

        if let OR = try self.expect(kind: .or) {
            return OR
        }

        self.restore(_mark)

        if let OR = try self.expect(kind: .booleanOr) {
            return OR
        }

        self.restore(_mark)

        return nil
    }

    /// ```
    /// and[Token]:
    ///     | AND='and' { AND }
    ///     | AND='&&' { AND }
    ///     ;
    /// ```
    @memoized("and")
    @inlinable
    public func __and() throws -> Token? {
        let _mark: Mark = self.mark()

        if let AND = try self.expect(kind: .and) {
            return AND
        }

        self.restore(_mark)

        if let AND = try self.expect(kind: .booleanAnd) {
            return AND
        }

        self.restore(_mark)

        return nil
    }
}
