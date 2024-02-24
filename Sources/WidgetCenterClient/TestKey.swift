import Dependencies

public extension DependencyValues {
    var widgetCenter: WidgetCenterClient {
        get { self[WidgetCenterClient.self] }
        set { self[WidgetCenterClient.self] = newValue }
    }
}

extension WidgetCenterClient: TestDependencyKey {
    public static var noop: WidgetCenterClient {
        WidgetCenterClient(
            reloadTimelines: { _ in },
            reloadAllTimelines: {}
        )
    }

    public static var testValue: Self {
        Self(
            reloadTimelines: unimplemented("\(Self.self).reloadTimelines"),
            reloadAllTimelines: unimplemented("\(Self.self).reloadAllTimelines")
        )
    }

    public static var previewValue: WidgetCenterClient {
        .noop
    }
}
