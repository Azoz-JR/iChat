//
//  ChatChannelsListView.swift
//  iChat
//
//  Created by Azoz Salah on 25/08/2023.
//

import UIKit
import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct ChatChannelsListView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
        
    @StateObject private var chatsViewModel = ChatChannelListViewModel(channelListController: ChatClient.shared.channelListController(query: .init(filter: .and([.equal(.type, to: .messaging), .containMembers(userIds: [ChatClient.shared.currentUserId ?? ""])]), pageSize: 10)))
    
    @StateObject private var groupsViewModel = ChatChannelListViewModel(channelListController: ChatClient.shared.channelListController(query: .init(filter: .and([.equal(.type, to: .team), .containMembers(userIds: [ChatClient.shared.currentUserId ?? ""])]), pageSize: 10)))
    
    let type: ChannelType
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ChatChannelListView(viewFactory: CustomViewFactory.shared, viewModel: type == .messaging ? chatsViewModel : groupsViewModel, embedInNavigationView: false)
                
                Button {
                    withAnimation {
                        streamViewModel.showSearchUsersView = true
                    }
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.white)
                        .font(.title2)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .background {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(Color.primaryColor)
                        }
                        .padding()
                }
            }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        MessageAvatarView(avatarURL: streamViewModel.currentUser?.imageURL)
                            .modifier(CircleImageModifier())
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                streamViewModel.showingProfile = true
                            }
                        } label: {
                            Image(systemName: "gear")
                                .font(.title3.bold())
                                .foregroundColor(.primaryColor)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                            Text(type == .messaging ? "Chats" : "Groups")
                                .font(.title.bold())
                                .foregroundColor(.primaryColor)
                    }
                }
                .navigationBarBackButtonHidden()
                .fullScreenCover(isPresented: $streamViewModel.showSearchUsersView) {
                    NavigationStack {
                        SearchUsersView()
                    }
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
