//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/08/2023.
//

import Foundation
import SwiftUI

public struct FixedFont: ViewModifier {
    public func body(content: Content) -> some View {
        return content
            .dynamicTypeSize(.xSmall)
    }
}

extension View {
    public func fixedFont() -> some View {
        return self.modifier(FixedFont())
    }
    
    public func fixedFont(min: DynamicTypeSize = .xSmall, max: DynamicTypeSize = .accessibility5) -> some View {
        return self.dynamicTypeSize(min...max)
    }
}

