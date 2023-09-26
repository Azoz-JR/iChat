//
//  MessageListConfig.swift
//  iChat
//
//  Created by Azoz Salah on 19/08/2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

var customTransition: AnyTransition {
    .scale.combined(with:
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        )
    )
}

let messageDisplayOptions = MessageDisplayOptions(animateChanges: true, minimumSwipeGestureDistance: 50, currentUserMessageTransition: customTransition, otherUserMessageTransition: customTransition, shouldAnimateReactions: true)

let messageListConfig = MessageListConfig(typingIndicatorPlacement: .navigationBar, messageDisplayOptions: messageDisplayOptions, doubleTapOverlayEnabled: true, showNewMessagesSeparator: true)
