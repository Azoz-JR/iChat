//
//  CircleImageModifier.swift
//  iChat
//
//  Created by Azoz Salah on 18/08/2023.
//

import SwiftUI

struct CircleImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 45, height: 45)
            .clipShape(Circle())
    }
}
