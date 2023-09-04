//
//  CustomChannelHeader.swift
//  ChatApp
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
    var onTapLeading: () -> ()

    @State private var callType = "All"
    var calls = ["All", "Missed"]

    public var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                streamViewModel.showingProfile = true
            } label: {
                Image("profile")
                    .resizable()
                    .scaledToFill()
                    .modifier(CircleImageModifier())
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                streamViewModel.showSearchUsersView = true
            } label: {
                Image(systemName: "square.and.pencil")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }
}

public struct CustomChatChannelListHeader: ToolbarContent {
    @Injected(\.fonts) private var fonts
    @Injected(\.images) private var images

    public var title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("")
                .font(fonts.bodyBold)
        }
    }
}
