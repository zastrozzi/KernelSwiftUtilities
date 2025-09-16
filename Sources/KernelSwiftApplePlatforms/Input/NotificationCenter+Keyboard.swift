//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/01/2022.
//

#if os(iOS)
import Foundation
import SwiftUI
import Combine

public extension NotificationCenter {
    var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        let willShow = publisher(for: UIApplication.keyboardWillShowNotification)
            .removeDuplicates()
            .map { $0.keyboardHeight }
        
        let willHide = publisher(for: UIApplication.keyboardWillHideNotification)
            .removeDuplicates()
            .map { _ in CGFloat(0) }
        
        return Publishers.Merge(willShow, willHide)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

public extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
    }
}

#endif

#if canImport(UIKit)
extension View {
    public func forceHideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension ToolbarContent {
    public func forceHideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
