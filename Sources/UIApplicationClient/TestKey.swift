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
            open: XCTUnimplemented("\(Self.self).open", placeholder: false),
            canOpen: XCTUnimplemented("\(Self.self).canOpen", placeholder: false),
            endEditing: XCTUnimplemented("\(Self.self).endEditing"),
            openSettingsURLString: XCTUnimplemented("\(Self.self).openSettingsURLString"),
            setApplicationIconBadgeNumber: XCTUnimplemented("\(Self.self).setApplicationIconBadgeNumber")
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
