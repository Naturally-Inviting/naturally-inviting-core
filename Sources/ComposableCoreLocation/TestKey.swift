import ComposableArchitecture

extension DependencyValues {
    public var coreLocation: ComposableCoreLocation {
        get { self[ComposableCoreLocation.self] }
        set { self[ComposableCoreLocation.self] = newValue }
    }
}

extension ComposableCoreLocation: TestDependencyKey {
    public static var testValue: ComposableCoreLocation {
        ComposableCoreLocation(
            initialize: unimplemented("\(Self.self).initialize"),
            requestWhenInUseAuthorization: unimplemented("\(Self.self).requestWhenInUseAuthorization", placeholder: .notDetermined),
            location: unimplemented("\(Self.self).location"),
            geolocateLocation: unimplemented("\(Self.self).geolocateLocation")
        )
    }

    public static var previewValue: ComposableCoreLocation {
        ComposableCoreLocation(
            initialize: {},
            requestWhenInUseAuthorization: { .authorizedWhenInUse },
            location: {
                .init(
                    latitude: 42.4311,
                    longitude: -83.4833
                )
            },
            geolocateLocation: { _ in "Northville" }
        )
    }
}
