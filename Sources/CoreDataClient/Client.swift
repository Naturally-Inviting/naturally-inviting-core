import CoreData
import Foundation

public struct CoreDataClient {
    public var container: NSPersistentContainer
    public var viewContext: NSManagedObjectContext
    public var newBackgroundContext: NSManagedObjectContext

    public init(
        container: NSPersistentContainer,
        viewContext: NSManagedObjectContext,
        newBackgroundContext: NSManagedObjectContext
    ) {
        self.container = container
        self.viewContext = viewContext
        self.newBackgroundContext = newBackgroundContext
    }
}
