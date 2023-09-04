import CoreData
import Foundation

public struct CoreDataClient {
    public var container: NSPersistentContainer
    public var viewContext: NSManagedObjectContext
    public var newBackgroundContext: NSManagedObjectContext
}
