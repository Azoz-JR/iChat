//
//  SearchUsersView.swift
//  MessengerApp
//
//  Created by Azoz Salah on 19/08/2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct SearchUsersView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $streamViewModel.searchText, barColor: Color(hex: 0xf8f9fa), prompt: "Search users")
                .padding(.horizontal, 10)
                .padding(.top, 10)
            
            List {
                Section("Create group") {
                    NavigationLink {
                        CreateNewGroup()
                    } label: {
                        HStack {
                            Image(systemName: "person.3.fill")
                            
                            Text("Group Chat")
                        }
                    }
                }
                .listRowBackground(Color(hex: 0xf8f9fa))
                
                Group {
                    if streamViewModel.searchText.isEmpty {
                        Section("Suggested") {
                            SearchUsersResultsView(results: streamViewModel.suggestedUsers)
                        }
                    } else {
                        Section {
                            SearchUsersResultsView(results: streamViewModel.searchResults)
                        }
                    }
                }
                .alignmentGuide(.listRowSeparatorLeading) { d in
                    d[.leading]
                }
                .listRowBackground(Color(hex: 0xf8f9fa))
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        streamViewModel.showSearchUsersView = false
                        streamViewModel.searchText = ""
                        streamViewModel.searchResults = []
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .padding(.bottom)
                    }
                }
            }
            .onChange(of: streamViewModel.searchText) { newValue in
                if !newValue.isEmpty {
                    streamViewModel.searchUsers(searchText: newValue)
                }
            }
            .onAppear {
                if streamViewModel.searchText.isEmpty {
                    streamViewModel.loadSuggestedResults()
                }
            }
            .alert("ERROR CREATING NEW DIRECT CHANNEL...", isPresented: $streamViewModel.error) {
                Button("OK") {}
            } message: {
                Text(streamViewModel.errorMsg)
            }
            .fullScreenCover(isPresented: $streamViewModel.showingSelectedChannel) {
                DirectChatChannelView()
        }
        }
        .background(Color(hex: 0xe9ecef))
        
    }
}

struct SearchUsersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchUsersView()
                .environmentObject(StreamViewModel())
        }
    }
}
