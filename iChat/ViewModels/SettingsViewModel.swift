//
//  SettingsViewModel.swift
//  Recipe
//
//  Created by Azoz Salah on 02/06/2023.
//

import Foundation
import FirebaseAuth


@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var currentUserEmail: String = ""
    @Published var email = ""
    @Published var password = ""
    @Published var currentUser: User?
    
    func loadAuthProviders() {
        // Retrieve the available authentication providers
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func signOut() throws {
        // Sign out the current user
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteUser() async throws {
        // Delete the current user's account
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        // Reset the password for the current user's email
        try await AuthenticationManager.shared.resetPassword(email: currentUserEmail)
    }
    
    func updateEmail(email: String) async throws {
        // Update the current user's email
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword(password: String) async throws {
        // Update the current user's password
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func getCurrentUser() {
        do {
            // Retrieve the authenticated user's data
            let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
            self.currentUser = currentUser
            
            // Get the email of the current user
            guard let email = currentUser.email else { throw URLError(.fileDoesNotExist) }
            self.currentUserEmail = email
        } catch {
            print("ERROR GETTING CURRENT USER: \(error.localizedDescription)")
        }
    }
    
    func connectAnonymousToGoogle() async throws {
        // Create an instance of the SignInGoogleHelper
        let helper = SignInGoogleHelper()
        
        // Perform the Google sign-in flow and retrieve the tokens
        let tokens = try await helper.signIn()
        
        // Connect the anonymous user to Google using the tokens
        try await AuthenticationManager.shared.connectAnonymousToGoogle(tokens: tokens)
    }
    
    func connectAnonymousToEmail() async throws {
        // Check if email and password are not empty
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("No Email or Password found.")
            return
        }
        
        // Connect the anonymous user to email using the provided email and password
        try await AuthenticationManager.shared.connectAnonymousToEmail(email: email, password: password)
    }
    
}

