//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 07/03/2025.
//

import SwiftUI

#if os(iOS)
import UIKit

private struct InAppSafariBrowserViewModifier: ViewModifier {
    @State private var url: URL?
    
    func body(content: Content) -> some View {
        content.environment(
            \.openURL,
             OpenURLAction(handler: { actionUrl in
                 url = actionUrl
                 return .handled
             })
        )
        .sheet(isPresented: $url.exists(), onDismiss: { url = nil }) {
            InAppSafariBrowserView(url: url!)
        }
    }
}

extension View {
    public func inAppSafariBrowser() -> some View {
        modifier(InAppSafariBrowserViewModifier())
    }
}
#else
extension View {
    public func inAppSafariBrowser() -> some View { self }
}
#endif
