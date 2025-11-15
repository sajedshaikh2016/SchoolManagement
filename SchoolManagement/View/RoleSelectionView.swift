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
                NavigationLink {
                    UserAuthenticationView()
                } label: {
                    HStack(spacing: 16) {
                        Image(systemName: "person.crop.circle")
                            .imageScale(.large)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("User")
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                            Text("Login or register as a user")
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

                NavigationLink {
                    AdminAuthenticationView()
                } label: {
                    HStack(spacing: 16) {
                        Image(systemName: "shield.lefthalf.filled")
                            .imageScale(.large)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Admin")
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                            Text("Sign in to the admin console")
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
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .navigationTitle("welcome_title")
    }
}

#Preview {
    NavigationStack { RoleSelectionView() }
}
