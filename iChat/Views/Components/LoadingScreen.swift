//
//  LoadingScreen.swift
//  iChat
//
//  Created by Azoz Salah on 07/08/2023.
//

import SwiftUI

struct LoadingScreen: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color.primary
                .opacity(0.2)
                .ignoresSafeArea()
            
            ProgressView()
                .frame(width: 50, height: 50)
                .background(colorScheme == .dark ? .black : .white)
                .cornerRadius(8)
            
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
