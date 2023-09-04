#if os(iOS)
import Foundation
import UIKit

public enum AppExternalLink {
    public static let termsOfService = URL(string: "https://willb-me.vercel.app/privacy-policy")!
}

public struct UIApplicationClient {
    public var open: @Sendable (URL, [UIApplication.OpenExternalURLOptionsKey: Any]) async -> Bool
    public var canOpen: @Sendable (URL) async -> Bool
    public var endEditing: @Sendable () async -> Void
    public var openSettingsURLString: @Sendable () async -> String
    public var setApplicationIconBadgeNumber: @Sendable (_ badgeNumber: Int) async -> Void

    @discardableResult
    public func openMailToUrl(to recipient: String, subject: String? = nil, body: String? = nil) async -> Bool {
        guard let url = generateMailToUrl(to: recipient, subject: subject, body: body)
        else { return false }

        if await self.canOpen(url) {
            return await self.open(url, [:])
        }

        return false
    }
}

internal func generateMailToUrl(
    to recipient: String,
    subject: String? = nil,
    body: String? = nil
) -> URL? {
    guard var feedbackUrl = URLComponents.init(string: "mailto:\(recipient)") else {
        return nil
    }

    var queryItems: [URLQueryItem] = []
    if let subject {
        queryItems.append(URLQueryItem.init(name: "SUBJECT", value: subject))
    }

    if let body {
        queryItems.append(URLQueryItem.init(name: "BODY", value: body))
    }

    feedbackUrl.queryItems = queryItems
    return feedbackUrl.url
}

@discardableResult
func openMailToUrl(to recipient: String, subject: String? = nil, body: String? = nil) -> Bool {
    guard let url = generateMailToUrl(to: recipient, subject: subject, body: body)
    else { return false }

    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
        return true
    }

    return false
}
#endif
