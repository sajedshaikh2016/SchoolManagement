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
    // Initialize persistence once
    private let persistence = PersistenceController.shared

    // App-wide view models
    @StateObject private var studentVM = StudentAuthViewModel(context: PersistenceController.shared.container.viewContext)
    @StateObject private var adminVM = AdminAuthViewModel(context: PersistenceController.shared.container.viewContext)

    init() {
        // Any additional setup can be done here if needed
    }

    var body: some Scene {
        WindowGroup {
            AuthenticationRoot()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .environmentObject(studentVM)
                .environmentObject(adminVM)
        }
    }
}

/// Root of the app that now lets the user choose between Student and Admin authentication flows.
struct AuthenticationRoot: View {
    private enum Route: Hashable {
        case studentDashboard
        case adminDashboard
    }

    @State private var path: [Route] = []

    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var studentViewModel: StudentAuthViewModel
    @EnvironmentObject private var adminViewModel: AdminAuthViewModel

    var body: some View {
        NavigationStack(path: $path) {
            RoleSelectionView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .studentDashboard:
                        StudentDashboardView()
                    case .adminDashboard:
                        AdminDashboardView()
                    }
                }
        }
        .onChange(of: studentViewModel.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated {
                // Clear student auth fields when navigating away after successful auth
                studentViewModel.email = ""
                studentViewModel.password = ""
                path = [.studentDashboard]
            } else {
                // Pop to root when logging out
                path = []
            }
        }
        .onChange(of: adminViewModel.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated {
                // Clear admin auth fields when navigating away after successful auth
                adminViewModel.username = ""
                adminViewModel.password = ""
                path = [.adminDashboard]
            } else {
                // Pop to root when logging out
                path = []
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
