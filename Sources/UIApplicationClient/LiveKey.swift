#if os(iOS)
import Dependencies
import UIKit

extension UIApplicationClient: DependencyKey {
    public static var liveValue: UIApplicationClient {
        Self(
            open: { @MainActor in await UIApplication.shared.open($0, options: $1) },
            canOpen: { url in
                await UIApplication.shared.canOpenURL(url)
            },
            endEditing: {
                await UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            },
            openSettingsURLString: { await UIApplication.openSettingsURLString },
            setApplicationIconBadgeNumber: { badgeNumber in
                await MainActor.run {
                    UIApplication.shared.applicationIconBadgeNumber = badgeNumber
                }
            }
        )
    }
}
#endif
