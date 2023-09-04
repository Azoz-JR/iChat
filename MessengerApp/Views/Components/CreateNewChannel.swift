//
//  CreateNewChannel.swift
//  ChatApp
//
//  Created by Azoz Salah on 07/08/2023.
//

import SwiftUI

struct CreateNewChannel: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Create New Channel")
                .font(.title2.bold())
            
            TextField("Channel Name...", text: $streamViewModel.channelName)
                .modifier(ShadowModifier())
            
            Button {
//                DispatchQueue.main.async {
//                    streamViewModel.createChannel()
//                }
                
            } label: {
                Text("Create Channel")
                    .foregroundColor(scheme == .dark ? .black : .white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.primary)
                    .cornerRadius(8)
                
            }
            .padding(.top, 10)
            .disabled(streamViewModel.channelName.isEmpty)
            .opacity(streamViewModel.channelName.isEmpty ? 0.5 : 1)
            
        }
        .padding()
        .background(scheme == .dark ? .black : .white)
        .cornerRadius(12)
        .padding(.horizontal, 35)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.primary
                .opacity(0.2)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        streamViewModel.channelName = ""
                        streamViewModel.createNewChannel.toggle()
                    }
                }
        }
        .alert("ERROR CREATING NEW CHANNEL...", isPresented: $streamViewModel.error) {
            Button("OK") {}
        } message: {
            Text(streamViewModel.errorMsg)
        }
        
    }
}

struct CreateNewChannel_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewChannel()
            .environmentObject(StreamViewModel())
    }
}
