//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 07/03/2025.
//

import SwiftUI

#if os(iOS)
import UIKit

private struct InAppSafariBrowserOpenViewModifier: ViewModifier {
    var urlString: String
    @Binding var isPresented: Bool
    
    init(urlString: String, isPresented: Binding<Bool>) {
        self.urlString = urlString
        _isPresented = isPresented
    }
    
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                InAppSafariBrowserView(url: .init(string: urlString)!)
        }
    }
}

extension View {
    public func inAppSafariBrowserOpen(isPresented: Binding<Bool>, urlString: String) -> some View {
        modifier(InAppSafariBrowserOpenViewModifier(urlString: urlString, isPresented: isPresented))
    }
}
#else
extension View {
    public func inAppSafariBrowserOpen(isPresented: Binding<Bool>, urlString: String) -> some View { self }
}
#endif
