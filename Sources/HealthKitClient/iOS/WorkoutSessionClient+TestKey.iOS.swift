#if os(iOS)
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
            statusForAuthorizationRequest: unimplemented("\(Self.self).statusForAuthorizationRequest")
        )
    }
}
#endif
