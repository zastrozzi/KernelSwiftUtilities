//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

public struct ZigZagTexturedBackgroundView<BackgroundShape: Shape>: View {
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
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        for i in 0...Int(repeats.rounded(.awayFromZero) * 2) {
                            path.addLine(to: CGPoint(x: height * ((CGFloat(i) * 0.5) + 0.3), y: height))
                            path.addLine(to: CGPoint(x: height * ((CGFloat(i) * 0.5) + 0.1), y: 0))
                        }
                    }
                    .stroke(accentColor, style: .init(lineWidth: max(20, (height / 8)), lineCap: .round, lineJoin: .round))
                    .scaleEffect(max(2, repeats))
                }
            }
            .clipShape(backgroundShape)
            .contentShape(backgroundShape)
    }
}

