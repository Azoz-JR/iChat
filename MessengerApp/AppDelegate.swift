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
        
        //Changing colors, fonts, images, channelNamer
        /*
        var colors = ColorPalette()
        colors.tintColor = Color(.streamBlue)

        var fonts = Fonts()
        fonts.footnoteBold = Font.footnote

        let images = Images()
        images.reactionLoveBig = UIImage(systemName: "heart.fill")!

        let appearance = Appearance(colors: colors, images: images, fonts: fonts)

        let channelNamer: ChatChannelNamer = { channel, currentUserId in
            "This is our custom name: \(channel.name ?? "no name")"
        }
        let utils = Utils(channelNamer: channelNamer)
         */
        
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
        guard let token = tokens[username] else {
            print("Sorry, we don't recognize this username")
            return
        }
        
        ChatClient.shared.connectUser(userInfo: UserInfo(id: username, name: username), token: Token(stringLiteral: token)) { error in
            if let error = error {
                print("ERROR CONNECTING USER: \(error.localizedDescription)")
                return
            }
            
            print("\(username) LOGGED IN SUCCESSFULLY!")
        }
        
    }
    
}
