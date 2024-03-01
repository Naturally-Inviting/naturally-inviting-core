import UIKit

public struct FeedbackGeneratorClient {
    public var prepare: @Sendable () async -> Void
    public var impactOccurred: @Sendable () async -> Void
}

public struct NotificationFeedbackGeneratorClient {
    public var notificationOccurred: @Sendable (UINotificationFeedbackGenerator.FeedbackType) async -> Void
}
