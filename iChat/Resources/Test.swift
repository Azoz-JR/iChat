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
            Form {
                TextField("First name", text: $firstName)
                    .focused($focusedField, equals: .firstName)
                
                TextField("Last name", text: $lastName)
                    .focused($focusedField, equals: .lastName)
                
                Button("Show") {
                    show.toggle()
                }
            }
            .sheet(isPresented: $show, content: {
                Text("Hello")
                    .presentationDetents([.fraction(.infinity)])
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}, label: {
                        Text("Button")
                    })
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text("Hello")
                }
            }
        }
    }
}

class UIEmojiTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setEmoji() {
        _ = self.textInputMode
    }
    
    override var textInputContextIdentifier: String? {
        return ""
    }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                self.keyboardType = .default // do not remove this
                return mode
            }
        }
        return nil
    }
}

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""
    
    func makeUIView(context: Context) -> UIEmojiTextField {
        let emojiTextField = UIEmojiTextField()
        emojiTextField.placeholder = placeholder
        emojiTextField.text = text
        emojiTextField.delegate = context.coordinator
        return emojiTextField
    }
    
    func updateUIView(_ uiView: UIEmojiTextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField
        
        init(parent: EmojiTextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.text = textField.text ?? ""
            }
        }
    }
}

#Preview {
    Test()
}

struct EmojiContentView: View {
    
    @State private var text: String = ""
    
    var body: some View {
        EmojiTextField(text: $text, placeholder: "Enter emoji")
    }
}
