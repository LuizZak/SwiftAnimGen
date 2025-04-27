// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swift-anim-gen",
    dependencies: [
        .package(url: "https://github.com/LuizZak/MiniDigraph.git", exact: "0.8.0"),
        .package(url: "https://github.com/LuizZak/swift-peg.git", exact: "0.7.0"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftAnimGen",
            dependencies: [
                .product(name: "MiniDigraph", package: "MiniDigraph"),
                .product(name: "SwiftPEG", package: "swift-peg"),
            ],
            exclude: [
                "ConditionGrammar/condition.gram",
                "ConditionGrammar/condition.tokens",
            ]
        ),
        .testTarget(
            name: "SwiftAnimGenTests",
            dependencies: ["SwiftAnimGen"]
        )
    ]
)
