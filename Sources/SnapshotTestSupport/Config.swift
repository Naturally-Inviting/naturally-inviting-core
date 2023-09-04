import SnapshotTesting

struct SnapshotConfig {
    let adaptiveSize: AdaptiveSize
    let deviceState: DeviceState
    let viewImageConfig: ViewImageConfig
}

// All sizes needed for app store
let appStoreViewConfigs: [String: SnapshotConfig] = [
    "iPhone_5_5": .init(adaptiveSize: .medium, deviceState: .phone, viewImageConfig: .iPhone8Plus),
    "iPhone_6_5": .init(adaptiveSize: .large, deviceState: .phone, viewImageConfig: .iPhone13ProMax),
    "iPad_12_9": .init(adaptiveSize: .large, deviceState: .pad, viewImageConfig: .iPadPro12_9(.portrait)),
]
