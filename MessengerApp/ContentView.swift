//
//  ContentView.swift
//  MessengerApp
//
//  Created by Azoz Salah on 14/08/2023.
//

import SwiftUI
import StreamChatSwiftUI

struct ContentView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
        
    var body: some View {
        TabView {
            ChatChannelsListView(type: .messaging)
                .tabItem {
                    Label("Chats", systemImage: "message")
                }
            
            ChatChannelsListView(type: .team)
                .tabItem {
                    Label("Groups", systemImage: "person.3.fill")
                }
        }
        .fullScreenCover(isPresented: $streamViewModel.showingSelectedChannel) {
            DirectChatChannelView()
        }
        .overlay {
            ZStack {
                //LOADING SCREEN...
                if streamViewModel.isLoading {
                    LoadingScreen()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StreamViewModel())
    }
}
