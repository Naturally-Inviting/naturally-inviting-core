import Dependencies
import WidgetKit

extension WidgetCenterClient: DependencyKey {
    public static var liveValue: WidgetCenterClient {
        WidgetCenterClient(
            reloadTimelines: {
                WidgetCenter.shared.reloadTimelines(ofKind: $0)
            },
            reloadAllTimelines: {
                WidgetCenter.shared.reloadAllTimelines()
            }
        )
    }
}
