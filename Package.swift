// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CommonSwiftUI",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Source product for development and debugging
        // Use: import CommonSwiftUI
        .library(
            name: "CommonSwiftUI",
            targets: ["CommonSwiftUI"]
        ),
        // Binary product for release builds and distribution
        // Use: import CommonSwiftUI (same module name)
        .library(
            name: "CommonSwiftUIBinary",
            targets: ["CommonSwiftUIBinary"]
        ),
    ],
    targets: [
        // Source target for development
        // Module name: CommonSwiftUI
        .target(
            name: "CommonSwiftUI",
            path: "Sources/CommonSwiftUI"
        ),
        
        // Binary target for release / archive
        // Module name: CommonSwiftUI (from xcframework)
        .binaryTarget(
            name: "CommonSwiftUIBinary",
            path: "Sources/CommonSwiftUI.xcframework"
        )
    ]
)
