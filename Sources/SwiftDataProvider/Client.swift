#if canImport(SwiftData)
import SwiftData

@available(iOS 17, *)
@available(watchOS 10, *)
public struct SwiftDataClient {
    public var container: () -> ModelContainer

    public init(container: @escaping () -> ModelContainer) {
        self.container = container
    }
}

@available(iOS 17, *)
@available(watchOS 10, *)
public class SwiftDataProvider {
    public var modelContainer: ModelContainer

    public init(
        schema: Schema,
        isStoredInMemoryOnly: Bool,
        appGroupId: String? = nil
    ) {
        var groupContainer: ModelConfiguration.GroupContainer!
        if let appGroupId {
            groupContainer = .identifier(appGroupId)
        } else {
            groupContainer = .automatic
        }

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isStoredInMemoryOnly,
            groupContainer: groupContainer,
            cloudKitDatabase: .automatic // DO NOT RELY ON THIS FOR ICLOUD SYNC. AUTO REQUIRES THE BUNDLE FROM PROJECT.
        )

        do {
            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
#endif
