//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

extension Color {
    public static let systemBackground: Color = Color(native: .systemBackground)
    public static let secondarySystemBackground: Color = Color(.secondarySystemBackground)
    public static let tertiarySystemBackground: Color = Color(.tertiarySystemBackground)
    
    public static let label = Color(.label)
    public static let secondaryLabel = Color(.secondaryLabel)
    public static let tertiaryLabel = Color(.tertiaryLabel)
    public static let quaternaryLabel = Color(.quaternaryLabel)
    
    public static let systemFill: Color = Color(.systemFill)
    public static let secondarySystemFill: Color = Color(.secondarySystemFill)
    public static let tertiarySystemFill: Color = Color(.tertiarySystemFill)
    public static let quaternarySystemFill: Color = Color(.quaternarySystemFill)
    public static let quinarySystemFill: Color = .quaternarySystemFill.opacity(0.75)
}
