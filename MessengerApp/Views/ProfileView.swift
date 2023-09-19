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
        HStack {
            ZStack {
                Rectangle()
                    .fill(Color.navigationBarColor)
                    .frame(width: 270)
                    .shadow(color: .primaryColor.opacity(0.5), radius: 5, x: 0, y: 3)
                
                VStack(alignment: .center, spacing: 15) {
                    HStack(spacing: 20) {
                        Text("Me")
                            .font(.largeTitle.bold())
                            .foregroundColor(Color.primaryColor)
                    }
                    .hLeading()
                    .padding(.horizontal)
                    
                    Button {
                        streamViewModel.showingchangeProfilePictureSheet = true
                    } label: {
                        ZStack(alignment: .bottomTrailing) {
                            MessageAvatarView(avatarURL: streamViewModel.imageURL, size: CGSize(width: 100, height: 100))
                                .scaledToFill()
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
                                    .fill(Color.primaryColor)
                            }
                    }
                }
                .padding(.top, 50)
                .frame(width: 270)
                .cornerRadius(20)
                .vSpacing(.top)
                .background(Color.navigationBarColor)
                .sheet(isPresented: $streamViewModel.showingchangeProfilePictureSheet) {
                    ImagePicker()
                }
            }
        }
        .hLeading()
        .background(.clear)
        
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
