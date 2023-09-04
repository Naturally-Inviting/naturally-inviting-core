import CoreLocation

public enum LocationAuthorizationStatus: Equatable {
    case authorized
    case authorizedAlways
    case authorizedWhenInUse
    case notDetermined
    case restricted
    case denied

    init(status: CLAuthorizationStatus) {
        #if os(watchOS)
        switch status {
        case .notDetermined:
            self = .notDetermined

        case .restricted:
            self = .restricted

        case .denied:
            self = .denied

        case .authorizedAlways:
            self = .authorizedAlways

        case .authorizedWhenInUse:
            self = .authorizedWhenInUse

        @unknown default:
            self = .notDetermined
        }
        #else
        switch status {
        case .notDetermined:
            self = .notDetermined

        case .restricted:
            self = .restricted

        case .denied:
            self = .denied

        case .authorizedAlways:
            self = .authorizedAlways

        case .authorizedWhenInUse:
            self = .authorizedWhenInUse

        case .authorized:
            self = .authorized

        @unknown default:
            self = .notDetermined
        }
        #endif
    }

}

public struct Location: Equatable {
    public var locality: String
    public var latitude: Double
    public var longitude: Double

    public init(locality: String, latitude: Double, longitude: Double) {
        self.locality = locality
        self.latitude = latitude
        self.longitude = longitude
    }

    init(locality: String, location: CLLocation) {
        self.locality = locality
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}

public struct ComposableCoreLocation {
    public var initialize: () async -> Void
    public var requestWhenInUseAuthorization: () async -> LocationAuthorizationStatus
    public var location: () async throws -> Location
}
