#if os(watchOS)
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
            },
            start: { activity, locationType in
                try await actor.start(workoutType: activity, locationType: locationType)
            },
            pause: { await actor.pause() },
            resume: { await actor.resume() },
            end: { await actor.end() }
        )
    }
}

final actor WorkoutSessionActor {
    final class Delegate: NSObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
        let healthStore = HKHealthStore()
        var session: HKWorkoutSession!
        var builder: HKLiveWorkoutBuilder!

        var continuation: AsyncStream<WorkoutSessionClient.Action>.Continuation?

        init(
            configuration: HKWorkoutConfiguration
        ) {
            super.init()

            session = try? HKWorkoutSession(
                healthStore: healthStore,
                configuration: configuration
            )

            builder = session.associatedWorkoutBuilder()

            session.delegate = self
            builder.delegate = self

            builder?.dataSource = HKLiveWorkoutDataSource(
                healthStore: healthStore,
                workoutConfiguration: configuration
            )
        }

        func workoutSession(
            _ workoutSession: HKWorkoutSession,
            didChangeTo toState: HKWorkoutSessionState,
            from fromState: HKWorkoutSessionState,
            date: Date
        ) {
            self.continuation?.yield(.workoutSessionDidChange(toState: toState, fromState: fromState))

            if toState == .ended {
                Task {
                    try await builder.endCollection(at: date)
                    try await builder.finishWorkout()
                }
            }
        }

        func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
            self.continuation?.yield(.sessionDidFail(error))
        }

        func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
            guard session.state == .running else { return }
            self.continuation?.yield(.didCollectData(workoutBuilder, collectedTypes: collectedTypes))
        }

        func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
            self.continuation?.yield(.builderDidCollectEvent(workoutBuilder))
        }
    }

    weak var delegate: Delegate?

    func requestStoreAuthorization(sharedSamples: Set<HKSampleType>, readSamples: Set<HKObjectType>) async throws {
        try await HKHealthStore().requestAuthorization(toShare: sharedSamples, read: readSamples)
    }

    func statusForAuthorizationRequest(toShare: Set<HKSampleType>, read: Set<HKObjectType>) async throws -> HKAuthorizationRequestStatus {
        try await HKHealthStore().statusForAuthorizationRequest(toShare: toShare, read: read)
    }

    func start(
        workoutType: HKWorkoutActivityType,
        locationType: HKWorkoutSessionLocationType
    ) async throws -> AsyncStream<WorkoutSessionClient.Action> {
        @Dependency(\.date) var date
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = locationType
        let delegate = Delegate(configuration: configuration)
        var continuation: AsyncStream<WorkoutSessionClient.Action>.Continuation!

        let stream = AsyncStream<WorkoutSessionClient.Action> {
            $0.onTermination = { _ in
                delegate.session.end()
            }
            continuation = $0
        }

        delegate.continuation = continuation

        delegate.session.startActivity(with: date.now)
        try await delegate.builder.beginCollection(at: date.now)

        return stream
    }

    func pause() {
        delegate?.session.pause()
    }

    func end() {
        delegate?.session.end()
    }

    func resume() {
        delegate?.session.resume()
    }
}
#endif
