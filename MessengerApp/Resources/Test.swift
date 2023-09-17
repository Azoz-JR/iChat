//
//  Test.swift
//  MessengerApp
//
//  Created by Azoz Salah on 16/09/2023.
//

import SwiftUI

struct Test: View {
    var body: some View {
        ZStack {
            Image("background")
                .resizable(resizingMode: .tile)
        }
        .ignoresSafeArea()
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
