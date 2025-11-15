//
//  StudentDashboardView.swift
//  SchoolManagement
//
//  Created by Assistant on 05/11/25.
//

import SwiftUI
internal import CoreData

struct StudentDashboardView: View {
    @EnvironmentObject private var studentVM: StudentAuthViewModel

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

                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                    
                    Button(role: .destructive) {
                        studentVM.logout()
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
        StudentDashboardView()
            .environmentObject(StudentAuthViewModel(context: preview.container.viewContext))
    }
}
