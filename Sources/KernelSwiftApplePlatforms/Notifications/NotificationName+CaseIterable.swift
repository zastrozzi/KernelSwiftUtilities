//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/04/2025.
//

import Foundation
import SwiftUI
//import UIKit

extension Notification.Name: @retroactive CaseIterable {
    public static var allCases: [Notification.Name] {
        []
    }
}

extension KernelAppUtils.Notifications {
    public static let addressBook: [Notification.Name] = [
        
    ]
    
    public static let appKit: [Notification.Name] = [
        .unsupportedAttributeAddedNotification,
        NSTextStorage.didProcessEditingNotification,
        NSTextStorage.willProcessEditingNotification
//        NSTextView.didChangeSelectionNotification
    ]
}

