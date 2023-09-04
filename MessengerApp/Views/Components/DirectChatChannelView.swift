//
//  DirectChatChannelView.swift
//  MessengerApp
//
//  Created by Azoz Salah on 27/08/2023.
//

import StreamChatSwiftUI
import SwiftUI

struct DirectChatChannelView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if let channelController = streamViewModel.selectedChannelController {
                    LazyView(
                        ChatChannelView(viewFactory: CustomViewFactory(navBarDisplayMode: .inline), viewModel: streamViewModel.selectedChannelViewModel
                                        , channelController: channelController)
                    )
                } else {
                    Text("SOMETHING WENT WRONG!!!!")
                }
            }
        }
    }
}

struct DirectChatChannelView_Previews: PreviewProvider {
    static var previews: some View {
        DirectChatChannelView()
            .environmentObject(StreamViewModel())
    }
}
