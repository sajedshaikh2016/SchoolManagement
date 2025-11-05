//
//  DashboardView.swift
//  SchoolManagement
//
//  Created by Assistant on 05/11/25.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "graduationcap.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .foregroundStyle(.blue)

                Text("Welcome to the Dashboard")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
            }
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView()
}
