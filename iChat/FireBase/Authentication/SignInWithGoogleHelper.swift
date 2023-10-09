//
//  SignInWithGoogleHelper.swift
//  iChat
//
//  Created by Azoz Salah on 01/06/2023.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift



final class SignInGoogleHelper {
    // Signs in the user with Google credentials
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        // Retrieve the top view controller to present the sign-in UI
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        // Perform the Google sign-in operation with the provided top view controller
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        // Retrieve the Google ID token
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        // Retrieve the Google access token, email, and name (if available)
        let accessToken = gidSignInResult.user.accessToken.tokenString
        let email = gidSignInResult.user.profile?.email
        let name = gidSignInResult.user.profile?.name
        
        // Create and return a GoogleSignInResultModel with the obtained credentials
        return GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
    }
}
