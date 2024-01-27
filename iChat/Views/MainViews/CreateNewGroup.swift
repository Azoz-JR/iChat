//
//  CreateNewGroup.swift
//  iChat
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
        List {
//            Section {
//                TextField("Group Name", text: $streamViewModel.newGroupName)
//            }
//            .listRowBackground(Color.navigationBarColor)
            
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
        }
        .navigationTitle("New group")
        .listStyle(.grouped)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .top, content: {
            VStack {
                TextField("Group Name", text: $streamViewModel.newGroupName)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                
                SearchBar(text: $streamViewModel.searchText, barColor: .gray.opacity(0.2), prompt: "Search users", cancelButton: false)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
            }
            .background(Color.navigationBarColor)
        })
        .toolbar {
            CreateNewGroupHeader()
        }
        .onDisappear {
            streamViewModel.searchText = ""
            streamViewModel.searchResults = []
            streamViewModel.newGroupName = ""
            streamViewModel.newGroupUsers = []
        }
        .onChange(of: streamViewModel.searchText) { newValue in
            if !newValue.isEmpty {
                DispatchQueue.mainAsyncIfNeeded {
                    streamViewModel.searchUsers(searchText: newValue)
                }
            }
        }
        .navigationDestination(isPresented: $streamViewModel.showingSelectedChannel) {
            DirectChatChannelView()
        }
        .alert("ERROR CREATING NEW GROUP...", isPresented: $streamViewModel.error) {
            Button("OK") { }
        } message: {
            Text(streamViewModel.errorMsg)
        }
        
    }
}

#Preview {
    NavigationStack {
        CreateNewGroup()
            .environmentObject(StreamViewModel())
    }
}
