//
//  AuthenticationManager.swift
//  iChat
//
//  Created by Azoz Salah on 01/06/2023.
//

import Foundation
import FirebaseAuth



final class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private init() {}
    
    // Retrieves the currently authenticated user
    func getAuthenticatedUser() throws -> User {
        guard let user = Auth.auth().currentUser else { throw URLError(.badServerResponse) }
        return user
    }
    
    // Retrieves the authentication providers for the current user
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    // Signs out the current user
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // Deletes the current user asynchronously
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.cannotFindHost)
        }
        
        try await user.delete()
    }
}

// MARK: SIGN IN EMAIL
extension AuthenticationManager {
    // Creates a new user with the provided email and password
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // Signs in the user with the provided email and password
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // Sends a password reset email to the provided email address
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // Updates the password of the current user
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else { throw URLError(.badServerResponse) }
        
        try await user.updatePassword(to: password)
    }
    
    // Updates the email of the current user
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else { throw URLError(.badServerResponse) }
        
        try await user.updateEmail(to: email)
    }
}

// MARK: SIGN IN SSO
extension AuthenticationManager {
    // Signs in the user with Google credentials
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    // Signs in the user with the provided credential
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

// MARK: SIGN IN ANONYMOUSLY
extension AuthenticationManager {
    // Signs in the user anonymously
    @discardableResult
    func signInAnonymously() async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signInAnonymously()
        return AuthDataResultModel(user: authDataResult.user)
    }
}

// MARK: CONVERT ANONYMOUS ACCOUNT TO PERMANENT ACCOUNT
extension AuthenticationManager {
    // Connects the anonymous account to a Google account
    @discardableResult
    func connectAnonymousToGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await linkUser(credential: credential)
    }
    
    // Connects the anonymous account to an email/password account
    @discardableResult
    func connectAnonymousToEmail(email: String, password: String) async throws -> AuthDataResultModel {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        return try await linkUser(credential: credential)
    }
    
    // Links the anonymous user to the specified credential
    private func linkUser(credential: AuthCredential) async throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.cannotFindHost)
        }
        
        let authDataResult = try await user.link(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
