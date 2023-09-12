//
//  MessengerAppApp.swift
//  MessengerApp
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
                .preferredColorScheme(.light)
                .onAppear {
                    let appearance = UITabBarAppearance()
                    appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                    //appearance.backgroundColor = UIColor(Color("AppBlue"))

                    UITabBar.appearance().standardAppearance = appearance
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                    
                    let nav = UINavigationBarAppearance()
                    nav.largeTitleTextAttributes = [.foregroundColor: UIColor(.white)]
                    nav.titleTextAttributes = [.foregroundColor: UIColor(.white)]
                    nav.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                    nav.backgroundColor = UIColor(Color("AppBlue"))
                    
                    UINavigationBar.appearance().standardAppearance = nav
                    UINavigationBar.appearance().scrollEdgeAppearance = nav
                    
                    if let image = UIImage(systemName: "arrow.left") {
                        image.withTintColor(UIColor(.white), renderingMode: .alwaysTemplate)
                        
                        UINavigationBar.appearance().backIndicatorImage = image
                        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
                    }
                }
        }
    }
}
