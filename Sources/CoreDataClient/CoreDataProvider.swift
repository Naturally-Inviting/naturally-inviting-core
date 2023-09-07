import CoreData
import Dependencies
import Foundation
import os.log

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let coreData = Logger(subsystem: subsystem, category: "core_data_stack")
}

public class CoreDataProvider {
    public private(set) var container: NSPersistentCloudKitContainer

    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    public init(
        name: String,
        appGroup: String? = nil,
        iCloudIdentifier: String,
        model: NSManagedObjectModel,
        withSync: Bool,
        inMemory: Bool
    ) {
        self.container = CoreDataProvider.setupCloudKitContainer(
            container: name,
            iCloudIdentifier: iCloudIdentifier,
            appGroup: appGroup,
            model: model,
            withSync: withSync,
            inMemory: inMemory
        )
    }

    public func setContainer(
        name: String,
        iCloudIdentifier: String,
        appGroup: String? = nil,
        model: NSManagedObjectModel,
        withSync: Bool,
        inMemory: Bool
    ) async {
        #if os(watchOS)
        self.container = CoreDataProvider.setupCloudKitContainer(
            container: name,
            iCloudIdentifier: iCloudIdentifier,
            appGroup: appGroup,
            model: model,
            withSync: withSync,
            inMemory: inMemory
        )
        #else
        let cloudSync = NSUbiquitousKeyValueStore.default.bool(forKey: "iCloudSyncKey")
        self.container = CoreDataProvider.setupCloudKitContainer(
            container: name,
            iCloudIdentifier: iCloudIdentifier,
            appGroup: appGroup,
            model: model,
            withSync: cloudSync,
            inMemory: inMemory
        )
        #endif
    }

    /// https://stackoverflow.com/questions/61856106/migrating-data-to-app-groups-disables-icloud-syncing
    internal static func setupCloudKitContainer(
        container name: String,
        iCloudIdentifier: String,
        appGroup: String? = nil,
        model: NSManagedObjectModel,
        withSync: Bool,
        inMemory: Bool = false
    ) -> NSPersistentCloudKitContainer {
        let container = NSPersistentCloudKitContainer(name: name, managedObjectModel: model)

        if let appGroup {
            let url = URL.storeURL(for: appGroup, databaseName: name)
            let storeDescription = NSPersistentStoreDescription(url: url)
            storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: iCloudIdentifier)
            container.persistentStoreDescriptions = [storeDescription]
        }

        if inMemory {
            Logger.coreData.debug("Initialized in Memory")
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }

        Logger.coreData.debug("CloudKit container details: \(description, privacy: .sensitive)")

        description.setOption(
            true as NSNumber,
            forKey: NSPersistentHistoryTrackingKey
        )

        description.setOption(
            true as NSNumber,
            forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
        )

        if !withSync {
            Logger.coreData.debug("Disabling iCloud Sync")
            description.cloudKitContainerOptions = nil
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                Logger.coreData.debug("loadPersistentStores did succeed")
            }
        })

        Logger.coreData.debug("Setting viewContext.automaticallyMergesChangesFromParent")
        Task {
            await MainActor.run {
                container.viewContext.automaticallyMergesChangesFromParent = true
                container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            }
        }
        Logger.coreData.debug("Did initialize container")
        return container
    }
}

extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)
        else { fatalError("Unable to create URL for \(appGroup)") }

        return fileContainer.appending(component: "\(databaseName).sqlite")
    }
}
