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
        
        func changeProfilePicture(picture: UIImage) {
            guard let resizedPicture = resizeImage(image: picture, targetSize: CGSize(width: 400, height: 400)) else {
                return
            }
            
            guard let pictureData = resizedPicture.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            guard let currentUserId = ChatClient.shared.currentUserId else {
                return
            }
            
            Task {
                do {
                    try await UserManager.shared.updateUserProfilePicture(userId: currentUserId, picture: pictureData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { (context) in
                image.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    if let image = image as? UIImage {
                        self?.changeProfilePicture(picture: image)
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
