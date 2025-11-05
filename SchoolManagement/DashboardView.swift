//
//  DashboardView.swift
//  SchoolManagement
//
//  Created by Assistant on 05/11/25.
//

import SwiftUI
import CoreData

struct DashboardView: View {
    @EnvironmentObject private var viewModel: AuthViewModel

    var body: some View {
        let vm = viewModel
        VStack(spacing: 16) {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
        }
        .navigationTitle("Dashboard")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Label("Profile", systemImage: "person.crop.circle")
                    }

                    Button(role: .destructive) {
                        vm.logout()
                    } label: {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
            .environmentObject(AuthViewModel(context: PersistenceController.shared.container.viewContext))
    }
}
