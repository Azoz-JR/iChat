//
//  SignUpEmailViewModel.swift
//  FireBaseBootCamp
//
//  Created by Azoz Salah on 06/04/2023.
//

import Foundation
import SwiftUI


@MainActor
final class SignUpEmailViewModel: ObservableObject {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    
    func signUp(completion: @escaping (String, String) -> ()) async throws {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty, !username.trimmingCharacters(in: .whitespaces).isEmpty else {
            streamViewModel.errorMsg = "You should enter Email and Password"
            streamViewModel.error.toggle()
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult, username: username)
        
        try await UserManager.shared.createNewUser(user: user)
        
        completion(user.userId, username)
    }
}
