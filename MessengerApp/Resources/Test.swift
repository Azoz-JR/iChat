//
//  Test.swift
//  MessengerApp
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

        var body: some View {
            Form {
                TextField("First name", text: $firstName)
                    .focused($focusedField, equals: .firstName)

                TextField("Last name", text: $lastName)
                    .focused($focusedField, equals: .lastName)
            }
            .onAppear {
                print("\(focusedField)")
                focusedField = .firstName
                print("\(focusedField)")
            }
        }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
