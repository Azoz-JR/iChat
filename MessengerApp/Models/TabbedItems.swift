//
//  TabbedItems.swift
//  MessengerApp
//
//  Created by Azoz Salah on 30/08/2023.
//

import Foundation

enum TabbedItems: Int, CaseIterable {
    case chats = 0
    case groups
    
    var title: String {
        switch self {
        case .chats:
            return "Chats"
        case .groups:
            return "Groups"
        }
    }
    
    var imageName: String {
        switch self {
        case .chats:
            return "ellipsis.message"
        case .groups:
            return "person.3"
        }
    }
}
