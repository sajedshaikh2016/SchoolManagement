//
//  RoleSelectionView.swift
//  SchoolManagement
//
//  Created by Assistant on 12/11/25.
//

import SwiftUI

struct RoleSelectionView: View {
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                Image(systemName: "person.2.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                Text("Select Role")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
            }
            .padding(.top, 40)

            VStack(spacing: 16) {
                RoleOption(systemImage: "person.crop.circle",
                           title: "Student",
                           subtitle: "Login or register as a student") {
                    StudentAuthenticationView()
                }

                RoleOption(systemImage: "shield.lefthalf.filled",
                           title: "Admin",
                           subtitle: "Sign in to the admin console") {
                    AdminAuthenticationView()
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .navigationTitle("welcome_title")
    }
}

private struct RoleOption<Destination: View>: View {
    let systemImage: String
    let title: String
    let subtitle: String
    let destination: () -> Destination

    init(systemImage: String, title: String, subtitle: String, @ViewBuilder destination: @escaping () -> Destination) {
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
        self.destination = destination
    }

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            RoleOptionLabel(systemImage: systemImage, title: title, subtitle: subtitle)
        }
    }
}

private struct RoleOptionLabel: View {
    let systemImage: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .imageScale(.large)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                Text(subtitle)
                    .foregroundStyle(.secondary)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .foregroundStyle(Color(uiColor: .black))
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .systemGray6))
        )
    }
}

#Preview {
    NavigationStack { RoleSelectionView() }
}
