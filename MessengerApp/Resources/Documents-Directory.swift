//
//  Documents-Directory.swift
//  TaskManagementApp
//
//  Created by Azoz Salah on 01/07/2023.
//

import Foundation
import SwiftUI

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
