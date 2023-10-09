//
//  UserOnlineView.swift
//  iChat
//
//  Created by Azoz Salah on 16/08/2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct UserOnlineView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if !streamViewModel.onlineUsers.isEmpty {
                    ForEach(streamViewModel.onlineUsers) { user in
                        Button {
                            DispatchQueue.main.async {
                                streamViewModel.createDirectChannel(id: user.id.description)
                            }
                        } label: {
                            VStack(spacing: 4) {
                                ZStack(alignment: .bottomTrailing) {
                                    MessageAvatarView(avatarURL: user.imageURL, size: CGSize(width: 55, height: 55))
                                    
                                    
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(.green)
                                        .offset(x: -3, y: -3)
                                }
                                
                                Text(user.name ?? "User")
                                    .font(.system(size: 10))
                                    .lineLimit(2)
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 60)
                            .padding(.leading, 5)
                        }
                    }
                } else {
                    ForEach(0..<11, id: \.self) { _ in
                        ProgressView()
                            .frame(width: 55, height: 55)
                            .padding(.leading, 5)
                    }
                }
            }
        }
        .padding(.top)
    }
}

struct UserOnlineView_Previews: PreviewProvider {
    static var previews: some View {
        UserOnlineView()
            .environmentObject(StreamViewModel())
    }
}
