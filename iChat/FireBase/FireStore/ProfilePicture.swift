//
//  ProfilePicture.swift
//  iChat
//
//  Created by Azoz Salah on 28/01/2024.
//

import SwiftUI

struct ProfilePicture: Codable {
    let profilePicture: Data?
    
    enum CodingKeys: String, CodingKey {
        case profilePicture = "profile_picture"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.profilePicture, forKey: .profilePicture)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.profilePicture = try container.decodeIfPresent(Data.self, forKey: .profilePicture)
    }
    
    var profileImage: UIImage? {
        guard let data = profilePicture else {
            return nil
        }
        
        return UIImage(data: data)
    }
}
