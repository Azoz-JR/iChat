//
//  SideMenuProfileView.swift
//  iChat
//
//  Created by Azoz Salah on 19/09/2023.
//

import SwiftUI

struct SideMenuProfileView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if streamViewModel.showingProfile {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        streamViewModel.showingProfile = false
                    }
                
                content
                    .transition(edgeTransition)
                    .background(.clear)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: streamViewModel.showingProfile)
    }
}

struct SideMenuProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuProfileView(content: AnyView(ProfileView()))
            .environmentObject(StreamViewModel())
    }
}
