//
//  SchoolManagementApp.swift
//  SchoolManagement
//
//  Created by Sajed Shaikh on 05/11/25.
//

import SwiftUI
import CoreData

@main
struct SchoolManagementApp: App {
    var body: some Scene {
        WindowGroup {
            AuthenticationRoot()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}

/// Root of the app that now lets the user choose between User and Admin authentication flows.
struct AuthenticationRoot: View {
    @Environment(\.managedObjectContext) private var context

    // Separate view models for user and admin flows
    @StateObject private var userViewModel: AuthViewModel
    @StateObject private var adminViewModel = AdminAuthViewModel()

    init() {
        let context = PersistenceController.shared.container.viewContext
        _userViewModel = StateObject(wrappedValue: AuthViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            RoleSelectionView()
        }
        // Provide both environment objects so the destination views can pick what they need
        .environmentObject(userViewModel)
        .environmentObject(adminViewModel)
    }
}
