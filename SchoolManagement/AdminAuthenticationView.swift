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
    @Environment(\.colorScheme) private var colorScheme
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
                        .foregroundStyle(authType == .login ? (colorScheme == .light ? Color(uiColor: UIColor.darkGray): .white) : .gray)
                        .padding(.vertical, 12)
                        .padding(.horizontal, authType == .login ? 30 : 20)
                        .background(
                            ZStack {
                                if authType == .login {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                                        .zIndex(1)
                                }
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(authType == .login ?
                                          Color(uiColor: UIColor.systemGray5):
                                            Color(UIColor.systemGray6))
                                    .zIndex(0)
                            }
                        )
                }
                Button {
                    withAnimation { authType = .register }
                } label: {
                    Text("Register")
                        .fontWeight(authType == .register ?  .semibold : .regular)
                        .foregroundStyle(authType == .register ? (colorScheme == .light ? Color(uiColor: UIColor.darkGray): .white) : .gray)
                        .padding(.vertical, 12)
                        .padding(.horizontal, authType == .register ? 30 : 20)
                        .background(
                            ZStack {
                                if authType == .register {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                                        .zIndex(1)
                                }
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(authType == .register ?
                                          Color(uiColor: UIColor.systemGray5):
                                            Color(UIColor.systemGray6))
                                    .zIndex(0)
                            }
                        )
                }
            }
            .background(
                Color(uiColor: .systemGray6)
            )
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity)
            
            
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
