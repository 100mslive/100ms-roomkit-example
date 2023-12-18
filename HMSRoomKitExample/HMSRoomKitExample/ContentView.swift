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
    @State var userName = ""
    @State var isMeetingViewPresented = false
    
    var body: some View {
        
        if isMeetingViewPresented && !roomCode.isEmpty {
            let builder = HMSPrebuiltOptionsBuilder(roomCode: roomCode, userId: customerUserID)
                .setUserName(userName)
                .enableScreenShare(appGroupName: "group.live.100ms.videoapp.roomkit", screenShareBroadcastExtensionBundleId: "live.100ms.videoapp.roomkit.Screenshare")
            HMSPrebuiltView(optionsBuilder: builder, onDismiss: {
                isMeetingViewPresented = false
            })
        }
        else {
            JoiningView(roomCode: $roomCode,
                        isMeetingViewPresented: $isMeetingViewPresented, userName: $userName)
            .onAppear() {
                if customerUserID.isEmpty {
                    customerUserID = UUID().uuidString
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
