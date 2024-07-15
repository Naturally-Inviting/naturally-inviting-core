#if canImport(WatchKit)
import Dependencies
import WatchKit

extension WKInterfaceDeviceClient: DependencyKey {
    public static var liveValue: WKInterfaceDeviceClient {
        WKInterfaceDeviceClient(
            wristLocation: {
                WristLocation(WKInterfaceDevice.current().wristLocation)
            }
        )
    }
}
#endif
