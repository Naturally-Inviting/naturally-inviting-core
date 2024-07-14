import Foundation

public enum CoreMotionClientError: Error {
    case deviceMotionUnavailable
    case startMotionErrorOccured(error: Error)
    case deviceMotionNil
}

public struct MotionData: Sendable, Equatable, CustomStringConvertible {
    public struct MotionAcceleration: Sendable, Equatable, CustomStringConvertible {
        public var x: Double
        public var y: Double
        public var z: Double
        
        public var description: String {
            "x: \(x), y: \(y), z: \(z)"
        }
    }
    
    public struct MotionAttitude: Sendable, Equatable, CustomStringConvertible {
        public var roll: Double
        public var pitch: Double
        public var yaw: Double
        
        public var description: String {
            "roll: \(roll), pitch: \(pitch), yaw: \(yaw)"
        }
    }
    
    public var timestamp: TimeInterval
    public var gravity: MotionAcceleration
    public var userAcceleration: MotionAcceleration
    public var rotationRate: MotionAcceleration
    public var attitude: MotionAttitude
    
    public var description: String {
        """
        Timestamp: \(timestamp) \
        Gravity: \(gravity) \
        UserAcceleration: \(userAcceleration) \
        RotationRate: \(rotationRate) \
        Attitude: \(attitude)
        """
    }
}

public struct CoreMotionClient {
    public enum Action: Equatable {
        case didUpdateMotion(data: MotionData)
    }
    
    public var isDeviceMotionActive: @Sendable () async -> Bool
    public var isDeviceMotionAvailable: @Sendable () async -> Bool
    public var startUpdates: @Sendable () async throws -> AsyncThrowingStream<Action, Error>
    public var stopUpdates: @Sendable () async -> Void
}
