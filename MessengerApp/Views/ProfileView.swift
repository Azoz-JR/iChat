//
//  ProfileView.swift
//  ChatApp
//
//  Created by Azoz Salah on 31/07/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
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
                
                Image("profile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .background {
                        Circle()
                            .stroke(.primary, lineWidth: 0.2)
                    }
                
                Text(streamViewModel.currentUser ?? "User")
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
                                .shadow(radius: 5)
                        }
                }
            }
        }
        .vSpacing(.top)
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
