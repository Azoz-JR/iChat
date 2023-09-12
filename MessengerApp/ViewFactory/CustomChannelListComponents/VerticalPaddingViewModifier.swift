//
//  VerticalPaddingViewModifier.swift
//  MessengerApp
//
//  Created by Azoz Salah on 16/08/2023.
//

import SwiftUI

struct VerticalPaddingViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .listStyle(.insetGrouped)
            .padding(.vertical, 8)
    }
}
