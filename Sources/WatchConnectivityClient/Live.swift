import Dependencies
import Foundation
import os.log
import WatchConnectivity

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let watchConnectivity = Logger(subsystem: subsystem, category: "watch_connectivity")
}

extension WatchConnectivityClient: DependencyKey {
    public static var liveValue: WatchConnectivityClient {
        let session = WCSession.default
        let delegate = WatchConnectivitySessionDelegator()

        session.delegate = delegate

        return WatchConnectivityClient(
            activate: {
                guard WCSession.isSupported() else {
                    Logger.watchConnectivity.error("WCSession is not supported.")
                    return
                }

                Logger.watchConnectivity.log("WatchConnectivityClient did activate")
                session.activate()
            },
            delegate: {
                Logger.watchConnectivity.log("WatchConnectivityClient did make stream")
                let stream = AsyncStream<WatchConnectivityClient.Delegate>.makeStream()
                delegate.continuation = stream.continuation

                stream.continuation.onTermination = { _ in
                    Logger.watchConnectivity.log("WatchConnectivityClient.delegate stream terminated.")
                    delegate.continuation = nil
                }

                return stream.stream
            },
            sendMessage: { data in
                guard session.isReachable else {
                    Logger.watchConnectivity.error("WCSession is unreachable")
                    return
                }

                Logger.watchConnectivity.log("WatchConnectivityClient did send message: \(data)")
                session.sendMessage(data, replyHandler: nil)
            },
            sendCodableMessage: { data in
                guard session.isReachable else {
                    Logger.watchConnectivity.error("WCSession is unreachable")
                    return
                }

                Logger.watchConnectivity.log("WatchConnectivityClient did send message of \(String(describing: data))")
                let encoded = try JSONEncoder().encode(data)
                session.sendMessageData(encoded, replyHandler: nil)
            },
            sendApplicationContext: { context in
                Logger.watchConnectivity.log("WatchConnectivityClient did send Application Context: \(context)")
                try session.updateApplicationContext(context)
            }
        )
    }
}

final class WatchConnectivitySessionDelegator: NSObject, WCSessionDelegate {
    var continuation: AsyncStream<WatchConnectivityClient.Delegate>.Continuation?

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        Logger.watchConnectivity.log("WC Session did receive message")
        continuation?.yield(.didReceiveMessage(session: session, message: message))
    }

    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        Logger.watchConnectivity.log("WC Session did receive message data")
        continuation?.yield(.didReceiveMessageData(session: session, message: messageData))
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        Logger.watchConnectivity.log("WC Session activation did complete")
        continuation?.yield(.activationDidComplete(session: session, activationState: activationState))
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        Logger.watchConnectivity.log("WC Session did receive application context")
        continuation?.yield(.didReceiveApplicationContext(session: session, context: applicationContext))
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        Logger.watchConnectivity.log("WC Session did become inactive")
        continuation?.yield(.sessionDidBecomeInactive(session: session))
    }

    func sessionDidDeactivate(_ session: WCSession) {
        Logger.watchConnectivity.log("WC Session did deactivate")
        session.activate()
        continuation?.yield(.sessionDidDeactivate(session: session))
    }
    #endif
}
