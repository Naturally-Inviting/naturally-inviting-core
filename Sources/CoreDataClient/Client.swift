import CoreData
import Foundation

public struct CoreDataClient {
    public var container: () async -> NSPersistentContainer
    public var viewContext: () async -> NSManagedObjectContext
    public var newBackgroundContext: () async -> NSManagedObjectContext

    public init(
        container: @escaping () async -> NSPersistentContainer,
        viewContext: @escaping () async -> NSManagedObjectContext,
        newBackgroundContext: @escaping () async -> NSManagedObjectContext
    ) {
        self.container = container
        self.viewContext = viewContext
        self.newBackgroundContext = newBackgroundContext
    }
}
