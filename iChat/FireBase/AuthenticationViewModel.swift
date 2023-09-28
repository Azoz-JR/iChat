//
//  AuthenticationViewModel.swift
//  Recipe
//
//  Created by Azoz Salah on 01/06/2023.
//

import Foundation


@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle(completion: @escaping (String) -> ()) async throws {
        // Create an instance of the SignInGoogleHelper
        let helper = SignInGoogleHelper()
        
        // Perform the Google sign-in flow and retrieve the tokens
        let tokens = try await helper.signIn()
        
        // Authenticate the user using the retrieved tokens
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
        // Create a DBUser instance based on the authenticated data result
        let user = DBUser(auth: authDataResult)
        
        // Create a new user in the database
        try await UserManager.shared.createNewUser(user: user)
        
        completion(user.userId)
    }
    
//    func signInAnonymously() async throws {
//        // Sign in the user anonymously
//        let authDataResult = try await AuthenticationManager.shared.signInAnonymously()
//        
//        // Create a DBUser instance based on the authenticated data result
//        let user = DBUser(auth: authDataResult)
//        
//        // Create a new user in the database
//        try await UserManager.shared.createNewUser(user: user)
//    }
    
}

