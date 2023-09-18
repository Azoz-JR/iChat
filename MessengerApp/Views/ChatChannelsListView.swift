//
//  ChatChannelsListView.swift
//  MessengerApp
//
//  Created by Azoz Salah on 25/08/2023.
//

import UIKit
import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct ChatChannelsListView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @StateObject private var channelHeaderLoader = ChannelHeaderLoader()
    
    @StateObject private var chatsViewModel = ChatChannelListViewModel(channelListController: ChatClient.shared.channelListController(query: .init(filter: .and([.equal(.type, to: .messaging), .containMembers(userIds: [ChatClient.shared.currentUserId ?? ""])]), pageSize: 10)))
    
    @StateObject private var groupsViewModel = ChatChannelListViewModel(channelListController: ChatClient.shared.channelListController(query: .init(filter: .and([.equal(.type, to: .team), .containMembers(userIds: [ChatClient.shared.currentUserId ?? ""])]), pageSize: 10)))
    
    let type: ChannelType
    
    var body: some View {
        NavigationStack {
            ChatChannelListView(viewFactory: CustomViewFactory.shared, viewModel: type == .messaging ? chatsViewModel : groupsViewModel, embedInNavigationView: false)
                .navigationTitle(type == .messaging ? "Chats" : "Groups")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarBackButtonHidden()
                .fullScreenCover(isPresented: $streamViewModel.showingProfile) {
                    ProfileView()
                }
                .fullScreenCover(isPresented: $streamViewModel.showSearchUsersView) {
                    NavigationStack {
                        SearchUsersView()
                    }
                }
                .onAppear {
                    streamViewModel.loadOnlineUsers()
                }
        }
        
    }
}

struct ChannelListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatChannelsListView(type: .messaging)
            .environmentObject(StreamViewModel())
    }
}
