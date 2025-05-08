// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NumbersCore",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "NumbersCore",
            targets: ["NumbersCore"]),
    ],
    targets: [
        .target(
            name: "NumbersCore"),
        .testTarget(
            name: "NumbersCoreTests",
            dependencies: ["NumbersCore"],
            resources: [.copy("MockJSONResponses")]
        ),
    ]
)
