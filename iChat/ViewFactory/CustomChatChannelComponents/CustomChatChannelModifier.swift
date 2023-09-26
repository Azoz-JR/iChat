//
//  CustomChatChannelModifier.swift
//  iChat
//
//  Created by Azoz Salah on 17/09/2023.
//

import Foundation
import StreamChat
import StreamChatSwiftUI
import SwiftUI


struct CustomChatChannelModifier: ChatChannelHeaderViewModifier {
    
    var channel: ChatChannel
    
    @State private var showingChannelInfo = false
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                CustomChatChannelHeader(channel: channel, showingChannelInfo: $showingChannelInfo)
            }
            .sheet(isPresented: $showingChannelInfo) {
                NavigationStack {
                    ChatChannelInfoView(channel: channel)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    showingChannelInfo = false
                                } label: {
                                    Text("Back")
                                        .foregroundColor(.primaryColor)
                                }
                            }
                        }
                }
            }
    }
}
