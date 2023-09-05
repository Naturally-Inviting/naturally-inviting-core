import CoreData
import Dependencies
import Foundation

public actor CoreDataProvider {
    public private(set) var container: NSPersistentCloudKitContainer

    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    public init(name: String, model: NSManagedObjectModel, withSync: Bool, inMemory: Bool) {
        self.container = CoreDataProvider.setupCloudKitContainer(
            container: name,
            model: model,
            withSync: withSync,
            inMemory: inMemory
        )
    }

    public func setContainer(name: String, model: NSManagedObjectModel, withSync: Bool, inMemory: Bool) async {
        #if os(watchOS)
        self.container = CoreDataProvider.setupCloudKitContainer(
            container: name,
            model: model,
            withSync: withSync,
            inMemory: inMemory
        )
        #else
        let cloudSync = NSUbiquitousKeyValueStore.default.bool(forKey: "iCloudSyncKey")
        self.container = CoreDataProvider.setupCloudKitContainer(
            container: name,
            model: model,
            withSync: cloudSync,
            inMemory: inMemory
        )
        #endif
    }

    internal static func setupCloudKitContainer(container name: String, model: NSManagedObjectModel, withSync: Bool, inMemory: Bool = false) -> NSPersistentCloudKitContainer {
        let container = NSPersistentCloudKitContainer(name: name, managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }

        print("cloudkit container identifier : \(description.cloudKitContainerOptions?.containerIdentifier ?? "")")

        description.setOption(true as NSNumber,
                              forKey: NSPersistentHistoryTrackingKey)

        description.setOption(true as NSNumber,
                              forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        if !withSync {
            description.cloudKitContainerOptions = nil
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        container.viewContext.automaticallyMergesChangesFromParent = true

        return container
    }
}
