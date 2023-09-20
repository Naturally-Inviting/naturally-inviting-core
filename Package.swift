// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "naturally-inviting-core",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .macOS(.v13)
    ],
    products: [
        .library(name: "ComposableCoreLocation", targets: ["ComposableCoreLocation"]),
        .library(name: "ComposableStoreKit", targets: ["ComposableStoreKit"]),
        .library(name: "CoreDataClient", targets: ["CoreDataClient"]),
        .library(name: "CryptoClient", targets: ["CryptoClient"]),
        .library(name: "FeedbackGeneratorClient", targets: ["FeedbackGeneratorClient"]),
        .library(name: "HealthKitClient", targets: ["HealthKitClient"]),
        .library(name: "NaturalExtensions", targets: ["NaturalExtensions"]),
        .library(name: "NIDesignSystem", targets: ["NIDesignSystem"]),
        .library(name: "NotificationCenterClient", targets: ["NotificationCenterClient"]),
        .library(name: "SnapshotTestSupport", targets: ["SnapshotTestSupport"]),
        .library(name: "SwiftDataProvider", targets: ["SwiftDataProvider"]),
        .library(name: "UIApplicationClient", targets: ["UIApplicationClient"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
        .library(name: "WatchConnectivityClient", targets: ["WatchConnectivityClient"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.2.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.12.0"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ComposableCoreLocation",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "ComposableStoreKit",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "CoreDataClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "CryptoClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "FeedbackGeneratorClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "HealthKitClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "NaturalExtensions"
        ),
        .target(
            name: "NIDesignSystem",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "NotificationCenterClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "SnapshotTestSupport",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
        .target(
            name: "SwiftDataProvider",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "UIApplicationClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "WatchConnectivityClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)

package.targets.append(contentsOf: [
    .testTarget(
        name: "SnapshotTests",
        dependencies: [
            "SnapshotTestSupport"
        ],
        exclude: [
            "__Snapshots__"
        ]
    )
])
