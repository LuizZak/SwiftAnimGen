import Foundation

if ProcessInfo.processInfo.arguments.count < 2 {
    print("Expected .json file path as first argument")
    exit(1)
}

let jsonPath = URL(fileURLWithPath: ProcessInfo.processInfo.arguments[1])
let jsonData = try Data(contentsOf: jsonPath)

let animationsFile = try JSONDecoder().decode(AnimationsFile.self, from: jsonData)

let generator = GDScriptCodeGen()

let result = generator.generate(animationsFile)

print(result)
