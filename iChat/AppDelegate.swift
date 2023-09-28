//
//  AppDelegate.swift
//  iChat
//
//  Created by Azoz Salah on 14/08/2023.
//

import Foundation
import FirebaseCore
import UIKit
import StreamChat
import StreamChatSwiftUI
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var streamChat: StreamChat?
    
    var chatClient: ChatClient = {
        
        var config = ChatClientConfig(apiKeyString: APIKey)
        
        config.isLocalStorageEnabled = true
        
        let client = ChatClient(config: config)
        return client
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        ChatClient.shared = chatClient
        
        var colors = ColorPalette()
        colors.messageCurrentUserBackground = [UIColor(Color.primaryColor)]
        colors.messageCurrentUserTextColor = UIColor(.white)
        colors.messageOtherUserTextColor = UIColor(Color.primaryText)
        colors.tintColor = .primaryColor
        
        let utils = Utils(messageListConfig: messageListConfig)
        
        let appearance = Appearance(colors: colors)
        
        streamChat = StreamChat(chatClient: ChatClient.shared, appearance: appearance, utils: utils)
        
        getAuthUser()
        
        return true
    }
    
    func connectUser(username: String) {
        ChatClient.shared.connectUser(userInfo: UserInfo(id: username, name: username), token: .development(userId: username)) { error in
            if let error = error {
                print("ERROR CONNECTING USER: \(error.localizedDescription)")
                return
            }
            
            print("\(username) LOGGED IN SUCCESSFULLY!")
        }
    }
    
    func getAuthUser() {
        // Check if the user is authenticated on view appearance
        if let authUser = try? AuthenticationManager.shared.getAuthenticatedUser() {
            
            if let userId = ChatClient.shared.currentUserId {
                connectUser(username: userId)
            }
        }
    }
    
}
