//
//  Persistence.swift
//  SchoolManagement
//
//  Updated to use SchoolManagement.xcdatamodeld for the Core Data model.
//

import Foundation
internal import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    static let preview: PersistenceController = {
        PersistenceController(inMemory: true)
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Load the compiled model from SchoolManagement.xcdatamodeld
        container = NSPersistentContainer(name: "SchoolManagement")

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        } else if let description = container.persistentStoreDescriptions.first {
            // Enable automatic lightweight migration from the previous programmatic model
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        } else {
            let description = NSPersistentStoreDescription()
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveContext() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
}
