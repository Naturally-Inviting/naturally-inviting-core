import Dependencies

extension DependencyValues {
    public var watchConnectivity: WatchConnectivityClient {
        get { self[WatchConnectivityClient.self] }
        set { self[WatchConnectivityClient.self] = newValue }
    }
}

extension WatchConnectivityClient: TestDependencyKey {
    public static var testValue: WatchConnectivityClient {
        WatchConnectivityClient(
            activate: unimplemented("\(Self.self).activate"),
            delegate: unimplemented("\(Self.self).delegate"),
            sendMessage: unimplemented("\(Self.self).sendMessage"),
            sendCodableMessage: unimplemented("\(Self.self).sendCodableMessage"),
            sendApplicationContext: unimplemented("\(Self.self).sendApplicationContext")
        )
    }
}
