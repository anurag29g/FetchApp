//
//  CoreDataManager.swift
//  FetchListApp
//
//  Created by Anurag Ghadge on 10/14/24.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let context: NSManagedObjectContext

    private init(inMemory: Bool = false) {
        let modelURL = Bundle.main.url(forResource: "CachedItem", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!

        let container = NSPersistentContainer(name: "FetchListApp", managedObjectModel: managedObjectModel)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data: \(error)")
            }
        }

        context = container.viewContext
    }

    static func createInMemoryManager() -> CoreDataManager {
        return CoreDataManager(inMemory: true)
    }

    func saveContext() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    func clearData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CachedItem.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to clear data: \(error)")
        }
    }
    
}
