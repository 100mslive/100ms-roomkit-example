//
//  ContentView.swift
//  HMSRoomKitExample
//
//  Created by Pawan Dixit on 06/09/2023.
//

import SwiftUI
import HMSRoomKit
import HMSNoiseCancellationModels

struct ContentView: View {
    
    @AppStorage("CustomerUserID") var customerUserID: String = ""
    
    @State var roomCode = ""
    @State var userName = ""
    @State var isMeetingViewPresented = false
    @State var isDiagnosticsViewPresented = false
    
    var body: some View {
        
        if isMeetingViewPresented && !roomCode.isEmpty {
            
            HMSPrebuiltView(roomCode: roomCode, options: .init(roomOptions: .init(userName: userName, userId: customerUserID)), onDismiss: {
                isMeetingViewPresented = false
            })
            .screenShare(appGroupName: "group.live.100ms.videoapp.roomkit", screenShareBroadcastExtensionBundleId: "live.100ms.videoapp.roomkit.Screenshare")
            .noiseCancellation(model: HMSNoiseCancellationModels.path(for: .smallFullBand)!, initialState: .disabled)
        }
        else if !isDiagnosticsViewPresented {
            JoiningView(roomCode: $roomCode,
                        isMeetingViewPresented: $isMeetingViewPresented, isDiagnosticsViewPresented: $isDiagnosticsViewPresented, userName: $userName)
            .onAppear() {
                if customerUserID.isEmpty {
                    customerUserID = UUID().uuidString
                }
            }
        } else {
            HMSPrebuiltDiagnosticsView(onDismiss: {
                isDiagnosticsViewPresented = false
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
