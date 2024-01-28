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
    @Published var profilePicture: UIImage? = nil
    
    
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
    
    
    // MARK: - Methods
    
    func signOut() {
        guard currentUserId != nil else {
            self.showError(errorMessage: "You already signed out!")
            return
        }
        
        ChatClient.shared.logout { [weak self] in
            DispatchQueue.mainAsyncIfNeeded {
                self?.showSignInView = true
                self?.showingProfile = false
                self?.profilePicture = nil
            }
            
        }
    }
    
    func signUp(userId: String, username: String) {
        withAnimation {
            self.isLoading = true
        }
        
        ChatClient.shared.connectUser(userInfo: UserInfo(id: userId, name: username), token: .development(userId: userId)) { [weak self] error in
            
            DispatchQueue.mainAsyncIfNeeded {
                if let error = error {
                    self?.showError(errorMessage: error.localizedDescription)
                    self?.isLoading = false
                    return
                }
                
                self?.isLoading = false
                self?.showSignInView = false
                self?.fetchCurrentUserProfilePicture()
            }
        }
    }
    
    func signIn(userId: String) {
        withAnimation {
            self.isLoading = true
        }
        
        ChatClient.shared.connectUser(userInfo: UserInfo(id: userId), token: .development(userId: userId)) { [weak self] error in
            DispatchQueue.mainAsyncIfNeeded {
                if let error = error {
                    self?.showError(errorMessage: error.localizedDescription)
                    return
                }
                
                self?.isLoading = false
                self?.showSignInView = false
                self?.fetchCurrentUserProfilePicture()
            }
        }
    }
    
    func createGroupChannel() {
        guard !newGroupUsers.isEmpty, !newGroupName.isEmpty else {
            self.showError(errorMessage: "You have to enter a name for the group.")
            return
        }
        
        withAnimation {
            self.isLoading = true
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
                DispatchQueue.mainAsyncIfNeeded {
                    withAnimation {
                        self?.isLoading = false
                    }
                    
                    if let error = error {
                        self?.showError(errorMessage: error.localizedDescription)
                        return
                    }
                    
                    // Successful...
                    self?.newGroupName = ""
                    self?.newGroupUsers = []
                    
                    self?.selectedChannelViewModel = ChatChannelViewModel(channelController: request)
                    self?.selectedChannelController = request
                    self?.showingSelectedChannel = true
                }
            }
        } catch {
            DispatchQueue.mainAsyncIfNeeded {
                self.showError(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func createDirectChannel(id: String, completion: @escaping () -> Void) {
        guard currentUserId != nil, !id.isEmpty else {
            self.showError(errorMessage: "You aren't logged in.")
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
                DispatchQueue.mainAsyncIfNeeded {
                    withAnimation {
                        self?.isLoading = false
                    }
                    
                    if let error = error {
                        self?.showError(errorMessage: error.localizedDescription)
                        return
                    }
                    
                    // Successful...
                    self?.selectedChannelViewModel = ChatChannelViewModel(channelController: request)
                    self?.selectedChannelController = request
                    DispatchQueue.mainAsyncIfNeeded {
                        completion()
                    }
                }
            }
        } catch {
            DispatchQueue.mainAsyncIfNeeded {
                self.showError(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func searchUsers(searchText: String) {
        let controller = ChatClient.shared.userListController(query: .init(filter: .autocomplete(.name, text: searchText), pageSize: 10))
        
        controller.synchronize { [weak self] error in
            DispatchQueue.mainAsyncIfNeeded {
                if let error = error {
                    self?.showError(errorMessage: error.localizedDescription)
                    return
                }
                
                self?.searchResults = controller.users.filter { $0.id.description != self?.currentUserId }
            }
            
            controller.loadNextUsers(limit: 10) { error in
                if error != nil {
                    return
                }
                DispatchQueue.mainAsyncIfNeeded {
                    self?.searchResults = controller.users.filter { $0.id.description != self?.currentUserId }
                }
            }
        }
    }
    
    func loadSuggestedResults() {
        let controller = ChatClient.shared.userListController(query: .init(filter: .equal(.role, to: .user), pageSize: 10))
        
        controller.synchronize { [weak self] error in
            DispatchQueue.mainAsyncIfNeeded {
                if let error = error {
                    self?.showError(errorMessage: error.localizedDescription)
                    return
                }
                            
                self?.suggestedUsers = controller.users.filter { $0.id.description != self?.currentUserId }
            }
        }
    }
    
    func loadOnlineUsers() {
        let controller = ChatClient.shared.userListController(query: .init(pageSize: 10))
        
        controller.synchronize { [weak self] error in
            DispatchQueue.mainAsyncIfNeeded {
                if let error = error {
                    self?.showError(errorMessage: error.localizedDescription)
                    return
                }
                
                self?.onlineUsers = controller.users.filter { $0.id.description != self?.currentUserId }
            }
        }
    }
    
    func showError(errorMessage: String) {
        errorMsg = errorMessage
        error.toggle()
    }
    
    func changeProfilePicture(picture: UIImage) {
        guard let resizedPicture = resizeImage(image: picture, targetSize: CGSize(width: 300, height: 300)) else {
            return
        }
        
        guard let pictureData = resizedPicture.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        guard let currentUserId else {
            return
        }
        
        withAnimation {
            isLoading = true
        }
        
        Task {
            do {
                try await UserManager.shared.updateUserProfilePicture(userId: currentUserId, picture: pictureData)
                
                fetchCurrentUserProfilePicture()
                
                await MainActor.run {
                    withAnimation {
                        isLoading = false
                    }
                }
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        }
    }
    
    func fetchCurrentUserProfilePicture() {
        Task {
            guard let userId = currentUserId, let image = try await UserManager.shared.getUserProfilePicture(userId: userId) else {
                profilePicture = UIImage(systemName: "photo")!
                return
            }
            
            await MainActor.run {
                profilePicture = image
            }
        }
    }
    
    func fetchUserPicture(userId: String, completion: @escaping (UIImage?, Error?) -> Void) {
        Task {
            do {
                let picture = try await UserManager.shared.getUserProfilePicture(userId: userId)
                
                await MainActor.run {
                    completion(picture, nil)
                }
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    completion(nil, error)
                }
            }
        }
    }
    
}
