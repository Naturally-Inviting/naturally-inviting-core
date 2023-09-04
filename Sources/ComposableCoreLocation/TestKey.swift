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
            requestWhenInUseAuthorization: unimplemented("\(Self.self).requestWhenInUseAuthorization"),
            location: unimplemented("\(Self.self).location")
        )
    }

    public static var previewValue: ComposableCoreLocation {
        ComposableCoreLocation(
            initialize: {},
            requestWhenInUseAuthorization: { .authorizedWhenInUse },
            location: {
                .init(
                    locality: "Northville",
                    latitude: 42.4311,
                    longitude: -83.4833
                )
            }
        )
    }
}
