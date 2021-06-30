

import Foundation

class PushNotificationsDataProvider {
    
    //for use with SwiftUI canvas previews
    static let preview: PushNotificationsDataProvider = {
        let provider = PushNotificationsDataProvider(echoFetcher: EchoNotificationsFetcher(), inMemory: true)
        EchoNotification.makePreviews(count: 10)
        return provider
    }()

    private let echoFetcher: EchoNotificationsFetcher
    private let inMemory: Bool
    
    init(echoFetcher: EchoNotificationsFetcher, inMemory: Bool) {
        self.echoFetcher = echoFetcher
        self.inMemory = inMemory
        //kick off persistent container upon init
        let _ = container
    }
    
    /// A persistent container to set up the Core Data stack.
    lazy var container: NSPersistentContainer = {
        /// - Tag: persistentContainer
        let container = NSPersistentContainer(name: "EchoNotifications")

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }

        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }
//
//        // Enable persistent store remote change notifications
//        /// - Tag: persistentStoreRemoteChange
//        description.setOption(true as NSNumber,
//                              forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
//
//        // Enable persistent history tracking
//        /// - Tag: persistentHistoryTracking
//        description.setOption(true as NSNumber,
//                              forKey: NSPersistentHistoryTrackingKey)

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.name = "viewContext"
        //do we need this?
        //container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    /// Creates and configures a private queue context.
    lazy var backgroundContext: NSManagedObjectContext = {
        // Create a private queue context.
        let taskContext = container.newBackgroundContext()
        taskContext.automaticallyMergesChangesFromParent = true
        taskContext.name = "backgroundContext"
        //do we need this?
        //taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return taskContext
    }()
    
    func fetchNotifications(completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard !inMemory else {
            return
        }
        
        let moc = backgroundContext
        echoFetcher.fetchNotifications { result in
            switch result {
            case .success(let remoteNotifications):
                for remoteNotification in remoteNotifications {
                    let _ = EchoNotification.init(remoteNotification: remoteNotification, moc: moc)
                }
                
                do {
                    try self.save(moc: moc)
                    completion(.success(()))
                } catch (let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        
        }
    }
    
    func save(moc: NSManagedObjectContext) throws {
        guard moc.hasChanges else {
            return
        }
        
        try moc.save()
    }
}
