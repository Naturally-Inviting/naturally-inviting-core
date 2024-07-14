import Dependencies
import Dependencies

public extension DependencyValues {
    var coreMotion: CoreMotionClient {
        get { self[CoreMotionClient.self] }
        set { self[CoreMotionClient.self] = newValue }
    }
}

extension CoreMotionClient {
    public static var testValue: CoreMotionClient {
        CoreMotionClient(
            isDeviceMotionActive: unimplemented("\(Self.self).isDeviceMotionActive"),
            isDeviceMotionAvailable: unimplemented("\(Self.self).isDeviceMotionAvailable"),
            startUpdates: unimplemented("\(Self.self).startUpdates"),
            stopUpdates: unimplemented("\(Self.self).stopUpdates")
        )
    }
}
