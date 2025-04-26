// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swift-anim-gen",
    dependencies: [
        .package(url: "https://github.com/LuizZak/MiniDigraph.git", exact: "0.8.1")
    ],
    targets: [
        .executableTarget(
            name: "SwiftAnimGen",
            dependencies: [
                .product(name: "MiniDigraph", package: "MiniDigraph"),
            ]
        ),
        .testTarget(
            name: "SwiftAnimGenTests",
            dependencies: ["SwiftAnimGen"]
        )
    ]
)
