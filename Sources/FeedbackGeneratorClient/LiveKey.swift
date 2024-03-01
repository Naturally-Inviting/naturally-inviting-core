import Dependencies
import UIKit

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
