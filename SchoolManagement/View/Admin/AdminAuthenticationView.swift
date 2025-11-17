//
//  AdminAuthenticationView.swift
//  SchoolManagement
//
//  Created by Assistant on 12/11/25.
//

import SwiftUI
import CoreData

// MARK: - AdminAuthenticationView
struct AdminAuthenticationView: View {
    // MARK: Environment
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var adminVM: AdminAuthViewModel

    // MARK: Focus
    @FocusState private var isUserFocused: Bool
    @FocusState private var isPasswordFocused: Bool

    // MARK: State
    @State private var showPassword: Bool = false
    @State private var authType: AuthenticationType = .login

    // MARK: Derived
    private var isFormValid: Bool { adminVM.isFormValid }

    // MARK: Body
    var body: some View {
        VStack(spacing: 16) {
            header
                .padding(.top, 24)

            authTypeSwitcher
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)

            fields

            primaryActionButton
                .disabled(!isFormValid)
            
            dontHaveAccountText

            Spacer()
        }
        .padding()
        .alert(
            "Error",
            isPresented: Binding(
                get: { adminVM.errorMessage != nil },
                set: { if !$0 { adminVM.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { adminVM.errorMessage = nil }
        } message: {
            Text(adminVM.errorMessage ?? "")
        }
    }
}

// MARK: - Subviews
private extension AdminAuthenticationView {
    var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "shield.righthalf.filled")
                .resizable()
                .scaledToFit()
                .frame(width: 70)

            Text(authType == .login ? "admin_auth_title_sign_in" : "admin_auth_title_register")
                .font(.system(size: 32, weight: .bold, design: .rounded))
        }
    }

    var authTypeSwitcher: some View {
        HStack(spacing: 0) {
            switcherButton(titleKey: "admin_sign_in", isActive: authType == .login) {
                withAnimation { authType = .login }
            }

            switcherButton(titleKey: "admin_register", isActive: authType == .register) {
                withAnimation { authType = .register }
            }
        }
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(20)
    }

    func switcherButton(titleKey: LocalizedStringKey, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(titleKey)
                .fontWeight(isActive ? .semibold : .regular)
                .foregroundStyle(isActive ? (colorScheme == .light ? Color(uiColor: .darkGray) : .white) : .gray)
                .padding(.vertical, 12)
                .padding(.horizontal, isActive ? 30 : 20)
                .background(
                    ZStack {
                        if isActive {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                                .zIndex(1)
                        }
                        RoundedRectangle(cornerRadius: 20)
                            .fill(isActive ? Color(uiColor: .systemGray5) : Color(uiColor: .systemGray6))
                            .zIndex(0)
                    }
                )
        }
        .buttonStyle(.plain)
    }

    var fields: some View {
        VStack(spacing: 15) {
            TextField(text: $adminVM.email) { Text("admin_email_placeholder") }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .textFieldStyle(AdminAuthenticationTextFieldStyle(isFocused: $isUserFocused))
                .focused($isUserFocused)

            passwordField
        }
    }

    var passwordField: some View {
        ZStack {
            // Visible text field when showing password
            TextField(text: $adminVM.password) { Text("admin_password_placeholder") }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .textContentType(.password)
                .textFieldStyle(AdminAuthenticationTextFieldStyle(isFocused: $isPasswordFocused))
                .focused($isPasswordFocused)
                .opacity(showPassword ? 1 : 0)
                .overlay(alignment: .trailing) { passwordToggle }

            // Secure field when hiding password
            SecureField(text: $adminVM.password) { Text("admin_password_placeholder") }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .textContentType(.password)
                .textFieldStyle(AdminAuthenticationTextFieldStyle(isFocused: $isPasswordFocused))
                .focused($isPasswordFocused)
                .opacity(showPassword ? 0 : 1)
                .overlay(alignment: .trailing) { passwordToggle }
        }
    }

    var passwordToggle: some View {
        Button { withAnimation { showPassword.toggle() } } label: {
            Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                .padding()
                .foregroundStyle(Color(uiColor: .darkGray))
        }
        .buttonStyle(.plain)
    }
    
    var dontHaveAccountText: some View {
        HStack(spacing: 3) {
            Text(authType == .login ? "admin_dont_have_account" : "admin_already_have_account")
                .font(.system(size: 15, weight: .medium, design: .rounded))
            
            Button {
                if authType == .login {
                    withAnimation {
                        self.authType = .register
                    }
                } else {
                    withAnimation {
                        self.authType = .login
                    }
                }
            } label: {
                Text(authType == .login ? "admin_register" : "admin_sign_in")
                    .font(Font.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(colorScheme == .light ? .black : .white)
            }

        }
    }

    var primaryActionButton: some View {
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
    }
}

// MARK: - Styles
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
                        .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 1)
                        .zIndex(1)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .light ? Color.white : Color.black)
                        .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 1)
                        .zIndex(0)
                }
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused.wrappedValue)
    }
}

// MARK: - Preview
#Preview {
    let preview = PersistenceController.preview
    return NavigationStack {
        AdminAuthenticationView()
            .preferredColorScheme(.light)
            .environmentObject(AdminAuthViewModel(context: preview.container.viewContext))
    }
}
