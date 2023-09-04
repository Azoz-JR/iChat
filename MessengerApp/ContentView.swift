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
    
    @State private var text = ""
    
    var body: some View {
        TabView {
            ChatChannelsListView(type: .messaging)
                .tabItem {
                    Label("Chats", systemImage: "message")
                }
                .overlay {
                    ZStack {
                        //LOADING SCREEN...
                        if streamViewModel.isLoading {
                            LoadingScreen()
                        }
                    }
                }
            
            ChatChannelsListView(type: .team)
                .tabItem {
                    Label("Groups", systemImage: "person.3.fill")
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
        .fullScreenCover(isPresented: $streamViewModel.showingSelectedChannel) {
            DirectChatChannelView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StreamViewModel())
    }
}
