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

struct AuthenticationRoot: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: AuthViewModel

    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: AuthViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            AuthenticationView()
        }
        .environmentObject(viewModel)
    }
}

