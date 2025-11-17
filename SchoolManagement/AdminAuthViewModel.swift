//
//  AdminAuthViewModel.swift
//  SchoolManagement
//
//  Created by Assistant on 12/11/25.
//

import Foundation
import Combine
import CoreData
import SwiftUI

@MainActor
final class AdminAuthViewModel: ObservableObject {
    // Inputs
    @Published var email: String = ""
    @Published var password: String = ""

    // Outputs
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: LocalizedStringKey? = nil
    @Published var isFormValid: Bool = false

    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context

        // Derive form validity using Combine
        Publishers.CombineLatest($email, $password)
            .map { user, pass in
                let u = user.trimmingCharacters(in: .whitespacesAndNewlines)
                let p = pass.trimmingCharacters(in: .whitespacesAndNewlines)
                return !u.isEmpty && !p.isEmpty
            }
            .removeDuplicates()
            .assign(to: &$isFormValid)
    }

    // MARK: - Public Actions (Combine-driven)
    func register() {
        errorMessage = nil

        registerPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case let .failure(error) = completion {
                    self.isAuthenticated = false
                    self.errorMessage = (error as? AuthError)?.localizedKey ?? LocalizedStringKey("admin_register_error")
                }
            } receiveValue: { [weak self] success in
                guard let self = self else { return }
                self.isAuthenticated = success
                if success { self.errorMessage = nil }
            }
            .store(in: &cancellables)
    }

    func login() {
        errorMessage = nil

        loginPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case let .failure(error) = completion {
                    self.isAuthenticated = false
                    self.errorMessage = (error as? AuthError)?.localizedKey ?? LocalizedStringKey("admin_sign_in_error")
                }
            } receiveValue: { [weak self] success in
                guard let self = self else { return }
                self.isAuthenticated = success
                if success { self.errorMessage = nil }
            }
            .store(in: &cancellables)
    }

    func logout() {
        isAuthenticated = false
        email = ""
        password = ""
        errorMessage = nil
    }
}

// MARK: - Private
private extension AdminAuthViewModel {
    enum AuthError: LocalizedError, Equatable {
        case invalidInput(String)
        case duplicateEmail
        case invalidCredentials
        case underlying(Error)

        var localizedKey: LocalizedStringKey {
            switch self {
            case .invalidInput(let message):
                return LocalizedStringKey(message)
            case .duplicateEmail:
                return LocalizedStringKey("admin_duplicate_account_error")
            case .invalidCredentials:
                return LocalizedStringKey("admin_incorrect_credentials_error")
            case .underlying:
                return LocalizedStringKey("admin_unknown_error")
            }
        }

        static func == (lhs: AuthError, rhs: AuthError) -> Bool {
            switch (lhs, rhs) {
            case (.invalidInput(let lMsg), .invalidInput(let rMsg)):
                return lMsg == rMsg
            case (.duplicateEmail, .duplicateEmail):
                return true
            case (.invalidCredentials, .invalidCredentials):
                return true
            case (.underlying(let lErr), .underlying(let rErr)):
                // Compare by localizedDescription to avoid requiring Error to be Equatable
                return (lErr as NSError).domain == (rErr as NSError).domain
                    && (lErr as NSError).code == (rErr as NSError).code
                    && lErr.localizedDescription == rErr.localizedDescription
            default:
                return false
            }
        }
    }

    func validateInputs(requirePassword: Bool = true) -> AuthError? {
        let u = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let p = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !u.isEmpty else { return .invalidInput("admin_enter_email_error") }
        if requirePassword {
            guard !p.isEmpty else { return .invalidInput("admin_enter_password_error") }
        }
        return nil
    }

    func registerPublisher() -> AnyPublisher<Bool, Error> {
        Deferred { [weak self] () -> Future<Bool, Error> in
            guard let self = self else { return Future { $0(.failure(AuthError.underlying(NSError()))) } }
            return Future { promise in
                if let error = self.validateInputs() {
                    promise(.failure(error))
                    return
                }

                // Core Data work on the context's queue
                self.context.perform {
                    let fetch: NSFetchRequest<Admin> = NSFetchRequest(entityName: "Admin")
                    fetch.predicate = NSPredicate(format: "email ==[c] %@", self.email)
                    fetch.fetchLimit = 1

                    do {
                        let existing = try self.context.fetch(fetch)
                        guard existing.isEmpty else {
                            promise(.failure(AuthError.duplicateEmail))
                            return
                        }

                        guard let entity = NSEntityDescription.entity(forEntityName: "Admin", in: self.context) else {
                            promise(.failure(AuthError.underlying(NSError(domain: "AdminEntity", code: -1, userInfo: nil))))
                            return
                        }
                        let admin = Admin(entity: entity, insertInto: self.context)
                        admin.email = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
                        admin.password = self.password // NOTE: Do not store plaintext passwords in production.

                        try self.context.save()
                        promise(.success(true))
                    } catch {
                        promise(.failure(AuthError.underlying(error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func loginPublisher() -> AnyPublisher<Bool, Error> {
        Deferred { [weak self] () -> Future<Bool, Error> in
            guard let self = self else { return Future { $0(.failure(AuthError.underlying(NSError()))) } }
            return Future { promise in
                if let error = self.validateInputs() {
                    promise(.failure(error))
                    return
                }

                self.context.perform {
                    let fetch: NSFetchRequest<Admin> = NSFetchRequest(entityName: "Admin")
                    fetch.predicate = NSPredicate(format: "email ==[c] %@ AND password == %@", self.email, self.password)
                    fetch.fetchLimit = 1

                    do {
                        let result = try self.context.fetch(fetch)
                        if result.first != nil {
                            promise(.success(true))
                        } else {
                            promise(.failure(AuthError.invalidCredentials))
                        }
                    } catch {
                        promise(.failure(AuthError.underlying(error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
