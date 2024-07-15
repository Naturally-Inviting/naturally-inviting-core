#if canImport(WatchKit)
import WatchKit

public enum WristLocation: Equatable, Sendable {
    case left, right
    
    init(_ location: WKInterfaceDeviceWristLocation) {
        switch location {
        case .left:
            self = .left
        case .right:
            self = .right
        @unknown default:
            fatalError("Unhandled wrist direction.")
        }
    }
}

public struct WKInterfaceDeviceClient {
    public var wristLocation: @Sendable () async -> WristLocation
}
#endif
