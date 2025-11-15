//
//  SchoolManagementApp.swift
//  SchoolManagement
//
//  Created by Sajed Shaikh on 05/11/25.
//

import SwiftUI
internal import CoreData

@main
struct SchoolManagementApp: App {
    var body: some Scene {
        WindowGroup {
            AuthenticationRoot()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(StudentAuthViewModel(context: PersistenceController.shared.container.viewContext))
                .environmentObject(AdminAuthViewModel(context: PersistenceController.shared.container.viewContext))
        }
    }
}

/// Root of the app that now lets the user choose between Student and Admin authentication flows.
struct AuthenticationRoot: View {
    @Environment(\.managedObjectContext) private var context

    @EnvironmentObject private var studentViewModel: StudentAuthViewModel
    @EnvironmentObject private var adminViewModel: AdminAuthViewModel

    var body: some View {
        NavigationStack {
            RoleSelectionView()
        }
        // Provide both environment objects so the destination views can pick what they need
        .onChange(of: studentViewModel.isAuthenticated) { oldValue, newValue in
            if newValue {
                // Clear student auth fields when navigating away after successful auth
                studentViewModel.email = ""
                studentViewModel.password = ""
            }
        }
        .onChange(of: adminViewModel.isAuthenticated) { oldValue, newValue in
            if newValue {
                // Clear admin auth fields when navigating away after successful auth
                adminViewModel.username = ""
                adminViewModel.password = ""
            }
        }
    }
}

#Preview {
    let preview = PersistenceController.preview
    return AuthenticationRoot()
        .environment(\.managedObjectContext, preview.container.viewContext)
        .environmentObject(StudentAuthViewModel(context: preview.container.viewContext))
        .environmentObject(AdminAuthViewModel(context: preview.container.viewContext))
}
