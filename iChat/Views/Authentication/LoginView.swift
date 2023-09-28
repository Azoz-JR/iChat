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
                RadialGradient(stops: [
                    .init(color: Color.primaryColor, location: 0),
                    .init(color: Color(uiColor: .systemBackground), location: 0.05)
                ], center: .topLeading, startRadius: 200, endRadius: 205).ignoresSafeArea()
                
                
                VStack(spacing: 20) {
                    Text ("iChat")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color.primaryColor)
                    
                    TextField("Username", text: $signInEmailViewModel.email)
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
                    
//                    Button {
//                        
//                    } label: {
//                        Text("Forget password?")
//                            .foregroundColor(.primaryColor)
//                    }
//                    .offset(x: 70, y: -10)
                    
                    Button {
                        Task {
                            do {
                                try await signInEmailViewModel.signIn { username in
                                    DispatchQueue.main.async {
                                        streamViewModel.signIn(username: username)
                                    }
                                }
                            } catch {
                                print("ERROR SIGNING IN: \(error.localizedDescription)")
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
                    Button {
                        Task {
                            do {
                                try await authenticationViewModel.signInGoogle { username in
                                    DispatchQueue.main.async {
                                        streamViewModel.signIn(username: username)
                                    }
                                }
                            } catch {
                                print("ERROR SIGNING IN WITH GOOGLE..\(error.localizedDescription)")
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
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(StreamViewModel())
}
