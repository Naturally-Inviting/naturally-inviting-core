import Foundation
import WatchConnectivity

public struct WatchConnectivityClient {
    public enum Delegate {
        case activationDidComplete(session: WCSession, activationState: WCSessionActivationState)
        case didReceiveMessage(session: WCSession, message: [String: Any])
        case didReceiveMessageData(session: WCSession, message: Data)
        case didReceiveApplicationContext(session: WCSession, context: [String: Any])
        case sessionDidBecomeInactive(session: WCSession)
        case sessionDidDeactivate(session: WCSession)
        case sessionWatchStateDidChange(session: WCSession)
    }

    public var activate: @Sendable () async throws -> Void
    public var delegate: @Sendable () async -> AsyncStream<Delegate>
    public var sendMessage: @Sendable (_ message: [String: Any]) async -> Void
    public var sendCodableMessage: @Sendable (_ message: any Encodable) async throws -> Void
    public var sendApplicationContext: @Sendable (_ message: [String: Any]) async throws -> Void
}
