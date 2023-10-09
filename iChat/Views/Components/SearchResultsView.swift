//
//  SearchResultsView.swift
//  iChat
//
//  Created by Azoz Salah on 27/08/2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct SearchUsersResultsView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    let results: [ChatUser]
    
    var body: some View {
        ForEach(results) { user in
            Button {
                DispatchQueue.main.async {
                    streamViewModel.createDirectChannel(id: user.id.description)
                }
            } label: {
                HStack {
                    MessageAvatarView(avatarURL: user.imageURL)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.name ?? "Unknown User")
                            .lineLimit(1)
                            .font(.headline)
                        
                        if user.isOnline {
                            Text("Active Now")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else if let lastSeen = user.lastActiveAt {
                            Text(lastSeenTime(from: lastSeen))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                }
                .frame(height: 40)
            }
        }
    }
}


#Preview {
    SearchUsersResultsView(results: [])
        .environmentObject(StreamViewModel())
}
