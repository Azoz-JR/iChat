//
//  ChannelListHeaderModifier.swift
//  ChatApp
//
//  Created by Azoz Salah on 06/08/2023.
//

import SwiftUI
import StreamChatSwiftUI

struct CustomChannelModifier: ChannelListHeaderViewModifier {

    var title: String

    @State var profileShown = false

    func body(content: Content) -> some View {
        content.toolbar {
            CustomChannelHeader(title: title) {
                profileShown = true
            }
        }
        //.navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $profileShown) {
            SearchUsersView()
        }
    }
}

public struct CustomChannelListHeaderModifier: ChannelListHeaderViewModifier {
    public var title: String

    public init(title: String) {
        self.title = title
    }

    public func body(content: Content) -> some View {
        content.toolbar {
            CustomChatChannelListHeader(title: title)
        }
    }
}
