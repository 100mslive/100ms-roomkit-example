//
//  JoiningView.swift
//  HMSSDKExample
//
//  Created by Pawan Dixit on 04/09/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct JoiningView: View {
    
    var heading4Semibold34 =  Font(UIFont(name: "Inter-SemiBold", size: 34) ?? .systemFont(ofSize: 34))
    var body2Regular14 =  Font(UIFont(name: "Inter-Regular", size: 14) ?? .systemFont(ofSize: 14))
    var body2Semibold14 =  Font(UIFont(name: "Inter-SemiBold", size: 14) ?? .systemFont(ofSize: 14))
    
    var backgroundDefault: Color = Color(UIColor(red: 11/255, green: 14/255, blue: 21/255, alpha: 1.0))
    var surfaceDefault: Color = Color(UIColor(red: 25/255, green: 27/255, blue: 35/255, alpha: 1.0))
    var primaryDisabled: Color = Color(UIColor(red: 0/255, green: 66/255, blue: 153/255, alpha: 1.0))
    var primaryBright: Color = Color(UIColor(red: 83/255, green: 141/255, blue: 255/255, alpha: 1.0))
    var onPrimaryLow: Color = Color(UIColor(red: 132/255, green: 170/255, blue: 255/255, alpha: 1.0))
    var onPrimaryHigh: Color = Color(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0))
    var primaryDefault: Color = Color(UIColor(red: 37/255, green: 114/255, blue: 237/255, alpha: 1.0))
    
    var heighEmph: Color = Color(UIColor(red: 245/255, green: 249/255, blue: 255/255, alpha: 0.95))
    var mediumEmph: Color = Color(UIColor(red: 224/255, green: 236/255, blue: 255/255, alpha: 0.8))
    var onSurfaceHigh: Color = Color(UIColor(red: 239/255, green: 240/255, blue: 250/255, alpha: 0.8))
    
    @Binding var roomCode: String
    @Binding var isMeetingViewPresented: Bool
    @Binding var isDiagnosticsViewPresented: Bool
    @Binding var userName: String
    
    @AppStorage("roomCodeOrRoomLink") var roomCodeOrRoomLink = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: 37) {
                
                if !isFocused {
                    Image("logo-icon")
                        .frame(width: 32, height: 32)
                }
                
                Image("illustration")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                VStack(spacing: 8) {
                    Text("Experience the power of 100ms")
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .font(heading4Semibold34)
                        .foregroundStyle(heighEmph)
                        .minimumScaleFactor(0.3)
                    
                    if !isFocused {
                        Text("Jump right in by pasting a room link, room code")
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(mediumEmph)
                            .minimumScaleFactor(0.3)
                        
                        HStack(spacing: 9) {
                            Image("diag-paperclip")
                            Text("Troubleshoot before you join")
                                .font(body2Semibold14)
                                .foregroundStyle(primaryBright)
                        }
                        .padding(.vertical, 10)
                        .onTapGesture {
                            isDiagnosticsViewPresented = true
                        }
                        .padding(.top, 16)
                    }
                    
                    
                }
                
            }
            .animation(.default, value: isFocused)
            
            Spacer(minLength: 0)
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Joining Link or Room Code")
                        .foregroundStyle(onSurfaceHigh)
                        .font(body2Regular14)
                    
                    TextField("", text: $roomCodeOrRoomLink, prompt: Text("Paste the link or room code here").foregroundColor(onSurfaceHigh))
                        .focused($isFocused)
                        .onTapGesture {
                            // block tap
                        }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(onSurfaceHigh)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(surfaceDefault)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Text("Join Now")
                    .foregroundColor(roomCodeOrRoomLink.isEmpty ? onPrimaryLow : onPrimaryHigh)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(roomCodeOrRoomLink.isEmpty ? primaryDisabled : primaryDefault)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        analyseAndOpenLink(link: roomCodeOrRoomLink)
                    }
            }
            .padding(16)
            .background(backgroundDefault)
        }
        .background(.black)
        .onOpenURL { incomingURL in
            // Assign to text field as well
            roomCodeOrRoomLink = incomingURL.absoluteString
            analyseAndOpenLink(link: incomingURL.absoluteString)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func analyseAndOpenLink(link: String) {
        guard !link.isEmpty,
              let url = URL(string: link.trimmingCharacters(in: .whitespacesAndNewlines)),
              !url.lastPathComponent.isEmpty
        else { return }
        
        roomCode = url.lastPathComponent
        userName = url.userName
        
        UserDefaults.setEnvironment(url.hmsJoinLinkEnvironment)
        
        isMeetingViewPresented.toggle()
    }
}

struct JoiningView_Previews: PreviewProvider {
    static var previews: some View {
        JoiningView(roomCode: .constant("as"), isMeetingViewPresented: .constant(false), isDiagnosticsViewPresented: .constant(false), userName: .constant(""))
    }
}

enum HMSEnvironment {
    case prod
    case qa
}

extension UserDefaults {
    static func setEnvironment(_ environment: HMSEnvironment) {
        switch environment {
        case .qa:
            standard.setValue(true, forKey: "useQAEnv")
            standard.set("https://auth-nonprod.100ms.live", forKey: "HMSAuthTokenEndpointOverride")
            standard.set("https://api-nonprod.100ms.live", forKey: "HMSRoomLayoutEndpointOverride")
        default:
            standard.removeObject(forKey: "useQAEnv")
            standard.removeObject(forKey: "HMSAuthTokenEndpointOverride")
            standard.removeObject(forKey: "HMSRoomLayoutEndpointOverride")
        }
        //UserDefaults.standard.set("https://demo8271564.mockable.io", forKey: "HMSRoomLayoutEndpointOverride")
    }
}

extension URL {
    var hmsJoinLinkEnvironment: HMSEnvironment {
        var isQALink = false
        if #available(iOS 16.0, *) {
            isQALink = host(percentEncoded: false)?.localizedCaseInsensitiveContains("qa-app") == true
        } else {
            isQALink = host?.localizedCaseInsensitiveContains("qa-app") == true
        }
        
        return isQALink ? .qa : .prod
    }
    
    var userName: String {
        if let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = urlComponents.queryItems, let nameItem = queryItems.first(where: { $0.name == "name" }) {
            return nameItem.value ?? ""
        }
        return ""
    }
}
