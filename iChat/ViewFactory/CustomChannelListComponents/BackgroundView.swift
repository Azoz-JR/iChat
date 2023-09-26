//
//  BackgroundView.swift
//  iChat
//
//  Created by Azoz Salah on 16/08/2023.
//

import SwiftUI

struct BackgroundView: View {
        
    var body: some View {
        Color.primaryColor.opacity(0.1).ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
