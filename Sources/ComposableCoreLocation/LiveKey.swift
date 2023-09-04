import ComposableArchitecture
import CoreLocation

extension ComposableCoreLocation: DependencyKey {
    public enum LocationError: Error {
        case locationFailed
        case geocodeFailed
    }

    public static var liveValue: ComposableCoreLocation {
        let locationManager = LocationDelegate()

        return ComposableCoreLocation(
            initialize: {
                await locationManager.initialize()
            },
            requestWhenInUseAuthorization: {
                let value = await withCheckedContinuation { continuation in
                    locationManager.authContinuation = continuation
                    locationManager.manager.requestWhenInUseAuthorization()
                }

                return LocationAuthorizationStatus.init(status: value)
            },
            location: {
                if let location = locationManager.location {
                    return .init(locality: locationManager.lastKnownLocality ?? "", location: location)
                }

                let value = try await withCheckedThrowingContinuation { continuation in
                    locationManager.locationUpdateContinuation = continuation
                    locationManager.manager.requestLocation()
                }

                guard let location = value.first
                else { throw LocationError.locationFailed }

                let geocodeResult = try await locationManager.geocoder.reverseGeocodeLocation(location)

                guard let city = geocodeResult.first?.locality
                else { throw LocationError.geocodeFailed }

                locationManager.lastKnownLocality = city

                return Location(locality: city, location: location)
            }
        )
    }
}

public typealias AuthotizationContinuation = CheckedContinuation<CLAuthorizationStatus, Never>
public typealias LocationOnceContinuation = CheckedContinuation<[CLLocation], Error>

final internal class LocationDelegate: NSObject, CLLocationManagerDelegate {
    var manager: CLLocationManager!
    var geocoder: CLGeocoder!
    var authContinuation: AuthotizationContinuation?
    var locationUpdateContinuation: LocationOnceContinuation?
    var lastKnownLocality: String?
    var location: CLLocation?

    func initialize() async {
        await MainActor.run {
            self.manager = CLLocationManager()
            self.geocoder = CLGeocoder()
            self.manager.desiredAccuracy = kCLLocationAccuracyKilometer
            self.manager.delegate = self
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authContinuation?.resume(returning: manager.authorizationStatus)
        authContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
        locationUpdateContinuation?.resume(returning: locations)
        locationUpdateContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationUpdateContinuation?.resume(throwing: error)
        locationUpdateContinuation = nil
    }
}
