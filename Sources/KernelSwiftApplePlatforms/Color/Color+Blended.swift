//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

extension Color {
    public func blended(with color: Color, intensity i: CGFloat = 0.5) -> Color {
        let i1 = 1 - i
        guard i < 1 && i1 > 0 else { return color }
        guard i > 0 else { return self }
        let c1 = self.componentsRGBA()
        let c0 = color.componentsRGBA()
        return Color.init(red: (i1 * c1.r) + (i * c0.r), green: (i1 * c1.g) + (i * c0.g), blue: (i1 * c1.b) + (i * c0.b), opacity: 1)
    }
}
