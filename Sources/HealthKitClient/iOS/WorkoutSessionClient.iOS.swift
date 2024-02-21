#if os(iOS)
import HealthKit

public struct WorkoutSessionClient {
    public var requestStoreAuthorization: @Sendable (_ toShare: Set<HKSampleType>, _ read: Set<HKObjectType>) async throws -> Void
    public var statusForAuthorizationRequest: @Sendable (_ toShare: Set<HKSampleType>, _ read: Set<HKObjectType>) async throws -> HKAuthorizationRequestStatus
}
#endif
