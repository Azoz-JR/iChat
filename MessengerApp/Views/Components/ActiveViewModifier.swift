//
//  ActiveViewModifier.swift
//  MessengerApp
//
//  Created by Azoz Salah on 18/08/2023.
//

import SwiftUI

struct ActiveViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing) {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.green)
                    .overlay {
                        Circle().stroke(.white, lineWidth: 1.5)
                    }
            }
    }
}
