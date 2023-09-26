//
//  CustomComposerBackground.swift
//  iChat
//
//  Created by Azoz Salah on 31/08/2023.
//

import StreamChatSwiftUI
import SwiftUI

struct ComposerBackgroundViewModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .background(Color.navigationBarColor)
    }
}
