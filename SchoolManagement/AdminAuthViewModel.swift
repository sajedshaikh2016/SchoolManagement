//
//  AdminAuthViewModel.swift
//  SchoolManagement
//
//  Created by Assistant on 12/11/25.
//

import Foundation
import Combine
import CoreData

@MainActor
final class AdminAuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String? = nil

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    private func validateInputs(requirePassword: Bool = true) -> Bool {
        errorMessage = nil
        let u = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let p = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !u.isEmpty else { errorMessage = "Please enter admin username"; return false }
        if requirePassword {
            guard !p.isEmpty else { errorMessage = "Please enter password"; return false }
        }
        return true
    }

    func register() async {
        guard validateInputs() else { return }

        let fetch: NSFetchRequest<Admin> = NSFetchRequest(entityName: "Admin")
        fetch.predicate = NSPredicate(format: "username ==[c] %@", username)
        fetch.fetchLimit = 1

        do {
            let existing = try context.fetch(fetch)
            guard existing.isEmpty else {
                errorMessage = "An admin with this username already exists"
                return
            }

            guard let entity = NSEntityDescription.entity(forEntityName: "Admin", in: context) else { return }
            let admin = Admin(entity: entity, insertInto: context)
            admin.username = username.trimmingCharacters(in: .whitespacesAndNewlines)
            admin.password = password // NOTE: Do not store plaintext passwords in production.

            try context.save()
            isAuthenticated = true
        } catch {
            errorMessage = "Failed to register admin. Please try again."
        }
    }

    func login() async {
        guard validateInputs() else { return }

        let fetch: NSFetchRequest<Admin> = NSFetchRequest(entityName: "Admin")
        fetch.predicate = NSPredicate(format: "username ==[c] %@ AND password == %@", username, password)
        fetch.fetchLimit = 1

        do {
            let result = try context.fetch(fetch)
            if result.first != nil {
                isAuthenticated = true
                errorMessage = nil
            } else {
                isAuthenticated = false
                errorMessage = "Invalid admin credentials"
            }
        } catch {
            isAuthenticated = false
            errorMessage = "Login failed. Please try again."
        }
    }

    func logout() {
        isAuthenticated = false
        username = ""
        password = ""
        errorMessage = nil
    }
}
