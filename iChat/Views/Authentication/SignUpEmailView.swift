//
//  SignUpEmailView.swift
//  FireBaseBootCamp
//
//  Created by Azoz Salah on 20/03/2023.
//

import SwiftUI


struct SignUpEmailView: View {
    
    @StateObject private var viewModel = SignUpEmailViewModel()

    @EnvironmentObject var streamViewModel: StreamViewModel
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        ZStack {
            
            LoginBackground(center: .bottomTrailing)
                            
            VStack(spacing: 20) {
                Text ("iChat")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color.primaryColor)
                    .offset(y: -40)
                
                TextField("Username", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .frame(width: 300, alignment: .leading)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.primary, lineWidth: 2)
                        
                    }
                
                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .frame(width: 300, alignment: .leading)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.primary, lineWidth: 2)
                        
                    }
                
                SecureField("Password", text: $viewModel.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .frame(width: 300, alignment: .leading)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.primary, lineWidth: 2)
                    }
                
                Button {
                    Task {
                        do {
                            try await viewModel.signUp { userId, username in
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
                    Text("Sign up")
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
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 0) {
                        Text("Already have an account? ")
                            .foregroundColor(.primary)
                        Text("Sign in")
                            .foregroundColor(.primaryColor)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
        .alert("ERROR SIGNNING UP...", isPresented: $streamViewModel.error) {
            Button("OK") { }
        } message: {
            Text(streamViewModel.errorMsg)
        }

    }
}


#Preview {
    NavigationStack {
        SignUpEmailView()
            .environmentObject(StreamViewModel())
    }
}
