//
//  CreateNewGroupHeader.swift
//  iChat
//
//  Created by Azoz Salah on 09/10/2023.
//

import SwiftUI

struct CreateNewGroupHeader: ToolbarContent {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some ToolbarContent {
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
}
