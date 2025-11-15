//
//  SettingsView.swift
//  SchoolManagement
//
//  Created by Sajed Shaikh on 05/11/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "gear")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text("Settings")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("This is the settings screen.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
