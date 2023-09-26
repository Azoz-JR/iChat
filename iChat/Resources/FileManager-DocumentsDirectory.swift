//
//  FileManager-DocumentsDirectory.swift
//  iChat
//
//  Created by Azoz Salah on 16/12/2022.
//

import Foundation

extension FileManager {
    static var documnetsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
