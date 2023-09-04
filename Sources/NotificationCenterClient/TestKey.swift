#if os(iOS)
import Dependencies
import NotificationCenter
import XCTestDynamicOverlay

public extension DependencyValues {
    var notificationCenterClient: NotificationCenterClient {
        get { self[NotificationCenterClient.self] }
        set { self[NotificationCenterClient.self] = newValue }
    }
}

extension NotificationCenterClient: TestDependencyKey {
    public static var testValue: NotificationCenterClient {
        Self(
            observe: { _ in AsyncStream { _ in } },
            post: unimplemented("\(Self.self).post")
        )
    }
}
#endif
