public struct FeedbackGeneratorClient {
    public var prepare: @Sendable () async -> Void
    public var impactOccurred: @Sendable () async -> Void
}
