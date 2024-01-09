#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
import Dependencies

public struct ATTrackingManagerClient {
    public var trackingAuthorizationStatus: () -> ATTrackingManager.AuthorizationStatus
    public var requestTrackingAuthorization: () async -> ATTrackingManager.AuthorizationStatus
}

extension ATTrackingManagerClient: DependencyKey {
    public static var liveValue: ATTrackingManagerClient {
        ATTrackingManagerClient(
            trackingAuthorizationStatus: {
                ATTrackingManager.trackingAuthorizationStatus
            },
            requestTrackingAuthorization: {
                await ATTrackingManager.requestTrackingAuthorization()
            }
        )
    }
}

extension ATTrackingManagerClient: TestDependencyKey {
    public static var testValue: ATTrackingManagerClient {
        ATTrackingManagerClient(
            trackingAuthorizationStatus: unimplemented(
                "\(Self.self).trackingAuthorizationStatus"
            ),
            requestTrackingAuthorization: unimplemented(
                "\(Self.self).requestTrackingAuthorization"
            )
        )
    }
}
#endif
