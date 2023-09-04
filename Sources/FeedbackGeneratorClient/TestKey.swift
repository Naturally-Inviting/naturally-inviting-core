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
