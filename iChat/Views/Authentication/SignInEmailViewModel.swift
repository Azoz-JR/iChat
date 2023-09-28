//
//  SignInEmailViewModel.swift
//  FireBaseBootCamp
//
//  Created by Azoz Salah on 06/04/2023.
//

import Foundation


@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn(completion: @escaping (String, String) -> ()) async throws {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("No Email or Password found.")
            return
        }
                
        let authDataResult = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
        let user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
        completion(authDataResult.uid, user.username)
    }
}
