import UIKit

public struct FeedbackGeneratorClient {
    public var prepare: @Sendable () async -> Void
    public var impactOccurred: @Sendable () async -> Void
}
#if os(iOS)
public struct NotificationFeedbackGeneratorClient {
    public var notificationOccurred: @Sendable (UINotificationFeedbackGenerator.FeedbackType) async -> Void
}
#endif

#if os(watchOS)

public enum WatchHapticType: Int {
    case notification = 0

    case directionUp = 1

    case directionDown = 2

    case success = 3

    case failure = 4

    case retry = 5

    case start = 6

    case stop = 7

    case click = 8
}

public struct WatchFeedbackGenerator {
    public var impactOccurred: @Sendable (WatchHapticType) async -> Void
}
#endif
