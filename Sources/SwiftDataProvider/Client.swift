#if canImport(SwiftData)
import SwiftData

@available(iOS 17, *)
@available(watchOS 10, *)
public struct SwiftDataClient {
    public var container: () -> ModelContainer
}

@available(iOS 17, *)
@available(watchOS 10, *)
public class SwiftDataProvider {
    var modelContainer: ModelContainer

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
            cloudKitDatabase: .automatic
        )

        do {
            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
#endif
