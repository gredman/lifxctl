// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "lifxctl",
    platforms: [.macOS(.v11)],
    products: [
        .executable(
            name: "lifxctl",
            targets: ["lifxctl"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "0.4.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "lifxctl",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "lifxctlTests",
            dependencies: ["lifxctl"]),
    ]
)
