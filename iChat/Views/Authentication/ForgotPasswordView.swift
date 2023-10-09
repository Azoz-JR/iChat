//
//  ForgotPasswordView.swift
//  iChat
//
//  Created by Azoz Salah on 09/10/2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @State private var email: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LoginBackground(center: .bottomLeading)
            
            VStack(spacing: 20) {
                
                TextField("Email", text: $email)
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
                            try await AuthenticationManager.shared.resetPassword(email: email)
                            
                            dismiss()
                        } catch {
                            streamViewModel.errorMsg = error.localizedDescription
                            streamViewModel.error = true
                        }
                    }
                } label: {
                    Text("Reset Password")
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
            .vSpacing(.top)
            .padding(.top, 40)
        }
        .alert("ERROR RESETTING PASSWORD...", isPresented: $streamViewModel.error) {
            Button("OK") {}
        } message: {
            Text(streamViewModel.errorMsg)
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(StreamViewModel())
}
