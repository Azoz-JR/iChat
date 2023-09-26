//
//  SearchBar.swift
//  iChat
//
//  Created by Azoz Salah on 31/07/2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct SearchBar: View, KeyboardReadable {
    
    @Injected(\.colors) private var colors
    @Injected(\.fonts) private var fonts
    @Injected(\.images) private var images
    
    @Binding var text: String
    @State private var isEditing = false
    
    let barColor: Color
    let prompt: String
    
    var body: some View {
        HStack {
            TextField(prompt, text: $text)
                .frame(height: 20)
                .padding(8)
                .padding(.leading, 8)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.horizontal, 24)
                .overlay(
                    HStack {
                        Image(uiImage: images.searchIcon)
                            .customizable()
                            .foregroundColor(Color(colors.textLowEmphasis))
                            .frame(maxHeight: 18)
                            .padding(.leading, 12)
                        
                        Spacer()
                        
                        if !self.text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(uiImage: images.searchCloseIcon)
                                    .customizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundColor(Color(colors.textLowEmphasis))
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(barColor)
                }
                .transition(.identity)
                .animation(.easeInOut, value: isEditing)
            
            if isEditing {
                Button(action: {
                    withAnimation(.easeInOut) {
                        self.isEditing = false
                        self.text = ""
                        // Dismiss the keyboard
                        resignFirstResponder()
                    }
                }) {
                    Text("Cancel")
                        .foregroundColor(colors.tintColor)
                }
                .frame(height: 20)
                .padding(.trailing, 8)
                .transition(.move(edge: .trailing))
            }
        }
        .onReceive(keyboardWillChangePublisher) { shown in
            if shown {
                self.isEditing = true
            }
            if !shown && isEditing {
                self.isEditing = false
            }
        }
        .accessibilityIdentifier("SearchBar")
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), barColor: Color.gray.opacity(0.1), prompt: "Search...")
    }
}
