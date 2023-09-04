//
//  Test.swift
//  MessengerApp
//
//  Created by Azoz Salah on 18/08/2023.
//

import SwiftUI

struct Test: View {
    
    @State private var next = false
    @State private var text = 0
    @State private var test = 0
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<10, id: \.self) { num in
                    Text("Element number \(num)")
                }
            }
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
