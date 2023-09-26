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
            }
        }
        .onAppear {            
            streamViewModel.showSignInView = !streamViewModel.isSignedIn
        }
        .fullScreenCover(isPresented: $streamViewModel.showSignInView) {
            NavigationStack {
                LoginView()
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(StreamViewModel())
    }
}
