//
//  StreamViewModel.swift
//  ChatApp
//
//  Created by Azoz Salah on 06/08/2023.
//

import Foundation
import SwiftUI
import StreamChat
import StreamChatSwiftUI


extension ChatClient {
    static var shared: ChatClient!
}


@MainActor
final class StreamViewModel: ObservableObject {
        
    @Published var showSignInView = false
    
    //Error Alert Variables
    @Published var error = false
    @Published var errorMsg = ""
    
    //Search For Users...
    @Published var showSearchUsersView = false
    @Published var searchText = ""
    @Published var searchResults: [ChatUser] = []
    @Published var suggestedUsers: [ChatUser] = []
    
    //Loading View State
    @Published var isLoading = false
    
    @Published var showingProfile = false
    
    //Create new group channel...
    @Published var newGroupUsers: [ChatUser] = []
    @Published var newGroupName = ""
    
    //Application Navigation bar display mode
    @Published var navBarDisplayMode: NavigationBarItem.TitleDisplayMode = .large
    
    
    //Open direct channel
    @Published var showingSelectedChannel = false
    @Published var selectedChannelController: ChatChannelController? = nil
    @Published var selectedChannelViewModel: ChatChannelViewModel? = nil
    
    //Loading Online users for the online users view
    @Published var onlineUsers: [ChatUser] = []
    
    
    var isSignedIn: Bool {
        ChatClient.shared.currentUserId != nil
    }
    
    var currentUser: String? {
        ChatClient.shared.currentUserId
    }
    
    
    func signOut() {
        if currentUser != nil {
            
            withAnimation {
                isLoading = true
            }
            
            ChatClient.shared.disconnect { [weak self] in
                
                withAnimation {
                    self?.isLoading = false
                }
                
                print("Client Disconnected")
            }
        } else {
            print("ERROR LOGGING OUT")
        }
    }
    
    func signIn(username: String, completion: @escaping (Bool) -> ()) {
        
        withAnimation {
            isLoading = true
        }
        
        ChatClient.shared.connectUser(userInfo: UserInfo(id: username), token: .development(userId: username)) { [weak self] error in
            
            withAnimation {
                self?.isLoading = false
            }
            
            if let error = error {
                self?.errorMsg = error.localizedDescription
                self?.error.toggle()
                return
            }
            
            print("\(username) LOGGED IN SUCCESSFULLY!")
            completion(error == nil)
        }
    }
        
    func createGroupChannel() {
        guard !newGroupUsers.isEmpty, !newGroupName.isEmpty else {
            self.errorMsg = "You have to write a group name"
            self.error.toggle()
            return
        }
        
        withAnimation {
            isLoading = true
        }
        
        let members: [String] = newGroupUsers.map { user in
            user.id.description
        }
                
        let channelId = ChannelId(type: .team, id: newGroupName)
        
        do {
            let request = try ChatClient.shared.channelController(createChannelWithId: channelId, name: newGroupName, imageURL: nil, members: Set(members), isCurrentUserMember: true)
                        
            request.synchronize { [weak self] error in
                
                withAnimation {
                    self?.isLoading = false
                }
                
                if let error = error {
                    self?.errorMsg = error.localizedDescription
                    print("ERROR CREATING NEW CHANNEL : \(error.localizedDescription)")
                    self?.error.toggle()
                
                    return
                }
                
                //else Successful...
                print("\(self?.newGroupName ?? "") CHANNEL CREATED SUCCESSFULLY!")
                
                self?.newGroupName = ""
                self?.newGroupUsers = []
                
                self?.selectedChannelViewModel = ChatChannelViewModel(channelController: request)
                
                self?.selectedChannelController = request
                
                self?.showingSelectedChannel = true
            }
        } catch {
            print("ERROR Creating CHANNEL: \(error.localizedDescription)")
        }
    }
    
    func createDirectChannel(id: String) {
        guard currentUser != nil, !id.isEmpty else {
            self.errorMsg = "User isn't logged in"
            self.error.toggle()
            return
        }
        
        withAnimation {
            isLoading = true
        }
        
        do {
            let request = try ChatClient.shared.channelController(createDirectMessageChannelWith: Set([id]), type: .messaging, isCurrentUserMember: true, name: id, extraData: [:])
            
            request.synchronize { [weak self] error in
                withAnimation {
                    self?.isLoading = false
                }
                
                if let error = error {
                    self?.errorMsg = error.localizedDescription
                    print("ERROR CREATING NEW CHANNEL : \(error.localizedDescription)")
                    self?.error.toggle()
                    
                    return
                }
                
                //else Successful...
                print("\(id) CHANNEL CREATED SUCCESSFULLY!")
                
                self?.selectedChannelViewModel = ChatChannelViewModel(channelController: request)
                
                self?.selectedChannelController = request
                
                self?.showingSelectedChannel = true
            }
        } catch {
            print("ERROR Creating Direct CHANNEL: \(error.localizedDescription)")
            return
        }
    }
    
    func searchUsers(searchText: String) {
        
        let controller = ChatClient.shared.userListController(query: .init(filter: .autocomplete(.name, text: searchText), pageSize: 10))
        
        controller.synchronize { [weak self] error in
            if let error = error {
                print("ERROR SEARCHING FOR USER: \(error.localizedDescription)")
                return
            }
            
            print("SEARCHED FIRST PAGE SUCCESSFULLY")
            
            self?.searchResults = controller.users.filter { $0.id.description != self?.currentUser}
            
            controller.loadNextUsers(limit: 10) { error in
                if let error = error {
                    print("ERROR SEARCHING FOR NEXT USERS: \(error.localizedDescription)")
                    return
                }
                
                self?.searchResults = controller.users.filter { $0.id.description != self?.currentUser}
                print("SEARCHED SECOND PAGE SUCCESSFULLY")
            }
        }
    }
    
    func loadSuggestedResults() {
        guard suggestedUsers.isEmpty else {
            return
        }
        
        let controller = ChatClient.shared.userListController(query: .init(filter: .equal(.role, to: .user), pageSize: 10))
        
        controller.synchronize { [weak self] error in
            if let error = error {
                print("ERROR LOADING SUGGESTED USERS: \(error.localizedDescription)")
                return
            }
            
            print("LOADED SUGGESTED USERS SUCCESSFULLY")
            
            self?.suggestedUsers = controller.users.filter { $0.id.description != self?.currentUser}
        }
    }
    
    func loadOnlineUsers() {
        guard onlineUsers.isEmpty else {
            return
        }
        
        let keys: [String] = tokens.keys.map {$0}
        
        let controller = ChatClient.shared.userListController(query: .init(filter: .in(.id, values: keys), pageSize: 10))
        
        controller.synchronize { [weak self] error in
            if let error = error {
                print("ERROR QUERYING ONLINE USERS: \(error.localizedDescription)")
                return
            }
            
            print("QUERIED FIRST PAGE SUCCESSFULLY")
            self?.onlineUsers = controller.users.filter { ($0.id.description != self?.currentUser) }
        }
    }
    
}
