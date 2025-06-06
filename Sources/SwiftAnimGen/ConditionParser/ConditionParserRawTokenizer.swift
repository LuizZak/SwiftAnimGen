@preconcurrency import SwiftPEG

/// A tokenizer for ConditionParser grammar files.
/// Reads tokens out of a character stream.
public class ConditionParserRawTokenizer: RawTokenizerType {
    public typealias RawToken = ConditionParserToken
    public typealias Location = FileSourceLocation

    @usableFromInline
    var _stream: StringStream<String>

    /// Internal source location tracker
    @usableFromInline
    internal var _location: FileSourceLocation

    @inlinable
    public var isEOF: Bool {
        _stream.isEof
    }

    @inlinable
    public init(source: String) {
        self._stream = StringStream(source: source)
        _location = FileSourceLocation(line: 1, column: 1)
    }

    @inlinable
    public func next() throws -> (rawToken: RawToken, location: Location)? {
        guard !_stream.isEof else {
            return nil
        }

        // TODO: Maybe backtracking like this defeats the purpose of having a
        // TODO: 'raw' stream in the first place?
        let state = _stream.save()

        guard
            let token = RawToken.from(stream: &_stream),
            token.length > 0
        else {
            _stream.restore(state)
            throw Error.unknownToken(_location, _stream.peek())
        }

        defer {
            // Backtrack and advance back so we have appropriate line/column counts
            _stream.restore(state)
            advance(by: token.length)
            _stream.markSubstringStart()
        }

        return (token, _location)
    }

    @inlinable
    internal func advance(by count: Int) {
        for _ in 0..<count {
            if _stream.isEof { break }

            if _stream.peek() == "\n" {
                _location.column = 0
                _location.line += 1
            }

            _stream.advance()
            _location.column += 1
        }
    }

    public enum Error: TokenizerError {
        case unknownToken(FileSourceLocation, Character)

        public var description: String {
            switch self {
            case .unknownToken(let location, let tok):
                return "\(location): Unknown token: \(tok)"
            }
        }
    }
}
