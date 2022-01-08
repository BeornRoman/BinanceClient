// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BinanceClient",
    products: [
        .library(
            name: "BinanceClient",
            targets: ["BinanceClient"])
    ],
    targets: [
        .target(
            name: "BinanceClient",
            dependencies: [],
            path: "BinanceClient"),
        .testTarget(name: "BinanceClientTests", dependencies: ["BinanceClient"], path: "Tests"),
    ],
    swiftLanguageVersions: [.v5]
)