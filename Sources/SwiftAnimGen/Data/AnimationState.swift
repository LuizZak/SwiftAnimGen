struct AnimationState: Codable {
    var name: String
    var description: String?
    var animationName: String
    var transitions: [AnimationTransition]?
    var onEnd: [AnimationTransition]?

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case animationName = "animation_name"
        case transitions
        case onEnd = "on_end"
    }
}

struct AnimationTransition: Codable {
    var state: String
    var conditions: Conditions?
    var options: Options?

    enum Conditions: Codable, Equatable {
        case constants([ConstantEntry])

        init(from decoder: any Decoder) throws {
            do {
                var unkeyedContainer = try decoder.unkeyedContainer()

                var constants: [ConstantEntry] = []

                while !unkeyedContainer.isAtEnd {
                    let entry = try unkeyedContainer.decode(ConstantEntry.self)
                    constants.append(entry)
                }

                self = .constants(constants)
            } catch {
                throw error
            }
        }

        func encode(to encoder: any Encoder) throws {
            switch self {
            case .constants(let constants):
                var container = encoder.unkeyedContainer()

                try container.encode(contentsOf: constants)
            }
        }

        struct ConstantEntry: Codable, Equatable {
            var isNegated: Bool
            var entry: String

            init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()

                let constant = try container.decode(String.self)

                if constant.hasPrefix("!") {
                    isNegated = true
                    entry = String(constant.dropFirst())
                } else {
                    isNegated = false
                    entry = constant
                }
            }

            init(isNegated: Bool, entry: String) {
                self.isNegated = isNegated
                self.entry = entry
            }
        }
    }

    struct Options: Codable {
        var initializer: String?
    }
}
