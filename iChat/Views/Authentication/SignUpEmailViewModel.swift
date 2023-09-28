//
//  SignUpEmailViewModel.swift
//  FireBaseBootCamp
//
//  Created by Azoz Salah on 06/04/2023.
//

import Foundation


@MainActor
final class SignUpEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    
    func signUp(completion: @escaping (String, String) -> ()) async throws {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty, !username.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("No Email or Password or Username found.")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult, username: username)
        
        try await UserManager.shared.createNewUser(user: user)
        
        completion(user.userId, username)
    }
}
