//
//  CustomViewFactory.swift
//  iChat
//
//  Created by Azoz Salah on 06/08/2023.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI


class CustomViewFactory: ViewFactory {
    
    static let shared = CustomViewFactory()
        
    @Injected(\.chatClient) public var chatClient
    
    private init() { }
    
    func navigationBarDisplayMode() -> NavigationBarItem.TitleDisplayMode {
        .inline
    }
    
    // 1. Customize the no channels view
    func makeNoChannelsView() -> some View {
        NoChannelsYet()
    }
    
    // 2. Change the channel list background color
//    func makeChannelListBackground(colors: ColorPalette) -> some View {
//        BackgroundView()
//    }

    // 3. Customize the list divider
    func makeChannelListDividerItem() -> some View {
        //EmptyView()
        CustomListRowSeparator()
    }

    // 4. Add a custom-made channel list header
    func makeChannelListHeaderViewModifier(title: String) -> some ChannelListHeaderViewModifier {
            CustomChannelModifier(title: title)
        }

    // 6. Add a vertical padding to the top of the channel list
    func makeChannelListModifier() -> some ViewModifier {
        VerticalPaddingViewModifier()
    }
    
    func makeChannelHeaderViewModifier(for channel: ChatChannel) -> some ChatChannelHeaderViewModifier {
        CustomChatChannelModifier(channel: channel)
    }
    
    func makeChannelListTopView(searchText: Binding<String>) -> some View {
        VStack(spacing: 0) {
            SearchBar(text: searchText, barColor: Color.gray.opacity(0.2), prompt: "Search messages")
                .padding(.top, 10)
                .padding(.horizontal, 10)
            
            UserOnlineView()
        }
    }
    
    func makeEmptyMessagesView(for channel: ChatChannel, colors: ColorPalette) -> some View {
        ZStack {
            Color.primaryColor.opacity(0.1).ignoresSafeArea()
            
            Text("No messages yet, enter the first one by tapping on the composer at the bottom of the screen.")
                .padding()
                .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.primary, lineWidth: 2)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
        }
    }
    
    func makeMessageListBackground(colors: ColorPalette, isInThread: Bool) -> some View {
        Color.listBackgroundColor
    }
    
    func makeComposerViewModifier() -> some ViewModifier {
        ComposerBackgroundViewModifier()
    }
    
}
