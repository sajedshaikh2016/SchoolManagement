//
//  AdminAuthenticationView.swift
//  SchoolManagement
//
//  Created by Assistant on 12/11/25.
//

import SwiftUI
import CoreData

struct AdminAuthenticationView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var adminVM: AdminAuthViewModel
    @FocusState private var isUserFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @State private var showPassword: Bool = false
    @State private var authType: AuthenticationType = .login

    private var isFormValid: Bool {
        adminVM.isFormValid
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image(systemName: "shield.righthalf.filled")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                Text(authType == .login ? "admin_auth_title_sign_in" : "admin_auth_title_register")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
            }
            .padding(.top, 24)

            HStack(spacing: 0) {
                Button {
                    withAnimation { authType = .login }
                } label: {
                    Text("admin_sign_in")
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
                    Text("admin_register")
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
            
            
            VStack(spacing: 15) {
                TextField(text: $adminVM.email) { Text("admin_email_placeholder") }
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(AdminAuthenticationTextFieldStyle(isFocused: $isUserFocused))
                    .focused($isUserFocused)

                ZStack {
                    TextField(text: $adminVM.password) { Text("admin_password_placeholder") }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .textContentType(.password)
                        .textFieldStyle(AdminAuthenticationTextFieldStyle(isFocused: $isPasswordFocused))
                        .focused($isPasswordFocused)
                        .opacity(showPassword ? 1 : 0)
                        .overlay(alignment: .trailing) {
                            Button { withAnimation { showPassword.toggle() } } label: {
                                Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                    .padding()
                                    .foregroundStyle(Color(uiColor: .darkGray))
                            }
                        }

                    SecureField(text: $adminVM.password) { Text("admin_password_placeholder") }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .textContentType(.password)
                        .textFieldStyle(AdminAuthenticationTextFieldStyle(isFocused: $isPasswordFocused))
                        .focused($isPasswordFocused)
                        .opacity(showPassword ? 0 : 1)
                        .overlay(alignment: .trailing) {
                            Button { withAnimation { showPassword.toggle() } } label: {
                                Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                    .padding()
                                    .foregroundStyle(Color(uiColor: .darkGray))
                            }
                        }
                }
            }

            Button {
                if authType == .login {
                    adminVM.login()
                } else {
                    adminVM.register()
                }
            } label: {
                Text(authType == .login ? "admin_sign_in_button" : "admin_register_button")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(AuthenticationButtonType())
            .disabled(!isFormValid)

            Spacer()
        }
        .padding()
        .alert("Error", isPresented: Binding(get: { adminVM.errorMessage != nil }, set: { if !$0 { adminVM.errorMessage = nil } })) {
            Button("OK", role: .cancel) { adminVM.errorMessage = nil }
        } message: {
            Text(adminVM.errorMessage ?? "")
        }
    }
}

struct AdminAuthenticationTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) private var colorScheme
    let isFocused: FocusState<Bool>.Binding
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .font(.system(size: 18, weight: .regular, design: .rounded))
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(isFocused.wrappedValue ? Color.white : Color.white, lineWidth: 1)
                        .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 1)
                        .zIndex(1)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .light ? Color.white : Color.black)
                        .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 1)
                        .zIndex(0)
                }
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused.wrappedValue )
    }
}

#Preview {
    let preview = PersistenceController.preview
    return NavigationStack {
        AdminAuthenticationView()
            .preferredColorScheme(.light)
            .environmentObject(AdminAuthViewModel(context: preview.container.viewContext))
    }
}

