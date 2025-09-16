//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

public struct RoundedRectanglesTexturedBackgroundView<BackgroundShape: Shape>: View {
    var backgroundShape: BackgroundShape
    var color: Color
    var accentColor: Color
    
    public init(backgroundShape: BackgroundShape = Rectangle(), color: Color = .systemBackground, accentColor: Color = .accentColor) {
        self.backgroundShape = backgroundShape
        self.color = color
        self.accentColor = accentColor
    }
    
    struct IdentifiableInt: Identifiable {
        var id: UUID
        var int: Int
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
                    let reps: [IdentifiableInt] = (0...Int(repeats.rounded(.awayFromZero) * 2)).map { .init(id: .init(), int: $0) }
                    ForEach(reps) { i in
                        RoundedRectangle(cornerRadius: diameter / 10)
                            .frame(width: diameter, height: diameter)
                            .rotationEffect(.init(degrees: -15))
                            .position(x: height * ((CGFloat(i.int) * 0.5)), y: height * 0.15)
                        
                        RoundedRectangle(cornerRadius: diameter / 10)
                            .frame(width: diameter, height: diameter)
                            .rotationEffect(.init(degrees: -15))
                            .position(x: height * ((CGFloat(i.int) * 0.5)), y: (height) - diameter)
                    }.foregroundStyle(accentColor).scaleEffect(max(1.5, repeats)).rotationEffect(.degrees(height > width ? 270 : 0))
                }
            }
            .clipShape(backgroundShape)
            .contentShape(backgroundShape)
    }
    
    struct InnerRoundedRectanglesShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let height = rect.height
            let width = rect.width
            let repeats = width / height
            let diameter = max(50, (height * 0.375))
            path.move(to: CGPoint(x: 0, y: 0))
            for i in 0...Int(repeats.rounded(.awayFromZero) * 2) {
                
                path.addRoundedRect(in: .init(origin: CGPoint(x: height * ((CGFloat(i) * 0.75) + 0.375), y: height * 0.15), size: .init(width: diameter, height: diameter)), cornerSize: .init(width: diameter / 10, height: diameter / 10))
                path.addRoundedRect(in: .init(origin: CGPoint(x: height * ((CGFloat(i) * 0.75)), y: (height * 0.85) - diameter), size: .init(width: diameter, height: diameter)), cornerSize: .init(width: diameter / 10, height: diameter / 10))
            }
            return path
        }
    }
}

