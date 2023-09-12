//
//  ProfileView.swift
//  ChatApp
//
//  Created by Azoz Salah on 31/07/2023.
//

import StreamChatSwiftUI
import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @State private var imageURL: URL?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Button {
                    withAnimation {
                        streamViewModel.showingProfile = false
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color("AppBlue"))
                }
                
                Text("Me")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color("AppBlue"))
            }
            .hLeading()
            .padding(.horizontal)
            
            Rectangle()
                .frame(height: 0.2)
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
            
            ScrollView {
                
                Spacer(minLength: 10)
                Button {
                    streamViewModel.showingchangeProfilePictureSheet = true
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        MessageAvatarView(avatarURL: streamViewModel.imageURL, size: CGSize(width: 100, height: 100))
                            .scaledToFit()
                            .clipShape(Circle())
                            .background {
                                Circle()
                                    .stroke(.primary, lineWidth: 0.2)
                            }
                            .zIndex(0)
                        
                        ZStack(alignment: .center) {
                            Circle()
                                .frame(width: 45, height: 45)
                                .foregroundColor(.white)
                            
                            Image(systemName: "camera.fill")
                                .foregroundColor(.primary)
                                .frame(width: 35, height: 35)
                                .background {
                                    Circle().fill(.gray.opacity(0.2))
                                }
                        }
                    }
                }
                
                Text(streamViewModel.currentUserId ?? "User")
                    .font(.title.bold())
                
                Button {
                    DispatchQueue.main.async {
                        streamViewModel.signOut()
                        streamViewModel.showSignInView = true
                        streamViewModel.showingProfile = false
                    }
                    
                    
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(width: 180)
                        .background {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color("AppBlue"))
                        }
                }
            }
        }
        .vSpacing(.top)
        .sheet(isPresented: $streamViewModel.showingchangeProfilePictureSheet) {
            ImagePicker()
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
