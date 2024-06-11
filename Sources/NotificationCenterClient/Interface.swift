#if os(iOS)
import Foundation
import NotificationCenter

extension NotificationCenter: @unchecked Sendable {}
extension Notification.Name: @unchecked @retroactive Sendable {}

public struct NotificationCenterClient {
    public var observe: @Sendable (Notification.Name) async -> AsyncStream<Notification.Name>
    public var post: @Sendable (Notification.Name, [AnyHashable: Any]?) -> Void
}
#endif
