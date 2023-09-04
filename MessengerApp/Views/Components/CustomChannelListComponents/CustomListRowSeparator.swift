//
//  CustomListRowSeparator.swift
//  MessengerApp
//
//  Created by Azoz Salah on 16/08/2023.
//

import SwiftUI

struct CustomListRowSeparator: View {
    
    let deviceWidth = UIScreen.main.bounds.width
    let color = LinearGradient(gradient: Gradient(colors: [Color("AppBlue"), Color(hex: 0xf8f9fa)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var body: some View {
        Rectangle()
            .fill(Color("AppBlue").opacity(0.4))
            .frame(width: deviceWidth, height: 0.5)
            //.blendMode(.screen)
    }
}

struct CustomListRowSeparator_Previews: PreviewProvider {
    static var previews: some View {
        CustomListRowSeparator()
    }
}
