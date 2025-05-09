import Foundation

// MARK: - Helper global extensions to String with common functionality.

extension StringProtocol {
    /// Returns `true` if `self` starts with an uppercase character.
    var startsUppercased: Bool {
        guard let first = unicodeScalars.first else {
            return false
        }

        return CharacterSet.uppercaseLetters.contains(first)
    }

    /// Returns a copy of `self` with the first letter lowercased.
    var lowercasedFirstLetter: String {
        if isEmpty {
            return String(self)
        }

        return prefix(1).lowercased() + dropFirst()
    }

    /// Returns a copy of `self` with the first letter uppercased.
    var uppercasedFirstLetter: String {
        if isEmpty {
            return String(self)
        }

        return prefix(1).uppercased() + dropFirst()
    }
}

extension String {
    /// Produces a diff-like string with a marking on the first character
    /// that differs between `self` and a target string.
    func makeDifferenceMarkString(against string: String) -> String {
        guard let (line, column) = firstDifferingLineColumn(against: string) else {
            return self + "\n ~ Strings are equal."
        }

        let marker = String(repeating: "~", count: column - 1) + "^ Difference starts here"

        return insertingStringLine(marker, after: line)
    }

    func firstDifferingLineColumn(against string: String) -> (line: Int, column: Int)? {
        if self == string {
            return nil
        }

        if first != string.first {
            return (1, 1)
        }

        // Find first character differing across both strings
        let _offset =
            zip(indices, zip(self, string))
                .first { (_, chars) -> Bool in
                    return chars.0 != chars.1
                }?.0 // <result>.0: offset

        let offset = _offset ?? endIndex

        let column = columnOffset(at: offset)
        let line = lineNumber(at: offset)

        return (line, column)
    }

    private func insertingStringLine(_ string: String, after line: Int) -> String {
        let offset = offsetForStartOfLine(line + 1)

        var copy = self
        if offset == endIndex {
            return copy + "\n" + string
        }

        copy.insert(contentsOf: string + "\n", at: offset)
        return copy
    }

    private func offsetForStartOfLine(_ line: Int) -> Index {
        var lineCount = 1
        for (i, char) in zip(indices, self) {
            if lineCount >= line {
                return i
            }

            if char == "\n" {
                lineCount += 1
            }
        }

        return endIndex
    }

    /// Returns the ranges for all individual lines of text separated by a line-break
    /// character `\n` within this string.
    func lineRanges(includeLineBreak: Bool = false) -> [Range<Index>] {
        var lines: [Range<Index>] = []
        var currentLineStart = startIndex

        if includeLineBreak {
            for (index, char) in zip(indices, unicodeScalars) where char == "\n" {
                let nextLine = self.index(after: index)
                lines.append(currentLineStart..<nextLine)

                currentLineStart = nextLine
            }
        } else {
            for (index, char) in zip(indices, unicodeScalars) where char == "\n" {
                lines.append(currentLineStart..<index)

                // Skip past the line break char
                currentLineStart = self.index(after: index)
            }
        }

        lines.append(currentLineStart..<endIndex)

        return lines
    }

    /// Gets the line number for the given index in this string
    func lineNumber(at index: Index) -> Int {
        let line =
            self[..<index].reduce(0) {
                $0 + ($1 == "\n" ? 1 : 0)
            }

        return line + 1 // lines start at one
    }

    /// Gets the column offset number for the given index in this string.
    /// The column offset counts how many characters there are to the left to
    /// either the nearest newline or the beginning of the string.
    func columnOffset(at index: Index) -> Int {
        // Figure out start of line at the given index
        let lineStart =
            zip(self[..<index], indices)
                .reversed()
                .first { $0.0 == "\n" }?.1

        let lineStartOffset =
            lineStart.map(index(after:)) ?? startIndex

        return distance(from: lineStartOffset, to: index) + 1 // columns start at one
    }
}

extension String {
    /// Returns a range of sections of this string that represent C-based single
    /// and multi-lined comments.
    func cStyleCommentSectionRanges() -> [Range<Index>] {
        if self.count < 2 {
            return []
        }

        enum State {
            case normal
            case stringLiteral
            case singleLine(begin: Index)
            case multiLine(begin: Index)
        }

        var state = State.normal

        // Search for single-lined comments
        var ranges: [Range<Index>] = []

        var index = unicodeScalars.startIndex
        while index < unicodeScalars.index(before: unicodeScalars.endIndex) {
            defer {
                unicodeScalars.formIndex(after: &index)
            }

            switch state {
            case .normal:
                // String literal
                if unicodeScalars[index] == "\"" {
                    state = .stringLiteral
                    continue
                }

                // Ignore anything other than '/' since it doesn't form comments.
                if unicodeScalars[index] != "/" {
                    continue
                }

                let next = unicodeScalars[unicodeScalars.index(after: index)]

                // Single-line
                if next == "/" {
                    state = .singleLine(begin: index)
                // Multi-line
                } else if next == "*" {
                    state = .multiLine(begin: index)
                }

            case .stringLiteral:
                if unicodeScalars[index] == "\"" {
                    state = .normal
                }

            case .singleLine(let begin):
                // End of single-line
                if self[index] == "\n" {
                    ranges.append(begin..<unicodeScalars.index(after: index))
                    state = .normal
                }

            case .multiLine(let begin):
                // End of multi-line
                if self[index] == "*" && unicodeScalars[unicodeScalars.index(after: index)] == "/" {
                    ranges.append(begin..<unicodeScalars.index(index, offsetBy: 2))
                    state = .normal
                }
            }
        }

        // Finish any open comment ranges
        switch state {
        case .normal, .stringLiteral:
            break

        case .singleLine(let begin), .multiLine(let begin):
            ranges.append(begin..<endIndex)
        }

        return ranges
    }
}

extension String {
    /// Returns a copy of this string with no leading or trailing whitespace
    /// characters.
    ///
    /// The set of tested whitespace characters used is provided by
    /// `CharacterSet.whitespacesAndNewlines`.
    func trimmingWhitespace() -> String {
        return trimWhitespace(self)
    }

    /// Returns a copy of this string with no leading whitespace characters.
    ///
    /// The set of tested whitespace characters used is provided by
    /// `CharacterSet.whitespacesAndNewlines`.
    func trimmingWhitespaceLead() -> String {
        return trimWhitespaceLead(self)
    }

    /// Returns a copy of this string with no trailing whitespace characters.
    ///
    /// The set of tested whitespace characters used is provided by
    /// `CharacterSet.whitespacesAndNewlines`.
    func trimmingWhitespaceTrail() -> String {
        return trimWhitespaceTrail(self)
    }
}

@usableFromInline
func trimWhitespaceLead(_ string: String) -> String {
    if string.isEmpty {
        return string
    }

    var leading: String.Index = string.startIndex

    let charSet = CharacterSet.whitespacesAndNewlines

    while leading != string.endIndex {
        if charSet.contains(string.unicodeScalars[leading]) {
            string.formIndex(after: &leading)
        } else {
            break
        }
    }

    if leading == string.endIndex {
        return ""
    }

    return String(string[leading...])
}

@usableFromInline
func trimWhitespaceTrail(_ string: String) -> String {
    if string.isEmpty {
        return string
    }

    var trailing: String.Index = string.endIndex

    let charSet = CharacterSet.whitespacesAndNewlines

    while trailing > string.startIndex {
        if charSet.contains(string.unicodeScalars[string.unicodeScalars.index(before: trailing)]) {
            string.formIndex(before: &trailing)
        } else {
            break
        }
    }

    return String(string[..<trailing])
}

@usableFromInline
func trimWhitespace(_ string: String) -> String {
    trimWhitespaceTrail(trimWhitespaceLead(string))
}
