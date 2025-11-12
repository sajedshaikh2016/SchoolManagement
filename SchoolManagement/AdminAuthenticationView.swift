//
//  AdminAuthenticationView.swift
//  SchoolManagement
//
//  Created by Assistant on 12/11/25.
//

import SwiftUI

struct AdminAuthenticationView: View {
    @EnvironmentObject private var adminVM: AdminAuthViewModel
    @FocusState private var isUserFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @State private var showPassword: Bool = false

    private var isFormValid: Bool {
        !adminVM.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !adminVM.password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image(systemName: "shield.righthalf.filled")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                Text("Admin Sign In")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
            }
            .padding(.top, 24)

            VStack(spacing: 14) {
                TextField(text: $adminVM.username) { Text("Username") }
                    .textFieldStyle(.roundedBorder)
                    .focused($isUserFocused)

                ZStack {
                    TextField(text: $adminVM.password) { Text("Password") }
                        .textFieldStyle(.roundedBorder)
                        .focused($isPasswordFocused)
                        .opacity(showPassword ? 1 : 0)
                        .overlay(alignment: .trailing) {
                            Button { withAnimation { showPassword.toggle() } } label: {
                                Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                    .padding(8)
                            }
                        }

                    SecureField(text: $adminVM.password) { Text("Password") }
                        .textFieldStyle(.roundedBorder)
                        .focused($isPasswordFocused)
                        .opacity(showPassword ? 0 : 1)
                        .overlay(alignment: .trailing) {
                            Button { withAnimation { showPassword.toggle() } } label: {
                                Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                    .padding(8)
                            }
                        }
                }
            }

            Button {
                Task { await adminVM.login() }
            } label: {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(AuthenticationButtonType())
            .disabled(!isFormValid)

            Spacer()
        }
        .padding()
        .navigationDestination(isPresented: $adminVM.isAuthenticated) {
            AdminDashboardView()
        }
        .alert("Error", isPresented: Binding(get: { adminVM.errorMessage != nil }, set: { if !$0 { adminVM.errorMessage = nil } })) {
            Button("OK", role: .cancel) { adminVM.errorMessage = nil }
        } message: {
            Text(adminVM.errorMessage ?? "")
        }
    }
}

#Preview {
    NavigationStack {
        AdminAuthenticationView()
            .environmentObject(AdminAuthViewModel())
    }
}
