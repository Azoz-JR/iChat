//
//  Test.swift
//  iChat
//
//  Created by Azoz Salah on 16/09/2023.
//

import SwiftUI

struct Test: View {
    
    enum FocusedField {
        case firstName, lastName
    }
    
    @State private var firstName = ""
    @State private var lastName = ""
    @FocusState private var focusedField: FocusedField?
    @State private var show = false
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    VStack {
                        Button("Show") {
                            show.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle)
                    }
                } label: {
                    Text("Next")
                }

            }
            .overlay {
                ZStack {
                    if show {
                        LoadingScreen()
                    }
                }
            }
        }
    }
}

#Preview {
    Test()
}
