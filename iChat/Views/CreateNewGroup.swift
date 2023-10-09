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
                Section {
                    TextField("Group Name", text: $streamViewModel.newGroupName)
                }
                .listRowBackground(Color.navigationBarColor)
                
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
            .listStyle(.grouped)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .scrollContentBackground(.hidden)
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
                    streamViewModel.searchUsers(searchText: newValue)
                }
            }
            .fullScreenCover(isPresented: $streamViewModel.showingSelectedChannel) {
                DirectChatChannelView()
        }
        .background(Color("ListBackground"))
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
