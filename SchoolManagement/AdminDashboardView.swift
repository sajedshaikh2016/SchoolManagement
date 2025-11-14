//
//  AdminDashboardView.swift
//  SchoolManagement
//
//  Created by Assistant on 12/11/25.
//

import SwiftUI
internal import CoreData

struct AdminDashboardView: View {
    @EnvironmentObject private var adminVM: AdminAuthViewModel

    var body: some View {
        VStack(spacing: 16) {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            .tint(.yellow)
        }
        .padding()
        .navigationTitle("Admin Dashboard")
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
                        adminVM.logout()
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
    let preview = PersistenceController.preview
    return NavigationStack {
        AdminDashboardView()
            .environmentObject(AdminAuthViewModel(context: preview.container.viewContext))
    }
}
