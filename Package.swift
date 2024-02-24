// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDSLayout",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SDSLayout",
            targets: ["SDSLayout"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tyagishi/SDSFoundationExtension", from: "1.0.0"),
        .package(url: "https://github.com/tyagishi/SDSCGExtension", from: "1.3.0"),
        .package(url: "https://github.com/tyagishi/SDSSwiftExtension", from: "2.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SDSLayout",
            dependencies: ["SDSFoundationExtension", "SDSCGExtension", "SDSSwiftExtension"]),
        .testTarget(
            name: "SDSLayoutTests",
            dependencies: ["SDSLayout"]),
    ]
)
