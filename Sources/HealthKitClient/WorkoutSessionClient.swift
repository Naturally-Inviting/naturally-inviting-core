#if os(watchOS)
import HealthKit

public struct WorkoutSessionClient {
    public enum Action {
        case workoutSessionDidChange(toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState)
        case didCollectData(HKLiveWorkoutBuilder, collectedTypes: Set<HKSampleType>)
        case builderDidCollectEvent(HKLiveWorkoutBuilder)
        case sessionDidFail(Error)
    }

    public var requestStoreAuthorization: @Sendable (Set<HKSampleType>, Set<HKObjectType>) async throws -> Void
    public var statusForAuthorizationRequest: @Sendable (Set<HKSampleType>, Set<HKObjectType>) async throws -> HKAuthorizationRequestStatus
    public var start: @Sendable (HKWorkoutActivityType, HKWorkoutSessionLocationType) async throws -> AsyncStream<Action>

    public var pause: () async -> Void
    public var resume: () async -> Void
    public var end: () async -> Void
}
#endif
