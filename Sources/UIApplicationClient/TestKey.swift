#if os(iOS)
import Dependencies
import UIKit
import XCTestDynamicOverlay

public extension DependencyValues {
    var uiApplication: UIApplicationClient {
        get { self[UIApplicationClient.self] }
        set { self[UIApplicationClient.self] = newValue }
    }
}

extension UIApplicationClient: TestDependencyKey {
    public static var testValue: UIApplicationClient {
        Self(
            open: unimplemented("\(Self.self).open", placeholder: false),
            canOpen: unimplemented("\(Self.self).canOpen", placeholder: false),
            endEditing: unimplemented("\(Self.self).endEditing"),
            openSettingsURLString: unimplemented("\(Self.self).openSettingsURLString", placeholder: ""),
            setApplicationIconBadgeNumber: unimplemented("\(Self.self).setApplicationIconBadgeNumber")
        )
    }

    public static var previewValue: UIApplicationClient {
        Self(
            open: { _, _ in true },
            canOpen: { _ in true },
            endEditing: {},
            openSettingsURLString: { "" },
            setApplicationIconBadgeNumber: { _ in }
        )
    }
}
#endif
