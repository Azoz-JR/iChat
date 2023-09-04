//
//  CreateNewGroup.swift
//  MessengerApp
//
//  Created by Azoz Salah on 28/08/2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct CreateNewGroup: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $streamViewModel.searchText, barColor: Color(hex: 0xf8f9fa), prompt: "Search users")
                .padding(.horizontal, 10)
                .padding(.top, 10)
            
            List {
                Section {
                    TextField("Group Name", text: $streamViewModel.newGroupName)
                }
                .listRowBackground(Color(hex: 0xf8f9fa))
                
                Group {
                    if streamViewModel.searchText.isEmpty {
                        Section("Suggested") {
                            NewGroupListView(results: streamViewModel.suggestedUsers)
                        }
                    } else {
                        Section {
                            NewGroupListView(results: streamViewModel.searchResults)
                        }
                    }
                }
                .alignmentGuide(.listRowSeparatorLeading) { d in
                    d[.leading]
                }
                .listRowBackground(Color(hex: 0xf8f9fa))
            }
            .navigationTitle("New Group")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .scrollContentBackground(.hidden)
            .toolbar {
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
                        DispatchQueue.main.async {
                            streamViewModel.createChannel()
                        }
                    } label: {
                        Text("Create")
                            .foregroundColor(streamViewModel.newGroupUsers.count < 2 ? .white.opacity(0.4) : .white)
                            .disabled(streamViewModel.newGroupUsers.count < 2)
                    }
                }
            }
            .onDisappear {
                streamViewModel.searchText = ""
                streamViewModel.searchResults = []
                streamViewModel.newGroupName = ""
                streamViewModel.newGroupUsers = []
            }
            .onChange(of: streamViewModel.searchText) { newValue in
                if !newValue.isEmpty {
                    streamViewModel.searchUsers(searchText: newValue)
                }
            }
            .fullScreenCover(isPresented: $streamViewModel.showingSelectedChannel) {
                DirectChatChannelView()
        }
        }
        .background(Color(hex: 0xe9ecef))
    }
}

struct CreateNewGroup_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateNewGroup()
                .environmentObject(StreamViewModel())
        }
    }
}
