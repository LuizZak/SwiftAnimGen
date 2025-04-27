public enum ConditionGrammar {
    public struct Condition: CustomStringConvertible, Hashable {
        public var expression: Expression
        public var description: String {
            "\(expression)"
        }

        public init(expression: Expression) {
            self.expression = expression
        }
    }

    public indirect enum Expression: CustomStringConvertible, Hashable {
        case typeCast(TypeCastingExpression)

        public var description: String {
            switch self {
            case .typeCast(let typeCast):
                return "\(typeCast)"
            }
        }
    }

    public indirect enum TypeCastingExpression: CustomStringConvertible, Hashable {
        case typeCast(Self, TernaryExpression)
        case ternary(TernaryExpression)

        public var description: String {
            switch self {
            case .typeCast(let lhs, let rhs):
                return "\(lhs) as \(rhs)"

            case .ternary(let ternary):
                return "\(ternary)"
            }
        }
    }

    public indirect enum TernaryExpression: CustomStringConvertible, Hashable {
        case ternary(trueExpr: BooleanOrExpression, condition: Expression, falseExpr: Self)
        case booleanOr(BooleanOrExpression)

        public var description: String {
            switch self {
            case .ternary(let ifTrue, let condition, let ifFalse):
                return "\(ifTrue) if \(condition) else \(ifFalse)"

            case .booleanOr(let booleanOr):
                return "\(booleanOr)"
            }
        }
    }

    public indirect enum BooleanOrExpression: CustomStringConvertible, Hashable {
        case or(Self, BooleanAndExpression)
        case booleanAnd(BooleanAndExpression)

        public var description: String {
            switch self {
            case .or(let lhs, let rhs):
                return "\(lhs) or \(rhs)"

            case .booleanAnd(let booleanAnd):
                return "\(booleanAnd)"
            }
        }
    }

    public indirect enum BooleanAndExpression: CustomStringConvertible, Hashable {
        case and(Self, BooleanNotExpression)
        case booleanNot(BooleanNotExpression)

        public var description: String {
            switch self {
            case .and(let lhs, let rhs):
                return "\(lhs) and \(rhs)"

            case .booleanNot(let booleanNot):
                return "\(booleanNot)"
            }
        }
    }

    public indirect enum BooleanNotExpression: CustomStringConvertible, Hashable {
        case not(Self)
        case inclusionCheck(InclusionCheckExpression)

        public var description: String {
            switch self {
            case .not(let value):
                return "not \(value)"

            case .inclusionCheck(let inclusionCheck):
                return "\(inclusionCheck)"
            }
        }
    }

    public indirect enum InclusionCheckExpression: CustomStringConvertible, Hashable {
        case `in`(Self, ComparisonExpression)
        case notIn(Self, ComparisonExpression)
        case comparison(ComparisonExpression)

        public var description: String {
            switch self {
            case .in(let lhs, let rhs):
                return "\(lhs) in \(rhs)"

            case .notIn(let lhs, let rhs):
                return "\(lhs) not in \(rhs)"

            case .comparison(let comparison):
                return "\(comparison)"
            }
        }
    }

    public indirect enum ComparisonExpression: CustomStringConvertible, Hashable {
        case equals(Self, BitwiseOrExpression)
        case notEquals(Self, BitwiseOrExpression)
        case lessThan(Self, BitwiseOrExpression)
        case greaterThan(Self, BitwiseOrExpression)
        case lessThanOrEqual(Self, BitwiseOrExpression)
        case greaterThanOrEqual(Self, BitwiseOrExpression)
        case bitwiseOr(BitwiseOrExpression)

        public var description: String {
            switch self {
            case .equals(let lhs, let rhs):
                return "\(lhs) == \(rhs)"

            case .notEquals(let lhs, let rhs):
                return "\(lhs) != \(rhs)"

            case .lessThan(let lhs, let rhs):
                return "\(lhs) < \(rhs)"

            case .greaterThan(let lhs, let rhs):
                return "\(lhs) > \(rhs)"

            case .lessThanOrEqual(let lhs, let rhs):
                return "\(lhs) <= \(rhs)"

            case .greaterThanOrEqual(let lhs, let rhs):
                return "\(lhs) >= \(rhs)"

            case .bitwiseOr(let bitwiseOr):
                return "\(bitwiseOr)"
            }
        }
    }

    public indirect enum BitwiseOrExpression: CustomStringConvertible, Hashable {
        case or(Self, BitwiseXorExpression)
        case bitwiseXor(BitwiseXorExpression)

        public var description: String {
            switch self {
            case .or(let lhs, let rhs):
                return "\(lhs) | \(rhs)"

            case .bitwiseXor(let bitwiseXor):
                return "\(bitwiseXor)"
            }
        }
    }

    public indirect enum BitwiseXorExpression: CustomStringConvertible, Hashable {
        case xor(Self, BitwiseAndExpression)
        case bitwiseAnd(BitwiseAndExpression)

        public var description: String {
            switch self {
            case .xor(let lhs, let rhs):
                return "\(lhs) ^ \(rhs)"

            case .bitwiseAnd(let bitwiseAnd):
                return "\(bitwiseAnd)"
            }
        }
    }

    public indirect enum BitwiseAndExpression: CustomStringConvertible, Hashable {
        case and(Self, BitShiftExpression)
        case bitShift(BitShiftExpression)

        public var description: String {
            switch self {
            case .and(let lhs, let rhs):
                return "\(lhs) & \(rhs)"

            case .bitShift(let bitShift):
                return "\(bitShift)"
            }
        }
    }

    public indirect enum BitShiftExpression: CustomStringConvertible, Hashable {
        case leftShift(Self, AdditionExpression)
        case rightShift(Self, AdditionExpression)
        case addition(AdditionExpression)

        public var description: String {
            switch self {
            case .leftShift(let lhs, let rhs):
                return "\(lhs) << \(rhs)"

            case .rightShift(let lhs, let rhs):
                return "\(lhs) >> \(rhs)"

            case .addition(let addition):
                return "\(addition)"
            }
        }
    }

    public indirect enum AdditionExpression: CustomStringConvertible, Hashable {
        case add(Self, MultiplicationExpression)
        case subtract(Self, MultiplicationExpression)
        case multiplication(MultiplicationExpression)

        public var description: String {
            switch self {
            case .add(let lhs, let rhs):
                return "\(lhs) + \(rhs)"

            case .subtract(let lhs, let rhs):
                return "\(lhs) - \(rhs)"

            case .multiplication(let multiplication):
                return "\(multiplication)"
            }
        }
    }

    public indirect enum MultiplicationExpression: CustomStringConvertible, Hashable {
        case multiply(Self, IdentityExpression)
        case divide(Self, IdentityExpression)
        case modulus(Self, IdentityExpression)
        case identity(IdentityExpression)

        public var description: String {
            switch self {
            case .multiply(let lhs, let rhs):
                return "\(lhs) * \(rhs)"

            case .divide(let lhs, let rhs):
                return "\(lhs) / \(rhs)"

            case .modulus(let lhs, let rhs):
                return "\(lhs) % \(rhs)"

            case .identity(let identity):
                return "\(identity)"
            }
        }
    }

    public indirect enum IdentityExpression: CustomStringConvertible, Hashable {
        case identity(Self)
        case negation(Self)
        case bitwiseNot(BitwiseNotExpression)

        public var description: String {
            switch self {
            case .identity(let value):
                return "+\(value)"

            case .negation(let value):
                return "-\(value)"

            case .bitwiseNot(let bitwiseNot):
                return "\(bitwiseNot)"
            }
        }
    }

    public indirect enum BitwiseNotExpression: CustomStringConvertible, Hashable {
        case bitwiseNot(Self)
        case power(PowerExpression)

        public var description: String {
            switch self {
            case .bitwiseNot(let value):
                return "~\(value)"

            case .power(let power):
                return "\(power)"
            }
        }
    }

    public indirect enum PowerExpression: CustomStringConvertible, Hashable {
        case power(Self, TypeCheckExpression)
        case typeCheck(TypeCheckExpression)

        public var description: String {
            switch self {
            case .power(let lhs, let rhs):
                return "\(lhs) ** \(rhs)"

            case .typeCheck(let typeCheck):
                return "\(typeCheck)"
            }
        }
    }

    public indirect enum TypeCheckExpression: CustomStringConvertible, Hashable {
        case isType(Self, AwaitExpression)
        case isNotType(Self, AwaitExpression)
        case await(AwaitExpression)

        public var description: String {
            switch self {
            case .isType(let lhs, let atom):
                return "\(lhs) is \(atom)"

            case .isNotType(let lhs, let atom):
                return "\(lhs) is not \(atom)"

            case .await(let `await`):
                return "\(`await`)"
            }
        }
    }

    public indirect enum AwaitExpression: CustomStringConvertible, Hashable {
        case await(AwaitExpression)
        case postfix(PostfixExpression)

        public var description: String {
            switch self {
            case .await(let base):
                return "await \(base)"

            case .postfix(let postfix):
                return "\(postfix)"
            }
        }
    }

    public indirect enum PostfixExpression: CustomStringConvertible, Hashable {
        case attribute(PostfixExpression, String)
        case functionCall(PostfixExpression, [Expression])
        case subscription(PostfixExpression, Expression)
        case grouping(GroupingExpression)

        public var description: String {
            switch self {
            case .attribute(let base, let attribute):
                return "\(base).\(attribute)"

            case .functionCall(let base, let arguments):
                return "\(base)(\(arguments.map(\.description).joined(separator: ", ")))"

            case .subscription(let base, let arguments):
                return "\(base)\(arguments)"

            case .grouping(let grouping):
                return "\(grouping)"
            }
        }
    }

    public indirect enum GroupingExpression: CustomStringConvertible, Hashable {
        case grouping(Expression)
        case atom(AtomExpression)

        public var description: String {
            switch self {
            case .grouping(let expression):
                return "\((expression))"

            case .atom(let atom):
                return "\(atom)"
            }
        }
    }

    public indirect enum AtomExpression: CustomStringConvertible, Hashable {
        case parens(Expression)
        case identifier(String)
        case literal(Literal)

        public var description: String {
            switch self {
            case .parens(let exp):
                return "(\(exp))"

            case .identifier(let identifier):
                return identifier

            case .literal(let literal):
                return "\(literal)"
            }
        }
    }

    public enum Literal: CustomStringConvertible, Hashable {
        case string(String)
        case integer(Int)
        case float(Double)

        public var description: String {
            switch self {
            case .string(let string):
                return string.debugDescription

            case .integer(let value):
                return "\(value)"

            case .float(let value):
                return "\(value)"
            }
        }
    }
}
