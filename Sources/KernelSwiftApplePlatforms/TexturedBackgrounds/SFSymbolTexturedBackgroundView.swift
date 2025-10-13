//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

public struct SFSymbolTexturedBackgroundView<BackgroundShape: Shape>: View {
    var backgroundShape: BackgroundShape
    var color: Color
    var accentColor: Color
    var iconName: String
    
    public init(backgroundShape: BackgroundShape = Rectangle(), color: Color = .systemBackground, accentColor: Color = .accentColor, iconName: String = "house") {
        self.backgroundShape = backgroundShape
        self.color = color
        self.accentColor = accentColor
        self.iconName = iconName
    }
    
    public var body: some View {
        backgroundShape
            .foregroundStyle(color)
            .overlay {
                GeometryReader { proxy in
                    let height = proxy.size.height
                    let width = proxy.size.width
                    let repeats = width / height
                    let diameter = max(50, (height * 0.375))
                    Image(systemName: iconName)
                        .font(KernelSwiftFont.init(size: Double(diameter), weight: .bold).iconFont)
                        .frame(width: diameter, height: diameter)
                        .rotationEffect(.degrees(-15))
                        .position(x: width * 0.65, y: height * 0.6)
                        .foregroundStyle(accentColor)
                        .scaleEffect(max(1.5, repeats))
                }
            }
            .clipShape(backgroundShape)
            .contentShape(backgroundShape)
    }
}

