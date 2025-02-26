// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GoodSwiftUI",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "GoodSwiftUI",
            targets: ["GoodSwiftUI", "GRAsyncImage", "GRInputField", "GRToggle", "GRButton"]
        ),
        .library(
            name: "GRAsyncImage",
            targets: ["GRAsyncImage"]
        ),
        .library(
            name: "GRInputField",
            targets: ["GRInputField"]
        ),
        .library(
            name: "GRToggle",
            targets: ["GRToggle"]
        ),
        .library(
            name: "GRButton",
            targets: ["GRButton"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/GoodRequest/GoodExtensions-iOS.git", .upToNextMajor(from: "2.0.2"))
    ],
    targets: [
        .target(
            name: "GoodSwiftUI",
            dependencies: [],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "GRAsyncImage",
            dependencies: [
                .product(name: "GoodExtensions", package: "GoodExtensions-iOS"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "GRInputField",
            dependencies: [
                .product(name: "GoodExtensions", package: "GoodExtensions-iOS"),
                .product(name: "GoodStructs", package: "GoodExtensions-iOS")
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "GRToggle",
            dependencies: [
                .product(name: "GoodExtensions", package: "GoodExtensions-iOS"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "GRButton",
            dependencies: [
                .product(name: "GoodExtensions", package: "GoodExtensions-iOS"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "GoodSwiftUITests",
            dependencies: ["GoodSwiftUI"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
    ]
)
