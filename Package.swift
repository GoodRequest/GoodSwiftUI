// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GoodSwiftUI",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GoodSwiftUI",
            targets: ["GoodSwiftUI", "GRAsyncImage", "GRInputField"]
        ),
        .library(
            name: "GRAsyncImage",
            targets: ["GRAsyncImage"]
        ),
        .library(
            name: "GRInputField",
            targets: ["GRInputField"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/goodrequest/goodextensions-ios", branch: "feature/swift6")
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
            swiftSettings: [.swiftLanguageMode(.v6), .unsafeFlags(["-Onone"])]
        ),
        .testTarget(
            name: "GoodSwiftUITests",
            dependencies: ["GoodSwiftUI"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
    ]
)
