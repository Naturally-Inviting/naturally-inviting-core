#if os(iOS)
import Dependencies
import Foundation
import HealthKit

extension WorkoutSessionClient: DependencyKey {
    public static var liveValue: WorkoutSessionClient {
        let actor = WorkoutSessionActor()

        return WorkoutSessionClient(
            requestStoreAuthorization: { samples, objects in
                try await actor.requestStoreAuthorization(sharedSamples: samples, readSamples: objects)
            },
            statusForAuthorizationRequest: { samples, objects in
                try await actor.statusForAuthorizationRequest(toShare: samples, read: objects)
            }
        )
    }
}

final actor WorkoutSessionActor {
    let healthStore = HKHealthStore()
    
    func requestStoreAuthorization(sharedSamples: Set<HKSampleType>, readSamples: Set<HKObjectType>) async throws {
        try await healthStore.requestAuthorization(toShare: sharedSamples, read: readSamples)
    }
    
    func statusForAuthorizationRequest(toShare: Set<HKSampleType>, read: Set<HKObjectType>) async throws -> HKAuthorizationRequestStatus {
        try await healthStore.statusForAuthorizationRequest(toShare: toShare, read: read)
    }
}
#endif
