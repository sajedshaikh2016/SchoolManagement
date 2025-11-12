//
//  AdminDashboardView.swift
//  SchoolManagement
//
//  Created by Assistant on 12/11/25.
//

import SwiftUI

struct AdminDashboardView: View {
    @EnvironmentObject private var adminVM: AdminAuthViewModel

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "shield.checkerboard")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.green)

            Text("Admin Console")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("Welcome, Admin!")
                .foregroundStyle(.secondary)

            Button("Logout") { adminVM.logout() }
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Admin Dashboard")
    }
}

#Preview {
    NavigationStack {
        AdminDashboardView()
            .environmentObject(AdminAuthViewModel())
    }
}
