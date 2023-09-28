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
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color.primaryColor, location: 0),
                .init(color: Color(uiColor: .systemBackground), location: 0.05)
            ], center: .topLeading, startRadius: 200, endRadius: 205).ignoresSafeArea()
            
            
                
            VStack(spacing: 20) {
                Text ("iChat")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color.primaryColor)
                
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
                            print("ERROR SIGNING UP: \(error.localizedDescription)")
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
            }
            .padding()
        }
    }
}


#Preview {
    NavigationStack {
        SignUpEmailView()
            .environmentObject(StreamViewModel())
    }
}
