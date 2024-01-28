//
//  LazyImageWithProgress.swift
//  iChat
//
//  Created by Azoz Salah on 28/01/2024.
//

import StreamChatSwiftUI
import SwiftUI

struct LazyImageWithProgress: View {
    
    @Injected(\.images) private var images
    
    let userId: String
    let size: CGSize
    
    @State private var isLoading = true
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .frame(width: size.width, height: size.height)
                    .clipShape(Circle())
            } else {
                Image(uiImage: image ?? images.userAvatarPlaceholder2)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipShape(Circle())
            }
        }
        .task {
            fetchUserPicture(userId: userId) { image, error in
                isLoading = false
                
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                self.image = image
            }
        }
    }
    
    func fetchUserPicture(userId: String, completion: @escaping (UIImage?, Error?) -> Void) {
        Task {
            do {
                let picture = try await UserManager.shared.getUserProfilePicture(userId: userId)
                
                await MainActor.run {
                    completion(picture, nil)
                }
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    completion(nil, error)
                }
            }
        }
    }
}

#Preview {
    LazyImageWithProgress(userId: "", size: CGSize(width: 40, height: 40))
}
