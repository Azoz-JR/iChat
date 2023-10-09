//
//  LoginView.swift
//  iChat
//
//  Created by Azoz Salah on 30/07/2023.
//

import GoogleSignInSwift
import SwiftUI


struct LoginView: View {
    
    @StateObject private var signInEmailViewModel = SignInEmailViewModel()
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                LoginBackground(center: .topLeading)
                
                VStack(spacing: 20) {
                    Text ("iChat")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color.primaryColor)
                    
                    //Sign In with E-mail
                    emailSection
                    
                    HStack(spacing: 0) {
                        Text("OR USE")
                            .font(.system(size: 14))
                            .padding(.trailing, 5)
                        
                        Circle()
                            .frame(width: 5, height: 5)
                        
                        Rectangle()
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 20)
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
                    
                    // Sign in with Google
                    googleSection
                    
                    HStack(spacing: 5) {
                        Text("Don't have an account?")
                        NavigationLink {
                            SignUpEmailView()
                        } label: {
                            Text("Create Account")
                                .foregroundColor(.primaryColor)
                        }
                    }
                }
            }
            .alert("ERROR LOGGING IN...", isPresented: $streamViewModel.error) {
                Button("OK") {}
            } message: {
                Text(streamViewModel.errorMsg)
            }
            .sheet(isPresented: $streamViewModel.showForgotPasswordView) {
                ForgotPasswordView()
                    .presentationDetents([.height(300)])
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(StreamViewModel())
}


extension LoginView {
    private var googleSection: some View {
        Button {
            Task {
                do {
                    try await authenticationViewModel.signInGoogle { userId, username in
                        DispatchQueue.main.async {
                            streamViewModel.signUp(userId: userId, username: username)
                        }
                    }
                } catch {
                    streamViewModel.errorMsg = error.localizedDescription
                    streamViewModel.error = true
                }
            }
        } label: {
            HStack {
                Image(.googleLogo)
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("Continue with Google")
                    .foregroundStyle(Color.primary)
            }
            .frame(width: 300, height: 50)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Color.primary, lineWidth: 1.0)
            }
        }
    }
}

extension LoginView {
    private var emailSection: some View {
        Group {
            TextField("Email", text: $signInEmailViewModel.email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .frame(width: 300, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.primary, lineWidth: 2)
                    
                }
            
            SecureField("Password", text: $signInEmailViewModel.password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .frame(width: 300, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.primary, lineWidth: 2)
                }
            
            Button {
                streamViewModel.showForgotPasswordView = true
            } label: {
                Text("Forget password?")
                    .foregroundColor(.primaryColor)
            }
            .offset(x: 70, y: -10)
            
            Button {
                Task {
                    do {
                        try await signInEmailViewModel.signIn { userId, username in
                            DispatchQueue.main.async {
                                streamViewModel.signIn(userId: userId)
                            }
                        }
                    } catch {
                        streamViewModel.errorMsg = error.localizedDescription
                        streamViewModel.error = true
                    }
                }
            } label: {
                Text("LOGIN")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(width: 180)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.primaryColor)
                            .shadow(radius: 5)
                    }
            }
            .disabled(signInEmailViewModel.email.isEmpty)
        }
    }
}
