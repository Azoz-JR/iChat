//
//  iChatApp.swift
//  iChat
//
//  Created by Azoz Salah on 14/08/2023.
//

import SwiftUI

@main
struct MessengerAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var streamViewModel = StreamViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(streamViewModel)
                .preferredColorScheme(streamViewModel.userPrefersDarkMode ? .dark : .light)
        }
    }
}
