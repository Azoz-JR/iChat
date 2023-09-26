//
//  BackButtonDisplay.swift
//  iChat
//
//  Created by Azoz Salah on 18/08/2023.
//

import SwiftUI


extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
      navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}
