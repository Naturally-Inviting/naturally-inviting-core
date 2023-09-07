#if os(iOS) || os(tvOS)
import UIKit
#endif
import SnapshotTesting

struct SnapshotConfig {
    let adaptiveSize: AdaptiveSize
    let deviceState: DeviceState
    let viewImageConfig: ViewImageConfig
    let scale: Double
}

// All sizes needed for app store
let appStoreViewConfigs: [String: SnapshotConfig] = [
    "iPhone_5_5": .init(adaptiveSize: .medium, deviceState: .phone, viewImageConfig: .iPhone8Plus, scale: 3),
    "iPhone_6_5": .init(adaptiveSize: .large, deviceState: .phone, viewImageConfig: .iPhone13ProMax, scale: 3),
    "iPad_12_9": .init(adaptiveSize: .large, deviceState: .pad, viewImageConfig: .iPadPro12_9(.portrait), scale: 2)
]
