// swift-tools-version:4.0
// swift package generate-xcodeproj --xcconfig-overrides config/general.xcconfig
import PackageDescription

let package = Package(
    name: "PSPDFKit.swift",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "PSPDFKitSwift",
            targets: ["PSPDFKitSwift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "PSPDFKitSwift",
            dependencies: [],
            exclude: ["Frameworks", "DerivedData", "config"]),
        .testTarget(
            name: "PSPDFKitSwiftTests",
            dependencies: ["PSPDFKitSwift"],
            exclude: ["Frameworks", "DerivedData", "config"])
    ],
    swiftLanguageVersions: [4]
)