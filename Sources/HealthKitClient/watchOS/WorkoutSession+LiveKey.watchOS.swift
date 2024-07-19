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
            
            do {
                session = try HKWorkoutSession(
                    healthStore: healthStore,
                    configuration: configuration
                )
            } catch {
                session = nil
                print(error)
            }

            builder = session.associatedWorkoutBuilder()

            session.delegate = self
            builder.delegate = self

            builder!.dataSource = HKLiveWorkoutDataSource(
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
            if toState == .ended {
                Task {
                    try await builder.endCollection(at: date)
                    
                    guard let workout = try await builder.finishWorkout() else { return }
                    
                    self.continuation?.yield(.didSaveWorkout(uuid: workout.uuid))
                    self.continuation?.yield(.workoutSessionDidChange(toState: toState, fromState: fromState))
                }
            } else {
                self.continuation?.yield(.workoutSessionDidChange(toState: toState, fromState: fromState))
            }
        }

        func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
            self.continuation?.yield(.sessionDidFail)
        }

        func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
            guard session.state == .running else { return }
            for type in collectedTypes {
                guard let quantityType = type as? HKQuantityType else { return }

                let statistics = builder.statistics(for: quantityType)
                guard let statistics = statistics else { return }

                switch statistics.quantityType {
                case HKQuantityType.quantityType(forIdentifier: .heartRate):
                    let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())

                    let mostRctValue = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
                    let avgValue = statistics.averageQuantity()?.doubleValue(for: heartRateUnit)

                    let maxValue = statistics.maximumQuantity()?.doubleValue(for: heartRateUnit)
                    let minValue = statistics.minimumQuantity()?.doubleValue(for: heartRateUnit)

                    let currentHeartRate = Int(Double( round( 1 * mostRctValue! ) / 1 ))
                    let averageHeartRate = Int(Double( round( 1 * avgValue! ) / 1 ))
                    let heartRateMax = Int(Double( round( 1 * maxValue! ) / 1 ))
                    let heartRateMin = Int(Double( round( 1 * minValue! ) / 1 ))

                    continuation?.yield(
                        .didCollectData(
                            data: .heartRate(
                                sessionData: .init(
                                    currentHeartRate: currentHeartRate,
                                    heartRateAverage: averageHeartRate,
                                    heartRateMax: heartRateMax,
                                    heartRateMin: heartRateMin
                                )
                            )
                        )
                    )

                case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                    let energyUnit = HKUnit.kilocalorie()
                    let value = statistics.sumQuantity()?.doubleValue(for: energyUnit)
                    let activeCalories = Int(Double( round( 1 * value! ) / 1 ))
                    continuation?.yield(.didCollectData(data: .activeCalories(sessionData: activeCalories)))

                default:
                    return
                }
            }
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
        self.delegate = delegate
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
