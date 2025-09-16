//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 05/03/2025.
//

import Foundation
import SwiftUI

public enum Haptics {}

#if os(iOS)
import UIKit

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11, *)
extension UIImpactFeedbackGenerator {
    private static var selectionHaptic = UISelectionFeedbackGenerator()
    public static func generateSelectionHaptic() {
        selectionHaptic.selectionChanged()
    }
}

extension Haptics {
    @MainActor public static func selection() {
        UIImpactFeedbackGenerator.generateSelectionHaptic()
    }
}

#endif
#if os(macOS)

extension Haptics {
    public static func selection() {
        
    }
}
#endif
