#if canImport(WatchKit)
import Dependencies

extension DependencyValues {
    public var wkInterfaceDevice: WKInterfaceDeviceClient {
        get { self[WKInterfaceDeviceClient.self] }
        set { self[WKInterfaceDeviceClient.self] = newValue }
    }
}

extension WKInterfaceDeviceClient: TestDependencyKey {
    public static var testValue: WKInterfaceDeviceClient {
        WKInterfaceDeviceClient(
            wristLocation: unimplemented("\(Self.self).wristLocation")
        )
    }
}
#endif
