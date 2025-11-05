//
//  ProfileView.swift
//  SchoolManagement
//
//  Created by Assistant on 05/11/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.blue)

            Text("Profile")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("This is the profile screen.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
