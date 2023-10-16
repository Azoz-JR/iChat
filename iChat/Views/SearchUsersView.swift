//
//  SearchUsersView.swift
//  iChat
//
//  Created by Azoz Salah on 19/08/2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct SearchUsersView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    var transitionEdge: AnyTransition = .move(edge: .trailing)
    
    @FocusState private var focused: Bool
    
    var body: some View {
        List {
            if streamViewModel.searchText.isEmpty {
                Section {
                    NavigationLink {
                        CreateNewGroup()
                    } label: {
                        HStack {
                            Image(systemName: "person.3.fill")
                            
                            Text("Group Chat")
                        }
                    }
                } header: {
                    Text("Create Group")
                }
            }
            
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
        }
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .background(Color("ListBackground"))
        .transition(transitionEdge)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    streamViewModel.showSearchUsersView = false
                    streamViewModel.searchText = ""
                    streamViewModel.searchResults = []
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primaryColor)
                }
            }
            
            ToolbarItem(placement: .principal) {
                TextField("Search users", text: $streamViewModel.searchText)
                    .focused($focused)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color(.searchBar))
                    .cornerRadius(5)
                    .overlay {
                        HStack {
                            Spacer()
                            
                            if !streamViewModel.searchText.isEmpty {
                                Button {
                                    streamViewModel.searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    }
            }
            
        }
        .onChange(of: streamViewModel.searchText) { newValue in
            if !newValue.isEmpty {
                streamViewModel.searchUsers(searchText: newValue)
            }
        }
        .onAppear {
            focused = true
            
            streamViewModel.loadSuggestedResults()
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
}

struct SearchUsersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchUsersView()
                .environmentObject(StreamViewModel())
        }
    }
}
