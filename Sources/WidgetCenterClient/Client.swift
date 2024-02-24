import Foundation

public struct WidgetCenterClient {
    public var reloadTimelines: @Sendable (_ kind: String) -> Void
    public var reloadAllTimelines: () -> Void
}
