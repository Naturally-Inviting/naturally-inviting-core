import Dependencies
import UIKit

// swiftformat:disable indent
extension FeedbackGeneratorClient: DependencyKey {
    #if os(iOS)
    public static let liveValue = {
        let generator = UIImpactFeedbackGenerator.init(style: .medium)
        return Self(
            prepare: { await generator.prepare() },
            impactOccurred: { await generator.impactOccurred(intensity: 1) }
        )
    }()
    #else
    public static let liveValue = Self.noop
    #endif
}
