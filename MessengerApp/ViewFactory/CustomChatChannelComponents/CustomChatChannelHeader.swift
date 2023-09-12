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
    
    @Environment(\.dismiss) var dismiss
    @State private var isShowingChannelInfo = false
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack(alignment: .center) {
                Text(channelName())
                    .font(.headline)
                    .foregroundColor(.white)
                
                if isActive(channel) {
                    Text("Online")
                        .font(.caption.bold())
                        .foregroundColor(Color(hex: 0x70e000))
                } else {
                    Text(lastSeenTime(from: lastActiveDate(channel)))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showingChannelInfo = true
            } label: {
                MessageAvatarView(avatarURL: channel.imageURL != nil ? channel.imageURL : channelImage())
            }
        }
    }
}


struct CustomChatChannelModifier: ChatChannelHeaderViewModifier {
    
    var channel: ChatChannel
    
    @State private var showingChannelInfo = false
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                CustomChatChannelHeader(channel: channel, showingChannelInfo: $showingChannelInfo)
            }
            .sheet(isPresented: $showingChannelInfo) {
                NavigationStack {
                    ChatChannelInfoView(channel: channel)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    showingChannelInfo = false
                                } label: {
                                    Text("Back")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                }
            }
    }
}
