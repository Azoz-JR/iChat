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
    @State private var showConfirmationAlert = false
    
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
                    showConfirmationAlert = true
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
        .alert("Your password reset successfully.", isPresented: $streamViewModel.showAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("A message sent to your Email with your new password.")
        }
        .alert("Reset Password?", isPresented: $showConfirmationAlert) {
            Button("Reset", role: .destructive) {
                Task {
                    do {
                        try await AuthenticationManager.shared.resetPassword(email: email)
                        
                        streamViewModel.showAlert = true
                    } catch {
                        streamViewModel.errorMsg = error.localizedDescription
                        streamViewModel.error = true
                    }
                }
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You cannot undo this action")
        }

    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(StreamViewModel())
}
