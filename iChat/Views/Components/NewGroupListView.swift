//
//  NewGroupListView.swift
//  iChat
//
//  Created by Azoz Salah on 30/08/2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI


struct NewGroupListView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
        
    let results: [ChatUser]
    
    var body: some View {
        ForEach(results) { user in
            Button {
                if streamViewModel.newGroupUsers.contains(user) {
                    withAnimation {
                        streamViewModel.newGroupUsers.removeAll { $0 == user }
                    }
                } else {
                    withAnimation {
                        streamViewModel.newGroupUsers.append(user)
                    }
                }
            } label: {
                HStack {
                    MessageAvatarView(avatarURL: user.imageURL)
                    
                    
                    Text(user.name ?? "Unknown User")
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .font(.headline)
                    
                    Spacer()
                    
                    if streamViewModel.newGroupUsers.contains(user) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.primaryColor)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    
                }
                .frame(height: 40)
            }
        }
    }
}


struct NewGroupListView_Previews: PreviewProvider {
    static var previews: some View {
        NewGroupListView(results: [])
            .environmentObject(StreamViewModel())
    }
}
