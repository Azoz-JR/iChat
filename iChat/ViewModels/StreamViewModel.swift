//
//  StreamViewModel.swift
//  iChat
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
    
    // MARK: - Published Properties
    
    @Published var showSignInView = false
    @Published var error = false
    @Published var errorMsg = ""
    @Published var showSearchUsersView = false
    @Published var searchText = ""
    @Published var searchResults: [ChatUser] = []
    @Published var suggestedUsers: [ChatUser] = []
    @Published var isLoading = false
    @Published var showingProfile = false
    @Published var newGroupUsers: [ChatUser] = []
    @Published var newGroupName = ""
    @Published var showingSelectedChannel = false
    @Published var selectedChannelController: ChatChannelController? = nil
    @Published var selectedChannelViewModel: ChatChannelViewModel? = nil
    @Published var onlineUsers: [ChatUser] = []
    @Published var showingChangeProfilePictureSheet = false
    @Published var isSearchBarFocused = false
    @AppStorage("colorScheme") var userPrefersDarkMode: Bool = false
    @Published var showForgotPasswordView = false
    @Published var showAlert = false
    
    
    // MARK: - Computed Properties
    
    var isSignedIn: Bool {
        guard ChatClient.shared.currentUserId != nil else {
            return false
        }
        
        if let _ = try? AuthenticationManager.shared.getAuthenticatedUser() {
            return true
        } else {
            return false
        }
    }
    
    var currentUserId: String? {
        ChatClient.shared.currentUserId
    }
    
    var currentUser: CurrentChatUser? {
        ChatClient.shared.currentUserController().currentUser
    }
    
    var imageURL: URL? {
        guard let fileName = currentUserId else {
            return nil
        }
        
        return FileManager.documnetsDirectory.appending(path: "\(fileName).jpg")
    }
    
    
    // MARK: - Methods
    
    func signOut() {
        guard currentUserId != nil else {
            self.errorMsg = "You already signed out"
            self.error.toggle()
            return
        }
        
        ChatClient.shared.logout { [weak self] in
            self?.showSignInView = true
            self?.showingProfile = false
        }
    }
    
    func signUp(userId: String, username: String) {
        
        withAnimation {
            isLoading = true
        }
        
        ChatClient.shared.connectUser(userInfo: UserInfo(id: userId, name: username), token: .development(userId: userId)) { [weak self] error in
            if let error = error {
                self?.errorMsg = error.localizedDescription
                self?.error.toggle()
                self?.isLoading = false
                return
            }
            
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.showSignInView = false
            }
        }
    }
    
    func signIn(userId: String) {
        
        withAnimation {
            isLoading = true
        }
        
        ChatClient.shared.connectUser(userInfo: UserInfo(id: userId), token: .development(userId: userId)) { [weak self] error in
            if let error = error {
                self?.errorMsg = error.localizedDescription
                self?.error.toggle()
                return
            }
            
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.showSignInView = false
            }
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
            let request = try ChatClient.shared.channelController(
                createChannelWithId: channelId,
                name: newGroupName,
                imageURL: nil,
                members: Set(members),
                isCurrentUserMember: true
            )
            
            request.synchronize { [weak self] error in
                withAnimation {
                    self?.isLoading = false
                }
                
                if let error = error {
                    self?.errorMsg = error.localizedDescription
                    self?.error.toggle()
                    return
                }
                
                // Successful...
                self?.newGroupName = ""
                self?.newGroupUsers = []
                
                self?.selectedChannelViewModel = ChatChannelViewModel(channelController: request)
                self?.selectedChannelController = request
                self?.showingSelectedChannel = true
            }
        } catch {
            self.errorMsg = error.localizedDescription
            self.error = true
        }
    }
    
    func createDirectChannel(id: String) {
        guard currentUserId != nil, !id.isEmpty else {
            self.errorMsg = "User isn't logged in"
            self.error.toggle()
            return
        }
        
        withAnimation {
            isLoading = true
        }
        
        do {
            let request = try ChatClient.shared.channelController(
                createDirectMessageChannelWith: Set([id]),
                type: .messaging,
                isCurrentUserMember: true,
                extraData: [:]
            )
            
            request.synchronize { [weak self] error in
                withAnimation {
                    self?.isLoading = false
                }
                
                if let error = error {
                    self?.errorMsg = error.localizedDescription
                    self?.error.toggle()
                    return
                }
                
                // Successful...
                self?.selectedChannelViewModel = ChatChannelViewModel(channelController: request)
                self?.selectedChannelController = request
                self?.showingSelectedChannel = true
            }
        } catch {
            self.errorMsg = error.localizedDescription
            self.error = true
        }
    }
    
    func searchUsers(searchText: String) {
        let controller = ChatClient.shared.userListController(query: .init(filter: .autocomplete(.name, text: searchText), pageSize: 10))
        
        controller.synchronize { [weak self] error in
            if let error = error {
                self?.errorMsg = error.localizedDescription
                self?.error.toggle()
                return
            }
                        
            self?.searchResults = controller.users.filter { $0.id.description != self?.currentUserId }
            
            controller.loadNextUsers(limit: 10) { error in
                if error != nil {
                    return
                }
                
                self?.searchResults = controller.users.filter { $0.id.description != self?.currentUserId }
            }
        }
    }
    
    func loadSuggestedResults() {
        let controller = ChatClient.shared.userListController(query: .init(filter: .equal(.role, to: .user), pageSize: 10))
        
        controller.synchronize { [weak self] error in
            if let error = error {
                self?.errorMsg = error.localizedDescription
                self?.error.toggle()
                return
            }
                        
            self?.suggestedUsers = controller.users.filter { $0.id.description != self?.currentUserId }
        }
    }
    
    func loadOnlineUsers() {
        let controller = ChatClient.shared.userListController(query: .init(pageSize: 10))
        
        controller.synchronize { [weak self] error in
            if let error = error {
                self?.errorMsg = error.localizedDescription
                self?.error.toggle()
                return
            }
            
            self?.onlineUsers = controller.users.filter { $0.id.description != self?.currentUserId }
        }
    }
    
}
