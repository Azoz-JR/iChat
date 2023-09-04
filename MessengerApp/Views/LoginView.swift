//
//  LoginView.swift
//  ChatApp
//
//  Created by Azoz Salah on 30/07/2023.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @State private var username = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(stops: [
                    .init(color: Color("AppBlue"), location: 0),
                    .init(color: Color(uiColor: .systemBackground), location: 0.05)
                ], center: .topLeading, startRadius: 200, endRadius: 205).ignoresSafeArea()
                
                
                VStack(spacing: 20) {
                    Text ("iChat")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color("AppBlue"))
                        .offset(y: -100)
                        
                    
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .frame(width: 300, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.primary, lineWidth: 2)
                                
                        }
                    
                    Button {
                        DispatchQueue.main.async {
                            streamViewModel.signIn(username: username) { success in
                                if success {
                                    DispatchQueue.main.async {
                                        streamViewModel.showSignInView = false
                                    }
                                }
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
                                    .fill(Color("AppBlue"))
                                    .shadow(radius: 15)
                            }
                    }
                    .disabled(username.isEmpty)
                    .offset(y: 30)
                }
            }
            .alert("ERROR LOGGING IN...", isPresented: $streamViewModel.error) {
                Button("OK") {}
            } message: {
                Text(streamViewModel.errorMsg)
            }
            .environmentObject(streamViewModel)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(StreamViewModel())
    }
}
