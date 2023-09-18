//
//  CustomChatChannelHeader.swift
//  MessengerApp
//
//  Created by Azoz Salah on 18/08/2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI


public struct CustomChatChannelHeader: ToolbarContent {
    
    public var channel: ChatChannel
    
    @Binding var showingChannelInfo: Bool
    
    @Environment(\.dismiss) var dismiss
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack(alignment: .leading, spacing: 2) {
                Text(channelName())
                    .font(.headline)
                    .foregroundColor(.white)
                
                if isActive(channel) {
                    Text("Online")
                        .font(.caption.bold())
                        .foregroundColor(.secondaryText)
                } else {
                    Text(lastSeenTime(from: lastActiveDate(channel)))
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }
            }
            .hLeading()
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
            }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
            MessageAvatarView(avatarURL: channel.imageURL != nil ? channel.imageURL : channelImage())
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showingChannelInfo = true
            } label: {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.white)
            }
        }
    }
}


// MARK: Channel Header Helper functions

extension CustomChatChannelHeader {
    
    private func isActive(_ channel: ChatChannel) -> Bool {
        let count = channel.lastActiveMembers.filter { member in
            member.isOnline
        }
            .count
        
        // 1 is the current user
        return count > 1
    }
    
    private func lastActiveDate(_ channel: ChatChannel) -> Date {
        let date = channel.lastActiveMembers.filter {$0.id != ChatClient.shared.currentUserId}.first?.lastActiveAt ?? .now
        
        return date
    }
    
    func channelName() -> String {
        let channelMembers = channel.lastActiveMembers.filter { $0.id != ChatClient.shared.currentUserId }
        
        guard let channelName = channelMembers.first?.id else {
            return "UNKNOWN"
        }
        
        return channelName
    }
    
    func channelImage() -> URL? {
        guard channel.imageURL == nil else {
            return channel.imageURL
        }
        
        let image = channel.lastActiveMembers.filter { $0.id != ChatClient.shared.currentUserId }.first?.imageURL
        
        return image
    }
}
