// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-issue-reporting",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Issue Reporting", targets: ["Issue Reporting"]),
        .library(name: "Issue Reporting Apple Testing", targets: ["Issue Reporting Apple Testing"]),
    ],
    traits: [
        .trait(name: "AppleTesting", description: "Records reported issues into Apple's Swift Testing")
    ],
    dependencies: [
        .package(url: "https://github.com/swift-molecules/swift-test.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-source.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-loader.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-environment.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-test-apple.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Issue Reporting",
            dependencies: [
                .product(name: "Test", package: "swift-test"),
                .product(name: "Source", package: "swift-source"),
                .product(name: "Loader", package: "swift-loader"),
                .product(name: "Environment", package: "swift-environment"),
            ]
        ),
        .target(
            name: "Issue Reporting Apple Testing",
            dependencies: [
                .target(name: "Issue Reporting"),
                .product(name: "Test", package: "swift-test"),
                .product(name: "Test Apple", package: "swift-test-apple", condition: .when(traits: ["AppleTesting"])),
            ]
        ),
        .testTarget(
            name: "Issue Reporting Tests",
            dependencies: [
                .target(name: "Issue Reporting"),
                .target(name: "Issue Reporting Apple Testing"),
                .product(name: "Test", package: "swift-test"),
                .product(name: "Source", package: "swift-source"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .strictMemorySafety(),
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
            .enableUpcomingFeature("InferIsolatedConformances"),
            .enableExperimentalFeature("Lifetimes"),
            .treatAllWarnings(as: .error),
        ]
}
