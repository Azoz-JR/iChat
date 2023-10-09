//
//  LoginBackground.swift
//  iChat
//
//  Created by Azoz Salah on 09/10/2023.
//

import SwiftUI

struct LoginBackground: View {
    
    let center: UnitPoint
    
    var body: some View {
        RadialGradient(stops: [
            .init(color: Color.primaryColor, location: 0),
            .init(color: Color(uiColor: .systemBackground), location: 0.05)
        ], center: center, startRadius: 200, endRadius: 205).ignoresSafeArea()
    }
}

#Preview {
    LoginBackground(center: .bottomLeading)
}
