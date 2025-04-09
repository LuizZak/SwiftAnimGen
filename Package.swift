// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swift-anim-gen",
    targets: [
        .executableTarget(
            name: "SwiftAnimGen"
        ),
        .testTarget(
            name: "SwiftAnimGenTests",
            dependencies: ["SwiftAnimGen"]
        )
    ]
)
