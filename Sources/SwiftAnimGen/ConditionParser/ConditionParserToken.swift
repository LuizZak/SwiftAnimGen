// HEADS UP! This is a generated file
import SwiftPEG

public struct ConditionParserToken: RawTokenType, CustomStringConvertible {
    public var kind: TokenKind

    public var string: Substring

    @inlinable
    public var length: Int {
        string.count
    }

    @inlinable
    public var description: String {
        String(string)
    }

    @inlinable
    public init(kind: TokenKind, string: Substring) {
        self.kind = kind

        self.string = string
    }

    @inlinable
    public static func produceDummy(_ kind: TokenKind) -> Self {
        .init(kind: kind, string: "<dummy>")
    }

    @inlinable
    public static func from<StringType>(stream: inout StringStream<StringType>) -> Self? where StringType.SubSequence == Substring {
        guard !stream.isEof else {
            return nil
        }

        stream.markSubstringStart()

        if consume_WHITESPACE(from: &stream) {
            return .init(kind: .whitespace, string: stream.substring)
        }

        if consume_BITWISEXOR(from: &stream) {
            return .init(kind: .bitwiseXor, string: stream.substring)
        }

        if consume_BOOLEANAND(from: &stream) {
            return .init(kind: .booleanAnd, string: stream.substring)
        }

        if consume_BITWISEAND(from: &stream) {
            return .init(kind: .bitwiseAnd, string: stream.substring)
        }

        if consume_BOOLEANOR(from: &stream) {
            return .init(kind: .booleanOr, string: stream.substring)
        }

        if consume_BITWISEOR(from: &stream) {
            return .init(kind: .bitwiseOr, string: stream.substring)
        }

        if consume_COMMA(from: &stream) {
            return .init(kind: .comma, string: stream.substring)
        }

        if consume_DIVIDE(from: &stream) {
            return .init(kind: .divide, string: stream.substring)
        }

        if consume_DOUBLESTAR(from: &stream) {
            return .init(kind: .doubleStar, string: stream.substring)
        }

        if consume_EQUALS(from: &stream) {
            return .init(kind: .equals, string: stream.substring)
        }

        if consume_GREATEROREQUALS(from: &stream) {
            return .init(kind: .greaterOrEquals, string: stream.substring)
        }

        if consume_LEFTBRACE(from: &stream) {
            return .init(kind: .leftBrace, string: stream.substring)
        }

        if consume_LEFTPAREN(from: &stream) {
            return .init(kind: .leftParen, string: stream.substring)
        }

        if consume_LEFTSHIFT(from: &stream) {
            return .init(kind: .leftShift, string: stream.substring)
        }

        if consume_LEFTSQUARE(from: &stream) {
            return .init(kind: .leftSquare, string: stream.substring)
        }

        if consume_LESSOREQUALS(from: &stream) {
            return .init(kind: .lessOrEquals, string: stream.substring)
        }

        if consume_LEFTANGLE(from: &stream) {
            return .init(kind: .leftAngle, string: stream.substring)
        }

        if consume_MINUS(from: &stream) {
            return .init(kind: .minus, string: stream.substring)
        }

        if consume_MODULUS(from: &stream) {
            return .init(kind: .modulus, string: stream.substring)
        }

        if consume_NOTEQUALS(from: &stream) {
            return .init(kind: .notEquals, string: stream.substring)
        }

        if consume_BOOLEANNOT(from: &stream) {
            return .init(kind: .booleanNot, string: stream.substring)
        }

        if consume_PERIOD(from: &stream) {
            return .init(kind: .period, string: stream.substring)
        }

        if consume_PLUS(from: &stream) {
            return .init(kind: .plus, string: stream.substring)
        }

        if consume_RIGHTBRACE(from: &stream) {
            return .init(kind: .rightBrace, string: stream.substring)
        }

        if consume_RIGHTPAREN(from: &stream) {
            return .init(kind: .rightParen, string: stream.substring)
        }

        if consume_RIGHTSHIFT(from: &stream) {
            return .init(kind: .rightShift, string: stream.substring)
        }

        if consume_RIGHTANGLE(from: &stream) {
            return .init(kind: .rightAngle, string: stream.substring)
        }

        if consume_RIGHTSQUARE(from: &stream) {
            return .init(kind: .rightSquare, string: stream.substring)
        }

        if consume_STAR(from: &stream) {
            return .init(kind: .star, string: stream.substring)
        }

        if consume_TILDE(from: &stream) {
            return .init(kind: .tilde, string: stream.substring)
        }

        if consume_AND(from: &stream) {
            return .init(kind: .and, string: stream.substring)
        }

        if consume_AS(from: &stream) {
            return .init(kind: .as, string: stream.substring)
        }

        if consume_ELSE(from: &stream) {
            return .init(kind: .else, string: stream.substring)
        }

        if consume_FLOAT(from: &stream) {
            return .init(kind: .float, string: stream.substring)
        }

        if consume_IDENTIFIER(from: &stream) {
            switch stream.substring {
            case "await":
                return .init(kind: .await, string: stream.substring)
            default:
                return .init(kind: .identifier, string: stream.substring)
            }
        }

        if consume_IF(from: &stream) {
            return .init(kind: .if, string: stream.substring)
        }

        if consume_IN(from: &stream) {
            return .init(kind: .in, string: stream.substring)
        }

        if consume_INTEGER(from: &stream) {
            return .init(kind: .integer, string: stream.substring)
        }

        if consume_IS(from: &stream) {
            return .init(kind: .is, string: stream.substring)
        }

        if consume_NOT(from: &stream) {
            return .init(kind: .not, string: stream.substring)
        }

        if consume_OR(from: &stream) {
            return .init(kind: .or, string: stream.substring)
        }

        if consume_STRING(from: &stream) {
            return .init(kind: .string, string: stream.substring)
        }

        return nil
    }

    public enum TokenKind: TokenKindType {
        /// `(" " | "\t" | "\n" | "\r")+`
        case whitespace

        /// `"await"`
        case await

        /// `"^"`
        case bitwiseXor

        /// `"&&"`
        case booleanAnd

        /// `"&"`
        case bitwiseAnd

        /// `"||"`
        case booleanOr

        /// `"|"`
        case bitwiseOr

        /// `","`
        case comma

        /// `"/"`
        case divide

        /// `"**"`
        case doubleStar

        /// `"=="`
        case equals

        /// `">="`
        case greaterOrEquals

        /// `"{"`
        case leftBrace

        /// `"("`
        case leftParen

        /// `"<<"`
        case leftShift

        /// `"["`
        case leftSquare

        /// `"<="`
        case lessOrEquals

        /// `"<"`
        case leftAngle

        /// `"-"`
        case minus

        /// `"%"`
        case modulus

        /// `"!="`
        case notEquals

        /// `"!"`
        case booleanNot

        /// `"."`
        case period

        /// `"+"`
        case plus

        /// `"}"`
        case rightBrace

        /// `")"`
        case rightParen

        /// `">>"`
        case rightShift

        /// `">"`
        case rightAngle

        /// `"]"`
        case rightSquare

        /// `"*"`
        case star

        /// `"~"`
        case tilde

        /// `"and" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"`
        case and

        /// `"as" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"`
        case `as`

        /// `"else" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"`
        case `else`

        /// `DIGITS "." DIGITS FLOAT_EXPONENT?`
        case float

        /// `identifierHead ("a"..."z" | "A"..."Z" | "0"..."9" | "_")*`
        case identifier

        /// `"if" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"`
        case `if`

        /// `"in" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"`
        case `in`

        /// ```
        /// INTEGER[".integer"]:
        ///     | DIGITS
        ///     | "0x" HEXDIGITS
        ///     | "0b" BINARYDIGITS
        ///     ;
        /// ```
        case integer

        /// `"is" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"`
        case `is`

        /// `"not" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"`
        case not

        /// `"or" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"`
        case or

        /// ```
        /// STRING[".string"]:
        ///     | "\"\"\"" ("\\\"\"\"" | unicodeEscape | "\\\\" | "\\" | !"\"\"\"" .)* "\"\"\""
        ///     | "\"" ("\\\"" | unicodeEscape | "\\\\" | "\\" | !"\"" !"\n" .)* "\""
        ///     | "'" ("\\'" | unicodeEscape | "\\\\" | "\\" | !"'" !"\n" .)* "'"
        ///     ;
        /// ```
        case string

        @inlinable
        public var description: String {
            switch self {
            case .whitespace:
                "WHITESPACE"
            case .await:
                "await"
            case .bitwiseXor:
                "^"
            case .booleanAnd:
                "&&"
            case .bitwiseAnd:
                "&"
            case .booleanOr:
                "||"
            case .bitwiseOr:
                "|"
            case .comma:
                ","
            case .divide:
                "/"
            case .doubleStar:
                "**"
            case .equals:
                "=="
            case .greaterOrEquals:
                ">="
            case .leftBrace:
                "{"
            case .leftParen:
                "("
            case .leftShift:
                "<<"
            case .leftSquare:
                "["
            case .lessOrEquals:
                "<="
            case .leftAngle:
                "<"
            case .minus:
                "-"
            case .modulus:
                "%"
            case .notEquals:
                "!="
            case .booleanNot:
                "!"
            case .period:
                "."
            case .plus:
                "+"
            case .rightBrace:
                "}"
            case .rightParen:
                ")"
            case .rightShift:
                ">>"
            case .rightAngle:
                ">"
            case .rightSquare:
                "]"
            case .star:
                "*"
            case .tilde:
                "~"
            case .and:
                "AND"
            case .as:
                "AS"
            case .else:
                "ELSE"
            case .float:
                "FLOAT"
            case .identifier:
                "IDENTIFIER"
            case .if:
                "IF"
            case .in:
                "IN"
            case .integer:
                "INTEGER"
            case .is:
                "IS"
            case .not:
                "NOT"
            case .or:
                "OR"
            case .string:
                "STRING"
            }
        }
    }

    /// ```
    /// WHITESPACE[".whitespace"]:
    ///     | (" " | "\t" | "\n" | "\r")+
    ///     ;
    /// ```
    @inlinable
    public static func consume_WHITESPACE<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        alt:
        do {
            switch stream.peek() {
            case " ", "\t", "\n", "\r":
                stream.advance()
            default:
                return false
            }

            while stream.advanceIfNext(" ") || stream.advanceIfNext("\t") || stream.advanceIfNext("\n") || stream.advanceIfNext("\r") {
            }

            return true
        }
    }

    /// ```
    /// AWAIT[".await"]:
    ///     | "await"
    ///     ;
    /// ```
    @inlinable
    public static func consume_AWAIT<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("await")
    }

    /// ```
    /// BITWISEXOR[".bitwiseXor"]:
    ///     | "^"
    ///     ;
    /// ```
    @inlinable
    public static func consume_BITWISEXOR<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("^")
    }

    /// ```
    /// BOOLEANAND[".booleanAnd"]:
    ///     | "&&"
    ///     ;
    /// ```
    @inlinable
    public static func consume_BOOLEANAND<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("&&")
    }

    /// ```
    /// BITWISEAND[".bitwiseAnd"]:
    ///     | "&"
    ///     ;
    /// ```
    @inlinable
    public static func consume_BITWISEAND<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("&")
    }

    /// ```
    /// BOOLEANOR[".booleanOr"]:
    ///     | "||"
    ///     ;
    /// ```
    @inlinable
    public static func consume_BOOLEANOR<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("||")
    }

    /// ```
    /// BITWISEOR[".bitwiseOr"]:
    ///     | "|"
    ///     ;
    /// ```
    @inlinable
    public static func consume_BITWISEOR<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("|")
    }

    /// ```
    /// COMMA[".comma"]:
    ///     | ","
    ///     ;
    /// ```
    @inlinable
    public static func consume_COMMA<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext(",")
    }

    /// ```
    /// DIVIDE[".divide"]:
    ///     | "/"
    ///     ;
    /// ```
    @inlinable
    public static func consume_DIVIDE<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("/")
    }

    /// ```
    /// DOUBLESTAR[".doubleStar"]:
    ///     | "**"
    ///     ;
    /// ```
    @inlinable
    public static func consume_DOUBLESTAR<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("**")
    }

    /// ```
    /// EQUALS[".equals"]:
    ///     | "=="
    ///     ;
    /// ```
    @inlinable
    public static func consume_EQUALS<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("==")
    }

    /// ```
    /// GREATEROREQUALS[".greaterOrEquals"]:
    ///     | ">="
    ///     ;
    /// ```
    @inlinable
    public static func consume_GREATEROREQUALS<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext(">=")
    }

    /// ```
    /// LEFTBRACE[".leftBrace"]:
    ///     | "{"
    ///     ;
    /// ```
    @inlinable
    public static func consume_LEFTBRACE<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("{")
    }

    /// ```
    /// LEFTPAREN[".leftParen"]:
    ///     | "("
    ///     ;
    /// ```
    @inlinable
    public static func consume_LEFTPAREN<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("(")
    }

    /// ```
    /// LEFTSHIFT[".leftShift"]:
    ///     | "<<"
    ///     ;
    /// ```
    @inlinable
    public static func consume_LEFTSHIFT<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("<<")
    }

    /// ```
    /// LEFTSQUARE[".leftSquare"]:
    ///     | "["
    ///     ;
    /// ```
    @inlinable
    public static func consume_LEFTSQUARE<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("[")
    }

    /// ```
    /// LESSOREQUALS[".lessOrEquals"]:
    ///     | "<="
    ///     ;
    /// ```
    @inlinable
    public static func consume_LESSOREQUALS<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("<=")
    }

    /// ```
    /// LEFTANGLE[".leftAngle"]:
    ///     | "<"
    ///     ;
    /// ```
    @inlinable
    public static func consume_LEFTANGLE<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("<")
    }

    /// ```
    /// MINUS[".minus"]:
    ///     | "-"
    ///     ;
    /// ```
    @inlinable
    public static func consume_MINUS<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("-")
    }

    /// ```
    /// MODULUS[".modulus"]:
    ///     | "%"
    ///     ;
    /// ```
    @inlinable
    public static func consume_MODULUS<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("%")
    }

    /// ```
    /// NOTEQUALS[".notEquals"]:
    ///     | "!="
    ///     ;
    /// ```
    @inlinable
    public static func consume_NOTEQUALS<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("!=")
    }

    /// ```
    /// BOOLEANNOT[".booleanNot"]:
    ///     | "!"
    ///     ;
    /// ```
    @inlinable
    public static func consume_BOOLEANNOT<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("!")
    }

    /// ```
    /// PERIOD[".period"]:
    ///     | "."
    ///     ;
    /// ```
    @inlinable
    public static func consume_PERIOD<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext(".")
    }

    /// ```
    /// PLUS[".plus"]:
    ///     | "+"
    ///     ;
    /// ```
    @inlinable
    public static func consume_PLUS<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("+")
    }

    /// ```
    /// RIGHTBRACE[".rightBrace"]:
    ///     | "}"
    ///     ;
    /// ```
    @inlinable
    public static func consume_RIGHTBRACE<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("}")
    }

    /// ```
    /// RIGHTPAREN[".rightParen"]:
    ///     | ")"
    ///     ;
    /// ```
    @inlinable
    public static func consume_RIGHTPAREN<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext(")")
    }

    /// ```
    /// RIGHTSHIFT[".rightShift"]:
    ///     | ">>"
    ///     ;
    /// ```
    @inlinable
    public static func consume_RIGHTSHIFT<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext(">>")
    }

    /// ```
    /// RIGHTANGLE[".rightAngle"]:
    ///     | ">"
    ///     ;
    /// ```
    @inlinable
    public static func consume_RIGHTANGLE<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext(">")
    }

    /// ```
    /// RIGHTSQUARE[".rightSquare"]:
    ///     | "]"
    ///     ;
    /// ```
    @inlinable
    public static func consume_RIGHTSQUARE<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("]")
    }

    /// ```
    /// STAR[".star"]:
    ///     | "*"
    ///     ;
    /// ```
    @inlinable
    public static func consume_STAR<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("*")
    }

    /// ```
    /// TILDE[".tilde"]:
    ///     | "~"
    ///     ;
    /// ```
    @inlinable
    public static func consume_TILDE<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        stream.advanceIfNext("~")
    }

    /// ```
    /// AND[".and"]:
    ///     | "and" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"
    ///     ;
    /// ```
    @inlinable
    public static func consume_AND<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard stream.advanceIfNext("and") else {
                return false
            }

            guard
                !stream.isNextInRange("a"..."z"),
                !stream.isNextInRange("A"..."Z"),
                !stream.isNextInRange("0"..."9"),
                !stream.isNext("_")
            else {
                break alt
            }

            return true
        }

        stream.restore(state)

        return false
    }

    /// ```
    /// AS[".as"]:
    ///     | "as" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"
    ///     ;
    /// ```
    @inlinable
    public static func consume_AS<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard stream.advanceIfNext("as") else {
                return false
            }

            guard
                !stream.isNextInRange("a"..."z"),
                !stream.isNextInRange("A"..."Z"),
                !stream.isNextInRange("0"..."9"),
                !stream.isNext("_")
            else {
                break alt
            }

            return true
        }

        stream.restore(state)

        return false
    }

    /// ```
    /// BINARYDIGITS:
    ///     | (BINARYDIGIT_WITH_SEPARATOR)+
    ///     ;
    /// ```
    @inlinable
    public static func consume_BINARYDIGITS<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        alt:
        do {
            guard consume_BINARYDIGIT_WITH_SEPARATOR(from: &stream) else {
                return false
            }

            while consume_BINARYDIGIT_WITH_SEPARATOR(from: &stream) {
            }

            return true
        }
    }

    /// ```
    /// BINARYDIGIT_WITH_SEPARATOR:
    ///     | BINARYDIGIT "_"?
    ///     ;
    /// ```
    @inlinable
    public static func consume_BINARYDIGIT_WITH_SEPARATOR<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        alt:
        do {
            guard consume_BINARYDIGIT(from: &stream) else {
                return false
            }

            _ = stream.advanceIfNext("_")

            return true
        }
    }

    /// ```
    /// DIGITS:
    ///     | (DIGIT_WITH_SEPARATOR)+
    ///     ;
    /// ```
    @inlinable
    public static func consume_DIGITS<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        alt:
        do {
            guard consume_DIGIT_WITH_SEPARATOR(from: &stream) else {
                return false
            }

            while consume_DIGIT_WITH_SEPARATOR(from: &stream) {
            }

            return true
        }
    }

    /// ```
    /// DIGIT_WITH_SEPARATOR:
    ///     | "0"..."9" "_"?
    ///     ;
    /// ```
    @inlinable
    public static func consume_DIGIT_WITH_SEPARATOR<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        alt:
        do {
            guard
                !stream.isEof,
                stream.isNextInRange("0"..."9")
            else {
                return false
            }

            stream.advance()

            _ = stream.advanceIfNext("_")

            return true
        }
    }

    /// ```
    /// BINARYDIGIT:
    ///     | "0"
    ///     | "1"
    ///     ;
    /// ```
    @inlinable
    public static func consume_BINARYDIGIT<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        return stream.advanceIfNext("0") || stream.advanceIfNext("1")
    }

    /// ```
    /// ELSE[".else"]:
    ///     | "else" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"
    ///     ;
    /// ```
    @inlinable
    public static func consume_ELSE<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard stream.advanceIfNext("else") else {
                return false
            }

            guard
                !stream.isNextInRange("a"..."z"),
                !stream.isNextInRange("A"..."Z"),
                !stream.isNextInRange("0"..."9"),
                !stream.isNext("_")
            else {
                break alt
            }

            return true
        }

        stream.restore(state)

        return false
    }

    /// ```
    /// FLOAT[".float"]:
    ///     | DIGITS "." DIGITS FLOAT_EXPONENT?
    ///     ;
    /// ```
    @inlinable
    public static func consume_FLOAT<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard consume_DIGITS(from: &stream) else {
                return false
            }

            guard stream.advanceIfNext(".") else {
                break alt
            }

            guard consume_DIGITS(from: &stream) else {
                break alt
            }

            _ = consume_FLOAT_EXPONENT(from: &stream)

            return true
        }

        stream.restore(state)

        return false
    }

    /// ```
    /// FLOAT_EXPONENT:
    ///     | "e" ("+" | "-")? DIGITS
    ///     ;
    /// ```
    @inlinable
    public static func consume_FLOAT_EXPONENT<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard stream.advanceIfNext("e") else {
                return false
            }

            switch stream.peek() {
            case "+", "-":
                stream.advance()
            default:
                Void()
            }

            guard consume_DIGITS(from: &stream) else {
                break alt
            }

            return true
        }

        stream.restore(state)

        return false
    }

    /// ```
    /// HEXDIGIT:
    ///     | "0"..."9"
    ///     | "A"..."F"
    ///     | "a"..."f"
    ///     ;
    /// ```
    @inlinable
    public static func consume_HEXDIGIT<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        alt:
        do {
            guard
                !stream.isEof,
                stream.isNextInRange("0"..."9")
            else {
                break alt
            }

            stream.advance()

            return true
        }

        alt:
        do {
            guard
                !stream.isEof,
                stream.isNextInRange("A"..."F")
            else {
                break alt
            }

            stream.advance()

            return true
        }

        alt:
        do {
            guard
                !stream.isEof,
                stream.isNextInRange("a"..."f")
            else {
                return false
            }

            stream.advance()

            return true
        }
    }

    /// ```
    /// HEXDIGITS:
    ///     | (HEXDIGIT_WITH_SEPARATOR)+
    ///     ;
    /// ```
    @inlinable
    public static func consume_HEXDIGITS<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        alt:
        do {
            guard consume_HEXDIGIT_WITH_SEPARATOR(from: &stream) else {
                return false
            }

            while consume_HEXDIGIT_WITH_SEPARATOR(from: &stream) {
            }

            return true
        }
    }

    /// ```
    /// HEXDIGIT_WITH_SEPARATOR:
    ///     | HEXDIGIT "_"?
    ///     ;
    /// ```
    @inlinable
    public static func consume_HEXDIGIT_WITH_SEPARATOR<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        alt:
        do {
            guard consume_HEXDIGIT(from: &stream) else {
                return false
            }

            _ = stream.advanceIfNext("_")

            return true
        }
    }

    /// ```
    /// IDENTIFIER[".identifier"]:
    ///     | identifierHead ("a"..."z" | "A"..."Z" | "0"..."9" | "_")*
    ///     ;
    /// ```
    @inlinable
    public static func consume_IDENTIFIER<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        alt:
        do {
            guard consume_identifierHead(from: &stream) else {
                return false
            }

            loop:
            while !stream.isEof {
                switch stream.peek() {
                case "a"..."z", "A"..."Z", "0"..."9", "_":
                    stream.advance()
                default:
                    break loop
                }
            }

            return true
        }
    }

    /// ```
    /// IF[".if"]:
    ///     | "if" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"
    ///     ;
    /// ```
    @inlinable
    public static func consume_IF<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard stream.advanceIfNext("if") else {
                return false
            }

            guard
                !stream.isNextInRange("a"..."z"),
                !stream.isNextInRange("A"..."Z"),
                !stream.isNextInRange("0"..."9"),
                !stream.isNext("_")
            else {
                break alt
            }

            return true
        }

        stream.restore(state)

        return false
    }

    /// ```
    /// IN[".in"]:
    ///     | "in" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"
    ///     ;
    /// ```
    @inlinable
    public static func consume_IN<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard stream.advanceIfNext("in") else {
                return false
            }

            guard
                !stream.isNextInRange("a"..."z"),
                !stream.isNextInRange("A"..."Z"),
                !stream.isNextInRange("0"..."9"),
                !stream.isNext("_")
            else {
                break alt
            }

            return true
        }

        stream.restore(state)

        return false
    }

    /// ```
    /// INTEGER[".integer"]:
    ///     | DIGITS
    ///     | "0x" HEXDIGITS
    ///     | "0b" BINARYDIGITS
    ///     ;
    /// ```
    @inlinable
    public static func consume_INTEGER<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard consume_DIGITS(from: &stream) else {
                break alt
            }

            return true
        }

        alt:
        do {
            guard stream.advanceIfNext("0x") else {
                break alt
            }

            guard consume_HEXDIGITS(from: &stream) else {
                break alt
            }

            return true
        }

        stream.restore(state)

        alt:
        do {
            guard stream.advanceIfNext("0b") else {
                return false
            }

            guard consume_BINARYDIGITS(from: &stream) else {
                break alt
            }

            return true
        }

        stream.restore(state)

        return false
    }

    /// ```
    /// IS[".is"]:
    ///     | "is" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"
    ///     ;
    /// ```
    @inlinable
    public static func consume_IS<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard stream.advanceIfNext("is") else {
                return false
            }

            guard
                !stream.isNextInRange("a"..."z"),
                !stream.isNextInRange("A"..."Z"),
                !stream.isNextInRange("0"..."9"),
                !stream.isNext("_")
            else {
                break alt
            }

            return true
        }

        stream.restore(state)

        return false
    }

    /// ```
    /// NOT[".not"]:
    ///     | "not" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"
    ///     ;
    /// ```
    @inlinable
    public static func consume_NOT<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard stream.advanceIfNext("not") else {
                return false
            }

            guard
                !stream.isNextInRange("a"..."z"),
                !stream.isNextInRange("A"..."Z"),
                !stream.isNextInRange("0"..."9"),
                !stream.isNext("_")
            else {
                break alt
            }

            return true
        }

        stream.restore(state)

        return false
    }

    /// ```
    /// OR[".or"]:
    ///     | "or" !"a"..."z" !"A"..."Z" !"0"..."9" !"_"
    ///     ;
    /// ```
    @inlinable
    public static func consume_OR<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard stream.advanceIfNext("or") else {
                return false
            }

            guard
                !stream.isNextInRange("a"..."z"),
                !stream.isNextInRange("A"..."Z"),
                !stream.isNextInRange("0"..."9"),
                !stream.isNext("_")
            else {
                break alt
            }

            return true
        }

        stream.restore(state)

        return false
    }

    /// ```
    /// STRING[".string"]:
    ///     | "\"\"\"" ("\\\"\"\"" | unicodeEscape | "\\\\" | "\\" | !"\"\"\"" .)* "\"\"\""
    ///     | "\"" ("\\\"" | unicodeEscape | "\\\\" | "\\" | !"\"" !"\n" .)* "\""
    ///     | "'" ("\\'" | unicodeEscape | "\\\\" | "\\" | !"'" !"\n" .)* "'"
    ///     ;
    /// ```
    @inlinable
    public static func consume_STRING<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard stream.advanceIfNext("\"\"\"") else {
                break alt
            }

            loop:
            while !stream.isEof {
                if stream.advanceIfNext("\\\"\"\"") {
                } else if consume_unicodeEscape(from: &stream) {
                } else if stream.advanceIfNext("\\\\") {
                } else if stream.advanceIfNext("\\") {
                } else if
                    !stream.isNext("\"\"\""),
                    !stream.isEof
                {
                    stream.advance()
                } else {
                    break loop
                }
            }

            guard stream.advanceIfNext("\"\"\"") else {
                break alt
            }

            return true
        }

        stream.restore(state)

        alt:
        do {
            guard stream.advanceIfNext("\"") else {
                break alt
            }

            loop:
            while !stream.isEof {
                if stream.advanceIfNext("\\\"") {
                } else if consume_unicodeEscape(from: &stream) {
                } else if stream.advanceIfNext("\\\\") {
                } else if stream.advanceIfNext("\\") {
                } else if
                    !stream.isNext("\""),
                    !stream.isNext("\n"),
                    !stream.isEof
                {
                    stream.advance()
                } else {
                    break loop
                }
            }

            guard stream.advanceIfNext("\"") else {
                break alt
            }

            return true
        }

        stream.restore(state)

        alt:
        do {
            guard stream.advanceIfNext("\'") else {
                return false
            }

            loop:
            while !stream.isEof {
                if stream.advanceIfNext("\\\'") {
                } else if consume_unicodeEscape(from: &stream) {
                } else if stream.advanceIfNext("\\\\") {
                } else if stream.advanceIfNext("\\") {
                } else if
                    !stream.isNext("\'"),
                    !stream.isNext("\n"),
                    !stream.isEof
                {
                    stream.advance()
                } else {
                    break loop
                }
            }

            guard stream.advanceIfNext("\'") else {
                break alt
            }

            return true
        }

        stream.restore(state)

        return false
    }

    /// ```
    /// identifierHead:
    ///     | "a"..."z"
    ///     | "A"..."Z"
    ///     | "_"
    ///     ;
    /// ```
    @inlinable
    public static func consume_identifierHead<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        alt:
        do {
            guard
                !stream.isEof,
                stream.isNextInRange("a"..."z")
            else {
                break alt
            }

            stream.advance()

            return true
        }

        alt:
        do {
            guard
                !stream.isEof,
                stream.isNextInRange("A"..."Z")
            else {
                break alt
            }

            stream.advance()

            return true
        }

        return stream.advanceIfNext("_")
    }

    /// ```
    /// unicodeEscape:
    ///     | "\\u" ("0"..."9" | "A"..."F" | "a"..."f")+
    ///     | "\\U" ("0"..."9" | "A"..."F" | "a"..."f")+
    ///     ;
    /// ```
    @inlinable
    public static func consume_unicodeEscape<StringType>(from stream: inout StringStream<StringType>) -> Bool {
        guard !stream.isEof else {
            return false
        }

        let state: StringStream<StringType>.State = stream.save()

        alt:
        do {
            guard stream.advanceIfNext("\\u") else {
                break alt
            }

            switch stream.peek() {
            case "0"..."9", "A"..."F", "a"..."f":
                stream.advance()
            default:
                break alt
            }

            loop:
            while !stream.isEof {
                switch stream.peek() {
                case "0"..."9", "A"..."F", "a"..."f":
                    stream.advance()
                default:
                    break loop
                }
            }

            return true
        }

        stream.restore(state)

        alt:
        do {
            guard stream.advanceIfNext("\\U") else {
                return false
            }

            switch stream.peek() {
            case "0"..."9", "A"..."F", "a"..."f":
                stream.advance()
            default:
                break alt
            }

            loop:
            while !stream.isEof {
                switch stream.peek() {
                case "0"..."9", "A"..."F", "a"..."f":
                    stream.advance()
                default:
                    break loop
                }
            }

            return true
        }

        stream.restore(state)

        return false
    }
}
