//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

public struct CirclesTexturedBackgroundView<BackgroundShape: Shape>: View {
    var backgroundShape: BackgroundShape
    var color: Color
    var accentColor: Color
    
    public init(backgroundShape: BackgroundShape = Rectangle(), color: Color = .systemBackground, accentColor: Color = .accentColor) {
        self.backgroundShape = backgroundShape
        self.color = color
        self.accentColor = accentColor
    }
    
    public var body: some View {
        backgroundShape
            .foregroundStyle(color)
            .overlay {
                GeometryReader { proxy in
                    let height = proxy.size.height
                    let width = proxy.size.width
                    let repeats = width / height
                    
                    InnerCirclesShape()
                        .fill(accentColor)
                        .scaleEffect(repeats)
                }
            }
            .clipShape(backgroundShape)
            .contentShape(backgroundShape)
    }
    
    struct InnerCirclesShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let height = rect.height
            let width = rect.width
            let repeats = width / height
            let diameter = max(50, (height * 0.5))
            path.move(to: CGPoint(x: 0, y: 0))
            for i in 0...Int(repeats.rounded(.awayFromZero) * 2) {
                path.addEllipse(in: .init(origin: CGPoint(x: height * ((CGFloat(i) * 0.75) + 0.2), y: 0), size: .init(width: diameter, height: diameter)))
                path.addEllipse(in: .init(origin: CGPoint(x: height * ((CGFloat(i) * 0.75)), y: height - diameter), size: .init(width: diameter, height: diameter)))
            }
            return path
        }
    }
}

