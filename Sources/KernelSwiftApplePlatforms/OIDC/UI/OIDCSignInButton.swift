//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/09/2023.
//

import Foundation
import SwiftUI
import KernelSwiftCommon


@available(iOS 17.0, macOS 14.0, *)
public struct OIDCSignInButton: View {
//    @Environment(\.colorScheme) private var colorScheme
    private var uiDesign: KernelAppUtils.OIDC.OIDCClientUIDesign
    private var action: () -> Void

    
    public init(uiDesign: KernelAppUtils.OIDC.OIDCClientUIDesign, action: @escaping () -> Void = {}) {
        self.uiDesign = uiDesign
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: 0) {
                buttonLogo()
                Text(uiDesign.signInText)
            }
            .font(.headline)
            .fontWeight(.medium)
            .padding(vertical: 10, horizontal: 15)
            .foregroundStyle(uiDesign.lightModeForegroundColor)
            .background(uiDesign.lightModeBackgroundColor)
            .clipShape(.rect(cornerRadius: 5, style: .continuous))
        }
        .buttonStyle(.plain)
        
        .shadow(radius: 3)
            
        
    }
    
    @ViewBuilder
    private func buttonLogo() -> some View {
        switch uiDesign.logo {
        case let .asyncImageURL(imageURL):
            AsyncImage(url: .init(string: imageURL)) { image in image.resizable() } placeholder: {
                Circle().foregroundStyle(uiDesign.lightModeBackgroundColor.secondary)
            }
            .frame(width: 20, height: 20).padding(.trailing, 10)
        case let .sfSymbol(symbolName): Image(systemName: symbolName).padding(.trailing, 10)
        case let .bundleAsset(assetName, bundleLocation): Image(assetName, bundle: bundleLocation?.bundle).padding(.trailing, 10)
        case .none: EmptyView()
        }
    }
}
