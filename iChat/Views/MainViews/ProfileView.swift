//
//  ProfileView.swift
//  iChat
//
//  Created by Azoz Salah on 31/07/2023.
//

import StreamChatSwiftUI
import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @Injected(\.images) var images
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @State private var profilePiture: PhotosPickerItem? = nil
    
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .fill(Color.navigationBarColor)
                    .frame(width: 270)
                    .shadow(color: .primaryColor.opacity(0.5), radius: 5, x: 0, y: 3)
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 15) {
                    HStack {
                        Text("Me")
                            .font(.largeTitle.bold())
                            .foregroundColor(Color.primaryColor)
                            .hLeading()
                        
                        Button {
                            withAnimation(.easeInOut) {
                                streamViewModel.userPrefersDarkMode.toggle()
                            }
                        } label: {
                            Image(systemName: streamViewModel.userPrefersDarkMode ? "sun.max" : "moon")
                                .foregroundStyle(streamViewModel.userPrefersDarkMode ? .white : .black)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    
                    PhotosPicker(selection: $profilePiture) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(uiImage: streamViewModel.profilePicture ?? images.userAvatarPlaceholder2)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                                        .stroke(Color.primaryColor.opacity(0.7), lineWidth: 7)
                                }
                                .cornerRadius(50)
                                .zIndex(0)
                            
                            ZStack(alignment: .center) {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.black)
                                    .frame(width: 30, height: 30)
                                    .background {
                                        Circle().fill(.gray.opacity(0.2))
                                    }
                            }
                        }
                    }
                    
                    Text(streamViewModel.currentUser?.name ?? "User")
                        .font(.title.bold())
                    
                    Button {
                        DispatchQueue.main.async {
                            do {
                                try AuthenticationManager.shared.signOut()
                                streamViewModel.signOut()
                            } catch {
                                streamViewModel.errorMsg = error.localizedDescription
                                streamViewModel.error = true
                            }
                        }
                        
                        
                    } label: {
                        Text("Sign Out")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(width: 180)
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.primaryColor)
                            }
                    }
                }
                .padding(.top, 50)
                .frame(width: 270)
                .cornerRadius(20)
                .vSpacing(.top)
                .background(Color.navigationBarColor)
                .onChange(of: profilePiture) { newValue in
                    Task {
                        if let loaded = try await profilePiture?.loadTransferable(type: Image.self), let uiImage = loaded.render() {
                            streamViewModel.changeProfilePicture(picture: uiImage)
                        }
                    }
                }
            }
        }
        .hLeading()
        .background(.clear)
        .alert("ERROR SIGNNING OUT...", isPresented: $streamViewModel.error) {
            Button("OK") {}
        } message: {
            Text(streamViewModel.errorMsg)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView()
                .environmentObject(StreamViewModel())
        }
    }
}
