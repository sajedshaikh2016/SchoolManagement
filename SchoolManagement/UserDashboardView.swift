//
//  UserDashboardView.swift
//  SchoolManagement
//
//  Created by Assistant on 05/11/25.
//

import SwiftUI
internal import CoreData

struct UserDashboardView: View {
    @EnvironmentObject private var userVM: UserAuthViewModel

    var body: some View {
        VStack {
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
                        userVM.logout()
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
        UserDashboardView()
            .environmentObject(UserAuthViewModel(context: preview.container.viewContext))
    }
}
