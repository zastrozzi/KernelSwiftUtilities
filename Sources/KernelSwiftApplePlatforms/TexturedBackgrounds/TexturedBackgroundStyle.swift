//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

extension View {
    public func texturedBackgroundStyle<BackgroundShape: Shape>(
        texture: TexturedBackgroundStyleViewModifier<BackgroundShape>.TexturedBackgroundType,
        backgroundShape: BackgroundShape = Rectangle(),
        color: Color = .systemBackground,
        accentColor: Color = .accentColor
    ) -> some View {
        modifier(TexturedBackgroundStyleViewModifier(texture: texture, backgroundShape: backgroundShape, color: color, accentColor: accentColor))
    }
}

public struct TexturedBackgroundStyleViewModifier<BackgroundShape: Shape>: ViewModifier {
    let backgroundShape: BackgroundShape
    let texture: TexturedBackgroundType
    let color: Color
    let accentColor: Color
    
    public init(texture: TexturedBackgroundType, backgroundShape: BackgroundShape = Rectangle(), color: Color = .systemBackground, accentColor: Color = .accentColor) {
        self.backgroundShape = backgroundShape
        self.texture = texture
        self.color = color
        self.accentColor = accentColor
    }
    
    public func body(content: Content) -> some View {
        content.clipped().background {
            switch texture {
            case .zigzag: ZigZagTexturedBackgroundView(backgroundShape: backgroundShape, color: color, accentColor: accentColor)
            case .circles: CirclesTexturedBackgroundView(backgroundShape: backgroundShape, color: color, accentColor: accentColor)
            case .roundedRectangles: RoundedRectanglesTexturedBackgroundView(backgroundShape: backgroundShape, color: color, accentColor: accentColor)
            case .sfSymbol(let iconName): SFSymbolTexturedBackgroundView(backgroundShape: backgroundShape, color: color, accentColor: accentColor, iconName: iconName)
            }
        }.clipped()
    }
    
    public enum TexturedBackgroundType {
        case zigzag
        case circles
        case roundedRectangles
        case sfSymbol(iconName: String)
    }
}
//
//#Preview {
//    VStack(spacing: 5) {
//        HStack {
//            Text("Heading").font(KernelSwiftFont.init(size: 20, weight: .semibold).textFont).baselineOffset(1)
//            Spacer()
//        }
//        Text("The above is arguably both a demonstration of just how powerful SwiftUI is once we dive a bit deeper into its layout system, but also how its highly declarative nature can sometimes act as an obstacle when we’re looking to write UI code that’s slightly more interconnected than the average view hierarchy.")
//            .font(KernelSwiftFont.init(size: 14, weight: .regular).textFont)
//    }
//    .foregroundStyle(.white)
//    .padding()
//    .texturedBackgroundStyle(
//        texture: .zigzag,
//        backgroundShape: RoundedRectangle(cornerRadius: 15),
//        color: .accentColor,
//        accentColor: .accentColor.adjustHSBABrightness(by: -5)
//    )
//    
//    .padding(.horizontal)
//}
