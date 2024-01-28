//
//  UserManager.swift
//  Recipe
//
//  Created by Azoz Salah on 31/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift



final class UserManager {
    // Manages user-related operations in the app
    
    static let shared = UserManager()
    
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    // Returns the document reference for a user with the given userId
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func userPicturesCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("pictures")
    }
    
    private func userPictureDocument(userId: String) -> DocumentReference {
        userPicturesCollection(userId: userId).document("profile_picture")
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    // Creates a new user in the database
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getCurrentUser() async -> DBUser? {
        do {
            let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
            return try await userDocument(userId: uid).getDocument(as: DBUser.self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
        
    // Retrieves a user from the database with the given userId
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    // Updates a user's premium status in the database
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    // Adds a preference to a user's preferences list in the database
    func addUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    // Removes a preference from a user's preferences list in the database
    func removeUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
//    func updateUserProfilePicture(userId: String, picture: Data) async throws {
//        let data: [String: Any] = [
//            DBUser.CodingKeys.profilePicture.rawValue: picture
//        ]
//        
//        try await userDocument(userId: userId).updateData(data)
//    }
    
    func updateUserProfilePicture(userId: String, picture: Data) async throws {
        let data: [String: Any] = [
            "profile_picture": picture
        ]
        
        try await userPictureDocument(userId: userId).setData(data, merge: false)
    }
    
    func getUserProfilePicture(userId: String) async throws -> UIImage? {
        guard let profilePicture = try await userPictureDocument(userId: userId).getDocument(as: ProfilePicture.self).profileImage else {
            return nil
        }
        return profilePicture
    }
    
}
