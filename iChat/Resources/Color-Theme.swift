//
//  Color-Theme.swift
//  iChat
//
//  Created by Azoz Salah on 17/08/2022.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
    // Replace with your primary color hex value
    static let primaryColor = Color(hex: 0x007AFF)
    static let backgroundColor = Color(hex: 0xF5F5F5)
    
    // Chat Bubble Colors
    static let outgoingChatBubbleColor = Color("outgoingChatBubble")
    static let incomingChatBubbleColor = Color(hex: 0xFFFFFF)
        
    // Status Indicators
    static let onlineStatusColor = Color(hex: 0x4CAF50)
    static let offlineStatusColor = Color(hex: 0xF44336)
    
    // Button Colors
    static let defaultButtonColor = Color(hex: 0x007AFF)
    static let secondaryButtonColor = Color(hex: 0xEFEFF4)
    
    // Navigation Bar Color
    static let navigationBarColor = Color("navigationBarColor")
    
    //ListBackground Color
    static let listBackgroundColor = Color("ListBackground")
    static let listRowBackgroundColor = Color("ListRowBackground")
    
}
