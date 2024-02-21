#if os(watchOS)
import Dependencies

public extension DependencyValues {
    var workoutSession: WorkoutSessionClient {
        get { self[WorkoutSessionClient.self] }
        set { self[WorkoutSessionClient.self] = newValue }
    }
}

extension WorkoutSessionClient {
    public static var testValue: WorkoutSessionClient {
        WorkoutSessionClient(
            requestStoreAuthorization: unimplemented("\(Self.self).requestStoreAuthorization"),
            statusForAuthorizationRequest: unimplemented("\(Self.self).statusForAuthorizationRequest"),
            start: unimplemented("\(Self.self).start"),
            pause: unimplemented("\(Self.self).pause"),
            resume: unimplemented("\(Self.self).resume"),
            end: unimplemented("\(Self.self).end")
        )
    }
}
#endif
