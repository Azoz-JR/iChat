//
//  Utilities.swift
//  iChat
//
//  Created by Azoz Salah on 01/06/2023.
//

import Foundation
import UIKit
import SwiftUI

final class Utilities {
    // Shared instance of the Utilities class
    static let shared = Utilities()
    
    // Private initializer to prevent external instantiation
    private init() {}
    
    // MainActor function to retrieve the top view controller
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        // If no specific controller is provided, use the root view controller of the key window
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        // Check if the current controller is a navigation controller
        if let navigationController = controller as? UINavigationController {
            // Recursively call the function with the visible view controller of the navigation controller
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        // Check if the current controller is a tab bar controller
        if let tabController = controller as? UITabBarController {
            // Recursively call the function with the selected view controller of the tab bar controller
            return topViewController(controller: tabController.selectedViewController)
        }
        
        // Check if the current controller has a presented view controller
        if let presented = controller?.presentedViewController {
            // Recursively call the function with the presented view controller
            return topViewController(controller: presented)
        }
        
        // Return the current controller (topmost view controller)
        return controller
    }
    
    func setUpUI() {
        let appearance = UITabBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        //appearance.backgroundColor = UIColor(Color.primaryColor)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        let nav = UINavigationBarAppearance()
        nav.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.primaryColor)]
        //nav.titleTextAttributes = [.foregroundColor: UIColor(Color.primaryColor)]
        nav.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        nav.backgroundColor = UIColor(Color.navigationBarColor)
        
        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
        
        if let image = UIImage(systemName: "arrow.left") {
            image.withTintColor(UIColor(.white), renderingMode: .alwaysTemplate)
            
            UINavigationBar.appearance().backIndicatorImage = image
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
        }
    }
}

