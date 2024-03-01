import Dependencies
import XCTestDynamicOverlay

public extension DependencyValues {
    var feedbackGenerator: FeedbackGeneratorClient {
        get { self[FeedbackGeneratorClient.self] }
        set { self[FeedbackGeneratorClient.self] = newValue }
    }
}

extension FeedbackGeneratorClient: TestDependencyKey {
    public static let previewValue = Self.noop

    public static let testValue = Self(
        prepare: XCTUnimplemented("\(Self.self).prepare"),
        impactOccurred: XCTUnimplemented("\(Self.self).impactOccurred")
    )
}

public extension FeedbackGeneratorClient {
    static let noop = Self(
        prepare: {},
        impactOccurred: {}
    )
}

public extension DependencyValues {
    var notificationGenerator: NotificationFeedbackGeneratorClient {
        get { self[NotificationFeedbackGeneratorClient.self] }
        set { self[NotificationFeedbackGeneratorClient.self] = newValue }
    }
}

extension NotificationFeedbackGeneratorClient: TestDependencyKey {
    public static let previewValue = Self.noop

    public static let testValue = Self(
        notificationOccurred: XCTUnimplemented("\(Self.self).notificationOccurred")
    )
}

public extension NotificationFeedbackGeneratorClient {
    static let noop = Self(
        notificationOccurred: { _ in }
    )
}
