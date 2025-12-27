// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CommonSwiftUI",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Source product for development and debugging
        .library(
            name: "CommonSwiftUI",
            targets: ["CommonSwiftUISource"]
        ),
        // Binary product for release builds and distribution
        .library(
            name: "CommonSwiftUIBinary",
            targets: ["CommonSwiftUIBinary"]
        ),
    ],
    targets: [
        // Source target for development
        .target(
            name: "CommonSwiftUISource",
            path: "Sources/CommonSwiftUI"
        ),
        
        // Binary target for release / archive
        .binaryTarget(
            name: "CommonSwiftUIBinary",
            path: "Sources/CommonSwiftUI.xcframework"
        )
    ]
)
