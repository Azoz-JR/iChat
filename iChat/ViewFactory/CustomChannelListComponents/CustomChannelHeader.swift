//
//  CustomChannelHeader.swift
//  iChat
//
//  Created by Azoz Salah on 06/08/2023.
//

import SwiftUI
import StreamChatSwiftUI

public struct CustomChannelHeader: ToolbarContent {
    
    @EnvironmentObject var streamViewModel: StreamViewModel

    @Injected(\.fonts) var fonts
    @Injected(\.images) var images

    var title: String

    public var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            MessageAvatarView(avatarURL: streamViewModel.currentUser?.imageURL)
                .modifier(CircleImageModifier())
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                streamViewModel.showingProfile = true
            } label: {
                Image(systemName: "gear")
                    .font(.title3.bold())
                    .foregroundColor(.primaryColor)
            }
        }
    }
}
