//
//  ImagePicker.swift
//  iChat
//
//  Created by Azoz Salah on 19/08/2022.
//

import PhotosUI
import SwiftUI
import StreamChat

struct ImagePicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func saveImage(image: Data?, path: URL) async throws {
            try image?.write(to: path, options: [.atomic, .completeFileProtection])
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else {return}
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    if let image = image as? UIImage {
                        
                        guard let jpegData = image.jpegData(compressionQuality: 1.0) else {
                            return
                        }
                        
                        guard let fileName = ChatClient.shared.currentUserId else {
                            return
                        }
                        
                        let path = FileManager.documnetsDirectory.appending(path: "\(fileName).jpg")
                        
                        Task {
                            try await self.saveImage(image: jpegData, path: path)
                            
                            ChatClient.shared.currentUserController().updateUserData(imageURL: path) { error in
                                if let error = error {
                                    print("ERROR UPDATING USER'S IMAGEURL: \(error.localizedDescription)")
                                    return
                                }
                                print("UPDATING imageURL: \(profileImageURL.lastPathComponent)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
        
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}
