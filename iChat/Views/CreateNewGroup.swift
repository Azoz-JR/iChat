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
    
    @FocusState private var focused: Bool
    
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
                //.listRowBackground(Color("ListRowBackground"))
            }
            .listStyle(.grouped)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
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
                        .background(Color.navigationBarColor)
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        DispatchQueue.main.async {
                            streamViewModel.createGroupChannel()
                        }
                    } label: {
                        Text("Create")
                            .disabled(streamViewModel.newGroupUsers.count < 2)
                    }
                }
            }
            .onAppear {
                focused = true
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
