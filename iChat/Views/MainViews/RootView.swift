//
//  RootView.swift
//  iChat
//
//  Created by Azoz Salah on 31/07/2023.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
            
    var body: some View {
        ZStack {
            if !streamViewModel.showSignInView {
                ContentView()
            } else {
                NavigationStack {
                    LoginView()
                }
            }
        }
        .animation(.default, value: streamViewModel.showSignInView)
        .onAppear {
            streamViewModel.showSignInView = !streamViewModel.isSignedIn
        }
    }
}

#Preview {
    RootView()
        .environmentObject(StreamViewModel())
}
