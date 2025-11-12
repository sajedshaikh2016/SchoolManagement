//
//  AdminAuthenticationView.swift
//  SchoolManagement
//
//  Created by Assistant on 12/11/25.
//

import SwiftUI

// Uses AuthenticationType from AuthenticationView. If unavailable, uncomment below.
// enum AuthenticationType { case login, register }

struct AdminAuthenticationView: View {
    @EnvironmentObject private var adminVM: AdminAuthViewModel
    @FocusState private var isUserFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @State private var showPassword: Bool = false
    @State private var authType: AuthenticationType = .login

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
                Text(authType == .login ? "Admin Sign In" : "Admin Register")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
            }
            .padding(.top, 24)

            HStack(spacing: 0) {
                Button {
                    withAnimation { authType = .login }
                } label: {
                    Text("Login")
                        .fontWeight(authType == .login ? .semibold : .regular)
                        .padding(.vertical, 10)
                        .padding(.horizontal, authType == .login ? 24 : 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16).fill(authType == .login ? Color(uiColor: .systemGray5) : Color(uiColor: .systemGray6))
                        )
                }
                Button {
                    withAnimation { authType = .register }
                } label: {
                    Text("Register")
                        .fontWeight(authType == .register ? .semibold : .regular)
                        .padding(.vertical, 10)
                        .padding(.horizontal, authType == .register ? 24 : 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16).fill(authType == .register ? Color(uiColor: .systemGray5) : Color(uiColor: .systemGray6))
                        )
                }
            }
            .padding(.horizontal)

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
                if authType == .login {
                    Task { await adminVM.login() }
                } else {
                    Task { await adminVM.register() }
                }
            } label: {
                Text(authType == .login ? "Sign In" : "Register")
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
