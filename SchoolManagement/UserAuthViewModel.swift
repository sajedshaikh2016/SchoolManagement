//
//  UserAuthViewModel.swift
//  SchoolManagement
//
//  Created by Assistant on 05/11/25.
//

import Foundation
import Combine
internal import CoreData

@MainActor
final class UserAuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated: Bool = false

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    // Basic email/password validation
    private func validateInputs(requirePassword: Bool = true) -> Bool {
        errorMessage = nil
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty else { errorMessage = "Please enter email"; return false }
        if requirePassword {
            guard !trimmedPassword.isEmpty else { errorMessage = "Please enter password"; return false }
        }
        // very simple email format check
        guard trimmedEmail.contains("@"), trimmedEmail.contains(".") else { errorMessage = "Please enter a valid email"; return false }
        return true
    }

    func register() async {
        guard validateInputs() else { return }

        // Check if user already exists
        let fetch: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
        fetch.predicate = NSPredicate(format: "email ==[c] %@", email)
        fetch.fetchLimit = 1

        do {
            let existing = try context.fetch(fetch)
            guard existing.isEmpty else {
                errorMessage = "An account with this email already exists"
                return
            }

            // Create new user
            guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else { return }
            let user = User(entity: entity, insertInto: context)
            user.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            user.password = password // In production, NEVER store plain passwords.

            try context.save()
            // Auto-login after registration
            isAuthenticated = true
        } catch {
            errorMessage = "Failed to register. Please try again."
        }
    }

    func login() async {
        guard validateInputs() else { return }

        let fetch: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
        fetch.predicate = NSPredicate(format: "email ==[c] %@ AND password == %@", email, password)
        fetch.fetchLimit = 1

        do {
            let result = try context.fetch(fetch)
            if let _ = result.first {
                isAuthenticated = true
                errorMessage = nil
            } else {
                isAuthenticated = false
                errorMessage = "Incorrect email or password"
            }
        } catch {
            isAuthenticated = false
            errorMessage = "Login failed. Please try again."
        }
    }

    func logout() {
        // Reset authentication state and clear sensitive fields
        isAuthenticated = false
        email = ""
        password = ""
        errorMessage = nil
    }
}
