//
//  ContentView.swift
//  HMSRoomKitExample
//
//  Created by Pawan Dixit on 06/09/2023.
//

import SwiftUI
import HMSRoomKit

struct ContentView: View {
    
    @AppStorage("CustomerUserID") var customerUserID: String = ""
    
    @State var roomCode = ""
    @State var isMeetingViewPresented = false
    
    var body: some View {
        
        if isMeetingViewPresented && !roomCode.isEmpty {
            
            HMSPrebuiltView(roomCode: roomCode, options: .init(roomOptions: .init(userId: customerUserID)), onDismiss: {
                isMeetingViewPresented = false
            })
            .screenShare(appGroupName: "group.live.100ms.videoapp.roomkit", screenShareBroadcastExtensionBundleId: "live.100ms.videoapp.roomkit.Screenshare")
            .onAppear() {
                if customerUserID.isEmpty {
                    customerUserID = UUID().uuidString
                }
            }
        }
        else {
            JoiningView(roomCode: $roomCode,
                        isMeetingViewPresented: $isMeetingViewPresented)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
