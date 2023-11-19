//
//  SignInEmailViewModel.swift
//  FireBaseBootCamp
//
//  Created by Azoz Salah on 06/04/2023.
//

import Foundation
import SwiftUI


@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn(completion: @escaping (String, String) -> ()) async throws {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            streamViewModel.errorMsg = "You should enter Email and Password"
            streamViewModel.error.toggle()
            return
        }
                
        let authDataResult = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
        let user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
        completion(authDataResult.uid, user.username)
    }
}
