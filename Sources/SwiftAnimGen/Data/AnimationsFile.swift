struct AnimationsFile: Codable {
    var options: Options
    var constants: Constants
    var entryPoints: [EntryPoint]?
    var states: [AnimationState]

    enum CodingKeys: String, CodingKey {
        case options
        case constants
        case entryPoints = "entry_points"
        case states
    }
}

extension AnimationsFile {
    struct EntryPoint: Codable {
        var name: String
    }
}

extension AnimationsFile {
    struct Options: Codable {
        var animationNameKind: AnimationNameKind

        enum AnimationNameKind: String, Codable {
            case constant
        }

        enum CodingKeys: String, CodingKey {
            case animationNameKind = "animation_name_kind"
        }
    }
}

extension AnimationsFile {
    struct Constants: Codable {
        var stateMachine: [Constant]
        var animationNames: [Constant]

        struct Constant: Codable {
            var key: String
            var value: String

            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: GenericKey.self)

                guard let firstKey = container.allKeys.first else {
                    throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Expected at least one key in dictionary."))
                }

                key = firstKey.stringValue
                value = try container.decode(String.self, forKey: firstKey)
            }

            func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: GenericKey.self)

                try container.encode(value, forKey: .init(stringValue: key))
            }

            struct GenericKey: CodingKey {
                var stringValue: String
                var intValue: Int?

                init(stringValue: String) {
                    self.stringValue = stringValue
                }

                init?(intValue: Int) {
                    return nil
                }
            }
        }

        enum CodingKeys: String, CodingKey {
            case stateMachine = "state_machine"
            case animationNames = "animation_names"
        }
    }
}
