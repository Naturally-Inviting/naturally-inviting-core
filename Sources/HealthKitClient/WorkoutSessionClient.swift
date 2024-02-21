#if os(watchOS)
import HealthKit

public struct HeartRateSessionData {
    public var currentHeartRate: Int
    public var heartRateAverage: Int
    public var heartRateMax: Int
    public var heartRateMin: Int

    public init(
        currentHeartRate: Int,
        heartRateAverage: Int,
        heartRateMax: Int,
        heartRateMin: Int
    ) {
        self.currentHeartRate = currentHeartRate
        self.heartRateAverage = heartRateAverage
        self.heartRateMax = heartRateMax
        self.heartRateMin = heartRateMin
    }
}

extension HeartRateSessionData: Equatable {}

public struct WorkoutSessionClient {
    public enum WorkoutDataEvent: Equatable {
        case heartRate(sessionData: HeartRateSessionData)
        case activeCalories(sessionData: Int)
    }

    public enum Action: Equatable {
        case workoutSessionDidChange(toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState)
        case didCollectData(data: WorkoutDataEvent)
        case builderDidCollectEvent(HKLiveWorkoutBuilder)
        case sessionDidFail
        case didSaveWorkout(uuid: UUID)
    }

    public var requestStoreAuthorization: @Sendable (Set<HKSampleType>, Set<HKObjectType>) async throws -> Void
    public var statusForAuthorizationRequest: @Sendable (Set<HKSampleType>, Set<HKObjectType>) async throws -> HKAuthorizationRequestStatus
    public var start: @Sendable (HKWorkoutActivityType, HKWorkoutSessionLocationType) async throws -> AsyncStream<Action>
    
    public var pause: () async -> Void
    public var resume: () async -> Void
    public var end: () async -> Void
}
#endif
