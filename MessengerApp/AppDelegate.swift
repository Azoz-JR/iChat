//
//  AppDelegate.swift
//  MessengerApp
//
//  Created by Azoz Salah on 14/08/2023.
//

import Foundation
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
        
        ChatClient.shared = chatClient
        
        var colors = ColorPalette()
        colors.messageCurrentUserBackground = [UIColor(Color("AppBlue"))]
        colors.messageCurrentUserTextColor = UIColor(.white)
        colors.tintColor = Color("AppBlue")
        colors.textLowEmphasis = .secondaryLabel
        
        let utils = Utils(messageListConfig: messageListConfig)
        
        let appearance = Appearance(colors: colors)
        
        streamChat = StreamChat(chatClient: ChatClient.shared, appearance: appearance, utils: utils)
        
        guard ChatClient.shared.currentUserId == nil else {
            connectUser(username: ChatClient.shared.currentUserId!)
            return true
        }
        
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
    
}
