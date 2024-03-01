import Dependencies
import UIKit
#if canImport(WatchKit)
import WatchKit
#endif

// swiftformat:disable indent
extension FeedbackGeneratorClient: DependencyKey {
    #if os(iOS)
    public static let liveValue = {
        let generator = UIImpactFeedbackGenerator.init(style: .medium)
        return Self(
            prepare: { await generator.prepare() },
            impactOccurred: { await generator.impactOccurred(intensity: 1) }
        )
    }()
    #else
    public static let liveValue = Self.noop
    #endif
}

#if os(iOS)
extension NotificationFeedbackGeneratorClient: DependencyKey {
    public static var liveValue: NotificationFeedbackGeneratorClient {
        NotificationFeedbackGeneratorClient(
            notificationOccurred: {
                let generator = await UINotificationFeedbackGenerator()
                await generator.notificationOccurred($0)
            }
        )
    }
}
#endif

#if os(watchOS)
extension WatchHapticType {
    var wkHaptic: WKHapticType {
        return WKHapticType(rawValue: self.rawValue) ?? .notification
    }
}

extension WatchFeedbackGenerator: DependencyKey {
    public static var liveValue: WatchFeedbackGenerator {
        WatchFeedbackGenerator(
            impactOccurred: { type in
                WKInterfaceDevice.current().play(type.wkHaptic)
            }
        )
    }
}
#endif
