import Foundation
import Dependencies
import CoreMotion
import os.log

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let coreMotion = Logger(subsystem: subsystem, category: "core_motion")
}

extension CoreMotionClient: DependencyKey {
    public static var liveValue: CoreMotionClient {
        @Dependency(\.date) var date
        
        let motionManager = CMMotionManager()
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
        
        // The app is using 50hz data and the buffer is going to hold 1s worth of data.
        let sampleInterval = 1.0 / 50

        return CoreMotionClient(
            isDeviceMotionActive: {
                motionManager.isDeviceMotionActive
            },
            isDeviceMotionAvailable: {
                motionManager.isDeviceMotionAvailable
            },
            startUpdates: {
                Logger.coreMotion.info("Starting motion updates.")
                
                if !motionManager.isDeviceMotionAvailable {
                    Logger.coreMotion.error("Motion data is unavailable.")
                    throw CoreMotionClientError.deviceMotionUnavailable
                }
                                
                return AsyncThrowingStream<CoreMotionClient.Action, Error> { continuation in
                    continuation.onTermination = { _ in
                        Logger.coreMotion.info("Continuation terminated.")
                        motionManager.stopDeviceMotionUpdates()
                    }
                                        
                    motionManager.deviceMotionUpdateInterval = sampleInterval
                    motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
                        if let error {
                            Logger.coreMotion.error("Motion error occured: \(error.localizedDescription)")
                            continuation.finish(throwing: CoreMotionClientError.startMotionErrorOccured(error: error))
                        }
                        
                        guard let deviceMotion else {
                            Logger.coreMotion.error("Device motion is nil.")
                            continuation.finish(throwing: CoreMotionClientError.deviceMotionNil)
                            return
                        }
                        
                        let motionData = MotionData(
                            timestamp: date.now.timeIntervalSince1970,
                            gravity: MotionData.MotionAcceleration(
                                x: deviceMotion.gravity.x,
                                y: deviceMotion.gravity.y,
                                z: deviceMotion.gravity.z
                            ),
                            userAcceleration: MotionData.MotionAcceleration(
                                x: deviceMotion.userAcceleration.x,
                                y: deviceMotion.userAcceleration.y,
                                z: deviceMotion.userAcceleration.z
                            ),
                            rotationRate: MotionData.MotionAcceleration(
                                x: deviceMotion.rotationRate.x,
                                y: deviceMotion.rotationRate.y,
                                z: deviceMotion.rotationRate.z
                            ),
                            attitude: MotionData.MotionAttitude(
                                roll: deviceMotion.attitude.roll,
                                pitch: deviceMotion.attitude.pitch,
                                yaw: deviceMotion.attitude.yaw
                            )
                        )
                        
//                        Logger.coreMotion.debug("Motion data collected: \(motionData)")
                        continuation.yield(.didUpdateMotion(data: motionData))
                    }
                }
            },
            stopUpdates: {
                if motionManager.isDeviceMotionAvailable {
                    Logger.coreMotion.info("Stopping motion updates.")
                    motionManager.stopDeviceMotionUpdates()
                } else {
                    Logger.coreMotion.info("Attempting to stop motion updates when motion in unavailable.")
                }
            }
        )
    }
}
