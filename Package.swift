// swift-tools-version:5.9
import PackageDescription
import Foundation

// Detect build configuration from environment variable set by Xcode
// Xcode sets CONFIGURATION=Release/Debug automatically
let configuration = ProcessInfo.processInfo.environment["CONFIGURATION"] ?? "Debug"
let useBinary: Bool = configuration.lowercased().contains("release")

let package = Package(
    name: "CommonSwiftUI",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "CommonSwiftUI",
            targets: [useBinary ? "CommonSwiftUIBinary" : "CommonSwiftUISource"]
        ),
    ],
    targets: [
        // Source target for development
        .target(
            name: "CommonSwiftUISource",
            path: "./Sources/CommonSwiftUI"
        ),
        
        // Binary target for release / archive
        .binaryTarget(
            name: "CommonSwiftUIBinary",
            path: "./Sources/CommonSwiftUI.xcframework"
        )
    ]
)
