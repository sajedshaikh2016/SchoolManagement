//
//  AuthenticationView.swift
//  SchoolManagement
//
//  Created by Sajed Shaikh on 05/11/25.
//

import SwiftUI

enum AuthenticationType {
    case login
    case register
}

struct AuthenticationView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @FocusState private var isEmailFocused
    @FocusState private var isPasswordFocused
    
    @State private var showPassword: Bool = false
    @State private var hasAgreedToTerms: Bool = false
    
    @State private var authenticationType: AuthenticationType = .login
    var body: some View {
        ScrollView(showsIndicators: false) {
            TopView()
            SegmentedView(authenticationType: $authenticationType)
            
            VStack(spacing: 15) {
                TextField(text: $email) {
                    Text("Email")
                }
                .focused($isEmailFocused)
                .textFieldStyle(AuthenticationTextFieldStyle(isFocused: $isEmailFocused))
                
                ZStack {
                    TextField(text: $password) {
                        Text("Password")
                    }
                    .focused($isPasswordFocused)
                    .textFieldStyle(AuthenticationTextFieldStyle(isFocused: $isPasswordFocused))
                    .overlay(alignment: .trailing, content: {
                        Button {
                            withAnimation {
                                showPassword.toggle()
                            }
                        } label: {
                            Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                .padding()
                                .foregroundStyle(Color(uiColor: .darkGray))
                        }
                    })
                    .opacity(showPassword ? 1 : 0)
                    .zIndex(1)
                    
                    SecureField(text: $password) {
                        Text("Password")
                    }
                    .focused($isPasswordFocused)
                    .textFieldStyle(AuthenticationTextFieldStyle(isFocused: $isPasswordFocused))
                    .overlay(alignment: .trailing) {
                        Button {
                            withAnimation {
                                showPassword.toggle()
                            }
                        } label: {
                            Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                .padding()
                                .foregroundStyle(Color(uiColor: .darkGray))
                        }
                        
                    }
                    .opacity(showPassword ? 0 : 1)
                }
                
                if authenticationType == .register {
                    HStack(alignment: .top, content: {
                        Toggle(isOn: $hasAgreedToTerms) {
                            
                        }
                        .toggleStyle(AgreeStyle())
                        
                        Text("I agree to the **Terms** and **Privacy Policy**.")
                    })
                }
                
            }
            
            Button {
                
            } label: {
                Text(authenticationType == .login ? "Login" : "Register")
            }
            .buttonStyle(AuthenticationButtonType())

            
            BottomView(authenticationType: $authenticationType)
        }
        .padding()
        .gesture(
            TapGesture().onEnded ({
                isEmailFocused = false
                isPasswordFocused = false
            })
        )
    }
}

struct AgreeStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20)
                .contentTransition(.opacity)
            
        }
        .tint(.primary)

    }
}

struct AuthenticationButtonType: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .foregroundStyle(Color.white)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .background(
                LinearGradient(stops: [
                    .init(color: Color.blue, location: 0.0),
                    .init(color: Color.black, location: 1.0)
                ],
                               startPoint: .leading,
                               endPoint: .trailing
                )
            )
            .cornerRadius(15)
            .brightness(configuration.isPressed ? 0.05 : 0)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .padding(.vertical, 12)
    }
}

struct AuthenticationTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) private var colorScheme
    
    let isFocused: FocusState<Bool>.Binding
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .font(.system(size: 20, weight: .regular, design: .rounded))
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(isFocused.wrappedValue ? Color.blue : Color.gray.opacity(0.5), lineWidth: 1)
                        .zIndex(1)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colorScheme == .light ? Color(.lightGray) : Color(UIColor.darkGray))
                        .zIndex(0)
                }
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused.wrappedValue )
    }
    
}

struct TopView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75)
            
            Text("Authentication Flow")
                .font(.system(size: 35, weight: .bold, design: .rounded))
                
        }
    }
}

struct SegmentedView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var authenticationType: AuthenticationType
    var body: some View {
        HStack(spacing: 0) {
            
            Button {
                withAnimation {
                    authenticationType = .login
                }
            } label: {
                Text("Login")
                    .fontWeight(authenticationType == .login ?  .semibold : .regular)
                    .foregroundStyle(authenticationType == .login ? (colorScheme == .light ? Color(uiColor: UIColor.darkGray): .white) : .gray)
                    .padding(.vertical, 12)
                    .padding(.horizontal, authenticationType == .login ? 30 : 20)
                    .background(
                        ZStack {
                            if authenticationType == .login {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                                    .zIndex(1)
                            }
                            
                            RoundedRectangle(cornerRadius: 20)
                                .fill(authenticationType == .login ?
                                      Color(uiColor: UIColor.systemGray5):
                                        Color(UIColor.systemGray6))
                                .zIndex(0)
                        }
                    )
            }
            
            
            Button {
                withAnimation {
                    authenticationType = .register
                }
            } label: {
                Text("Register")
                    .fontWeight(authenticationType == .register ?  .semibold : .regular)
                    .foregroundStyle(authenticationType == .register ? (colorScheme == .light ? Color(uiColor: UIColor.darkGray): .white) : .gray)
                    .padding(.vertical, 12)
                    .padding(.horizontal, authenticationType == .register ? 30 : 20)
                    .background(
                        ZStack {
                            if authenticationType == .register {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                                    .zIndex(1)
                            }
                            
                            RoundedRectangle(cornerRadius: 20)
                                .fill(authenticationType == .register ?
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
    }
}

struct BottomView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var authenticationType: AuthenticationType
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 3) {
                Text(authenticationType == .login ? "Don't have an account?" : "Already have an account?")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                
                Button {
                    if authenticationType == .login {
                        withAnimation {
                            self.authenticationType = .register
                        }
                    } else {
                        withAnimation {
                            self.authenticationType = .login
                        }
                    }
                } label: {
                    Text(authenticationType == .login ? "Register" : "Login")
                        .font(Font.system(size: 15, weight: .bold, design: .rounded))
                }

            }
            
            HStack {
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundStyle(Color.gray.opacity(0.3))
                Text("OR")
                    .font(Font.system(size: 14, weight: .regular, design: .rounded))
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundStyle(Color.gray.opacity(0.3))
            }
            
            HStack(spacing: 20) {
                
                // Apple
                Button {
                    
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1.5)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .overlay {
                            Image(systemName: "apple.logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(colorScheme == .light ? Color.black : Color.white)
                        }
                }
                
                // Google
                Button {
                    
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1.5)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .overlay {
                            Image("google")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(colorScheme == .light ? Color.black : Color.white)
                        }
                }
                

            }
            
        }
    }
}

#Preview {
    AuthenticationView()
}
