#if os(iOS)
import Dependencies
import NotificationCenter

// NotificationCenter.default.notifications(named: name)
extension NotificationCenterClient: DependencyKey {
    public static var liveValue: Self {
        Self(
            observe: { name in
                var continuation: AsyncStream<Notification.Name>.Continuation!

                let stream = AsyncStream<Notification.Name> {
                    continuation = $0
                }

                Task { [continuation] in
                    for await notification in NotificationCenter.default.notifications(named: name).map(\.name) {
                        continuation?.yield(notification)
                    }
                }

                return stream
            },
            post: { name, userInfo in
                NotificationCenter.default.post(.init(name: name, userInfo: userInfo))
            }
        )
    }
}
#endif
