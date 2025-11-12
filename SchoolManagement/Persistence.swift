//
//  Persistence.swift
//  SchoolManagement
//
//  Created by Assistant on 05/11/25.
//

import Foundation
import CoreData

// A lightweight Core Data stack with a programmatic model containing `User` and `Admin` entities.
// This avoids the need for an .xcdatamodeld file and keeps the sample self-contained.
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Define the model programmatically with one entity: User (email, password)
        let model = NSManagedObjectModel()

        let userEntity = NSEntityDescription()
        userEntity.name = "User"
        userEntity.managedObjectClassName = NSStringFromClass(User.self) // Ensures correct module-qualified class name

        let emailAttr = NSAttributeDescription()
        emailAttr.name = "email"
        emailAttr.attributeType = .stringAttributeType
        emailAttr.isOptional = false

        let passwordAttr = NSAttributeDescription()
        passwordAttr.name = "password"
        passwordAttr.attributeType = .stringAttributeType
        passwordAttr.isOptional = false

        userEntity.properties = [emailAttr, passwordAttr]

        let adminEntity = NSEntityDescription()
        adminEntity.name = "Admin"
        adminEntity.managedObjectClassName = NSStringFromClass(Admin.self)

        let adminUsernameAttr = NSAttributeDescription()
        adminUsernameAttr.name = "username"
        adminUsernameAttr.attributeType = .stringAttributeType
        adminUsernameAttr.isOptional = false

        let adminPasswordAttr = NSAttributeDescription()
        adminPasswordAttr.name = "password"
        adminPasswordAttr.attributeType = .stringAttributeType
        adminPasswordAttr.isOptional = false

        adminEntity.properties = [adminUsernameAttr, adminPasswordAttr]

        model.entities = [userEntity, adminEntity]

        container = NSPersistentContainer(name: "SchoolManagement", managedObjectModel: model)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
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
