//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/03/2025.
//

import Foundation
import SwiftUI

public struct NumericBadgeModifier: ViewModifier {
    @Binding var value: Int
    var foreground: Color
    var background: Color
    
    private let size = 16.0
    
    public init(value: Binding<Int>, foreground: Color = .white, background: Color = .red) {
        self._value = value
        self.foreground = foreground
        self.background = background
    }
    
    public func body(content: Content) -> some View {
        content.overlay(alignment: .topTrailing) {
            ZStack(alignment: .center) {
                Capsule()
                    .fill(background)
                    .frame(width: size * widthMultplier(), height: size, alignment: .topTrailing)
                
                if hasTwoOrLessDigits() {
                    Text("\(value)")
                        .foregroundColor(foreground)
                        .font(Font.caption)
                } else {
                    Text("99+")
                        .foregroundColor(foreground)
                        .font(Font.caption)
                        .frame(width: size * widthMultplier(), height: size)
                }
            }
            .offset(x: size * widthMultplier(scale: 0.5), y: size * -0.5)
            .opacity(value == 0 ? 0 : 1)
        }
        
    }
    
    func hasTwoOrLessDigits() -> Bool {
        return value < 100
    }
    
    func widthMultplier(scale: CGFloat = 1.0) -> Double {
        if value < 10 {
            return 1.0 * scale
        } else if value < 100 {
            return 1.5 * scale
        } else {
            return 2.0 * scale
        }
    }
}

extension View {
    public func numericBadge(value: Binding<Int>, foreground: Color = .white, background: Color = .red) -> some View {
        modifier(NumericBadgeModifier(value: value, foreground: foreground, background: background))
    }
}

