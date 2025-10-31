//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
public typealias KSNativeColor = UIColor
#elseif os(macOS)
import AppKit
public typealias KSNativeColor = NSColor
#endif

extension Color {
    public init(native: KSNativeColor) {
        self = Color(native)
    }
}
#if os(macOS)
extension NSColor {
    public static var systemBackground: NSColor { .windowBackgroundColor }
    public static var secondarySystemBackground: NSColor { .windowBackgroundColor }
    public static var tertiarySystemBackground: NSColor { .windowBackgroundColor }
    
    public static var label: NSColor { .labelColor }
    public static var secondaryLabel: NSColor { .secondaryLabelColor }
    public static var tertiaryLabel: NSColor { .tertiaryLabelColor }
    public static var quaternaryLabel: NSColor { .quaternaryLabelColor }
    
    public static var systemFill: NSColor { .label.withAlphaComponent(0.5) }
    public static var secondarySystemFill: NSColor { .label.withAlphaComponent(0.4) }
    public static var tertiarySystemFill: NSColor { .label.withAlphaComponent(0.3) }
    public static var quaternarySystemFill: NSColor { .label.withAlphaComponent(0.2) }
    public static var quinarySystemFill: NSColor { .label.withAlphaComponent(0.1) }
}
#endif
