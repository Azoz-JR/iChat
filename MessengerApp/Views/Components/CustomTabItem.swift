//
//  CustomTabItem.swift
//  MessengerApp
//
//  Created by Azoz Salah on 30/08/2023.
//

import Foundation
import SwiftUI


extension ContentView {
    func customTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 10) {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .black : .gray)
                .frame(width: 20, height: 20)
            
            if isActive {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? .black : .gray)
            }
            Spacer()
        }
        .frame(width: isActive ? 120 : 90, height: 60)
        .background(isActive ? Color("AppBlue").opacity(1) : .clear)
        .cornerRadius(30)
    }
}

struct preview: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StreamViewModel())
    }
}
