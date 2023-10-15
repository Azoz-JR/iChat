//
//  CustomChatChannelHeader.swift
//  iChat
//
//  Created by Azoz Salah on 18/08/2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI


public struct CustomChatChannelHeader: ToolbarContent {
    
    @Injected(\.chatClient) public var chatClient
    
    public var channel: ChatChannel
    
    @Binding var showingChannelInfo: Bool
    
    @Environment(\.dismiss) var dismiss
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.primaryColor)
            }
        }
        
        ToolbarItem(placement: .topBarLeading) {
            MessageAvatarView(avatarURL: channel.imageURL != nil ? channel.imageURL : channelImage())
        }
        
        ToolbarItem(placement: .topBarLeading) {
            VStack(alignment: .leading, spacing: 2) {
                Text(channelName())
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if isActive(channel) {
                    Text("Online")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                } else {
                    Text(lastSeenTime(from: lastActiveDate(channel)))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showingChannelInfo = true
            } label: {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.primaryColor)
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
        let date = channel.lastActiveMembers.filter {$0.id != chatClient.currentUserId}.first?.lastActiveAt ?? .now
        
        return date
    }
    
    func channelName() -> String {
        let channelMembers = channel.lastActiveMembers.filter { $0.id != chatClient.currentUserId }
        
        // Direct channel condition
        if channelMembers.count == 1 {
            if let name = channelMembers.first?.name {
                return name
            }
        }
        
        // Group channel condition
        if let name = channel.name {
            return name
        }
        
        guard let channelName = channelMembers.first?.name else {
            return "Unknown User"
        }
        
        return channelName
    }
    
    func channelImage() -> URL? {
        guard channel.imageURL == nil else {
            return channel.imageURL
        }
        
        let image = channel.lastActiveMembers.filter { $0.id != chatClient.currentUserId }.first?.imageURL
        
        return image
    }
}
