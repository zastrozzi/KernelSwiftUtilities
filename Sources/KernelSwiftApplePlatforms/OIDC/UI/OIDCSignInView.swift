//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/09/2023.
//

import Foundation
import SwiftUI
import Collections
import KernelSwiftCommon

@available(iOS 17.0, macOS 14.0, *)
public struct OIDCSignInView: View {
    @KernelDI.Injected(\.oidcAuthService.clients) private var authClients
//    @State private var alertShown: Bool = false
//    @State private var alertText: String = ""
    
    
    public init() {
        print("INIT SIGN IN VIEW")
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            ForEach(authClients) { client in
                Text(client.id.uuidString).font(.footnote).bold()
                Text(client.clientId).font(.caption2).lineLimit(1)
                HStack {
                    Spacer()
                    OIDCSignInButton(uiDesign: client.uiDesign) {
                        startAuthenticationSession(client: client)
                    }
                }
                .alert(isPresented: .init(get: { client.debugAlert.isPresented }, set: { client.debugAlert.isPresented = $0 })) {
                    Alert(title: Text(client.debugAlert.title), message: Text(client.debugAlert.message))
                }
            }
        }
        .padding()
        
    }
    
//    public func presentAlert(client: KernelAppUtils.Authentication.OIDCClient) {
//        if let docString = try? client.getDiscoveryDocString() {
//            alertText = docString
//            alertShown = true
//        }
//    }
    
    public func startAuthenticationSession(client: KernelAppUtils.OIDC.OIDCClient) {
        do {
            try client.authenticate()
        } catch {
            print(error.localizedDescription)
            client.reset()
        }
    }
}
