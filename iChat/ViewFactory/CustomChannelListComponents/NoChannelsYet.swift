//
//  NoChannelsYet.swift
//  iChat
//
//  Created by Azoz Salah on 16/08/2023.
//

import SwiftUI

struct NoChannelsYet: View {
    var body: some View {
        VStack {
            Text("🤷‍♂️")
                .font(.system(size: 100))
            
            Text("Sorry, you have created no channels yet!")
                .font(.title)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct NoChannelsYet_Previews: PreviewProvider {
    static var previews: some View {
        NoChannelsYet()
    }
}
