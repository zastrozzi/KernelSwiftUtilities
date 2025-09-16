//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/09/2022.
//

import Foundation
import SwiftUI
import OSLog

#if os(iOS)
import UIKit

#if compiler(>=5.7)
@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationStack {
    func resetNavigationGestureDelegate() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let navigationController = scene.windows.first?.rootViewController?.children.first as? UINavigationController else {
            guard let overlayNavigationController = scene.windows.first?.rootViewController?.presentedViewController?.children.first as? UINavigationController else { return }
            overlayNavigationController.interactivePopGestureRecognizer?.delegate = nil
            Navigation.logger.debug("reset navigation sheet gestures")
            return
        }
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        Navigation.logger.debug("reset navigation gestures")
        return
    }
}

#endif
#endif

#if os(macOS)
@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationStack {
    func resetNavigationGestureDelegate() {
        preconditionFailure("macOS is not supported")
    }
}
#endif
