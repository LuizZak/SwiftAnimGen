public enum ConditionGrammar {
    public struct Condition {
        public var expression: Expression

        public init(expression: Expression) {
            self.expression = expression
        }
    }

    public indirect enum Expression {
        case `subscript`(Expression, Expression)
        case attribute(Expression, String)
        case functionCall(Expression, [Expression])
        case await(Expression)
        case typeCast(TypeCastingExpression)
    }

    public indirect enum TypeCastingExpression {
        case typeCast(Self, TernaryExpression)
        case ternary(TernaryExpression)
    }

    public indirect enum TernaryExpression {
        case ternary(trueExpr: BooleanOrExpression, condition: Expression, falseExpr: Self)
        case booleanOr(BooleanOrExpression)
    }

    public indirect enum BooleanOrExpression {
        case or(Self, BooleanAndExpression)
        case booleanAnd(BooleanAndExpression)
    }

    public indirect enum BooleanAndExpression {
        case and(Self, BooleanNotExpression)
        case booleanNot(BooleanNotExpression)
    }

    public indirect enum BooleanNotExpression {
        case not(Self)
        case inclusionCheck(InclusionCheckExpression)
    }

    public indirect enum InclusionCheckExpression {
        case `in`(Self, ComparisonExpression)
        case notIn(Self, ComparisonExpression)
        case comparison(ComparisonExpression)
    }

    public indirect enum ComparisonExpression {
        case equals(Self, BitwiseOrExpression)
        case notEquals(Self, BitwiseOrExpression)
        case lessThan(Self, BitwiseOrExpression)
        case greaterThan(Self, BitwiseOrExpression)
        case lessThanOrEqual(Self, BitwiseOrExpression)
        case greaterThanOrEqual(Self, BitwiseOrExpression)
        case bitwiseOr(BitwiseOrExpression)
    }

    public indirect enum BitwiseOrExpression {
        case or(Self, BitwiseXorExpression)
        case bitwiseXor(BitwiseXorExpression)
    }

    public indirect enum BitwiseXorExpression {
        case xor(Self, BitwiseAndExpression)
        case bitwiseAnd(BitwiseAndExpression)
    }

    public indirect enum BitwiseAndExpression {
        case and(Self, BitShiftExpression)
        case bitShift(BitShiftExpression)
    }

    public indirect enum BitShiftExpression {
        case leftShift(Self, AdditionExpression)
        case rightShift(Self, AdditionExpression)
        case addition(AdditionExpression)
    }

    public indirect enum AdditionExpression {
        case add(Self, MultiplicationExpression)
        case subtract(Self, MultiplicationExpression)
        case multiplication(MultiplicationExpression)
    }

    public indirect enum MultiplicationExpression {
        case multiply(Self, IdentityExpression)
        case divide(Self, IdentityExpression)
        case modulus(Self, IdentityExpression)
        case identity(IdentityExpression)
    }

    public indirect enum IdentityExpression {
        case identity(Self)
        case negation(Self)
        case bitwiseNot(BitwiseNotExpression)
    }

    public indirect enum BitwiseNotExpression {
        case bitwiseNot(Self)
        case powerExpression(PowerExpression)
    }

    public indirect enum PowerExpression {
        case power(Self, TypeCheckExpression)
        case typeCheck(TypeCheckExpression)
    }

    public indirect enum TypeCheckExpression {
        case isType(Self, AtomExpression)
        case isNotType(Self, AtomExpression)
        case atom(AtomExpression)
    }

    public indirect enum AtomExpression {
        case parens(Expression)
        case identifier(String)
        case literal(Literal)
    }

    public enum Operator {
        case and
        case or
        case not
    }

    public enum Literal {
        case string(String)
        case integer(Int)
        case float(Double)
    }
}
