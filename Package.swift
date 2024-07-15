// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "naturally-inviting-core",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .macOS(.v14)
    ],
    products: [
        .library(name: "AppRatingFeature", targets: ["AppRatingFeature"]),
        .library(name: "ATTrackingManagerClient", targets: ["ATTrackingManagerClient"]),
        .library(name: "ComposableCoreLocation", targets: ["ComposableCoreLocation"]),
        .library(name: "ComposableCoreMotion", targets: ["ComposableCoreMotion"]),
        .library(name: "ComposableStoreKit", targets: ["ComposableStoreKit"]),
        .library(name: "CoreDataClient", targets: ["CoreDataClient"]),
        .library(name: "CryptoClient", targets: ["CryptoClient"]),
        .library(name: "FeedbackGeneratorClient", targets: ["FeedbackGeneratorClient"]),
        .library(name: "HealthKitClient", targets: ["HealthKitClient"]),
        .library(name: "NaturalDesignSystem", targets: ["NaturalDesignSystem"]),
        .library(name: "NaturalExtensions", targets: ["NaturalExtensions"]),
        .library(name: "NotificationCenterClient", targets: ["NotificationCenterClient"]),
        .library(name: "SnapshotTestSupport", targets: ["SnapshotTestSupport"]),
        .library(name: "SwiftDataProvider", targets: ["SwiftDataProvider"]),
        .library(name: "UIApplicationClient", targets: ["UIApplicationClient"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
        .library(name: "WatchConnectivityClient", targets: ["WatchConnectivityClient"]),
        .library(name: "WidgetCenterClient", targets: ["WidgetCenterClient"]),
        .library(name: "WKInterfaceDeviceClient", targets: ["WKInterfaceDeviceClient"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.11.2"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.17.2"
        ),
        .package(
            url: "https://github.com/Naturally-Inviting/swift-tca-custom-alert",
            from: "0.0.2"
        )
    ],
    targets: [
        .target(
            name: "AppRatingFeature",
            dependencies: [
                "ComposableStoreKit",
                "NaturalDesignSystem",
                "UserDefaultsClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "TCACustomAlert", package: "swift-tca-custom-alert")
            ]
        ),
        .target(
            name: "ATTrackingManagerClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "ComposableCoreLocation",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "ComposableCoreMotion",
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
            name: "NaturalDesignSystem",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "NaturalExtensions"
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
        ),
        .target(
            name: "WidgetCenterClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "WKInterfaceDeviceClient",
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
