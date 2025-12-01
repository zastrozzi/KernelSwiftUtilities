//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/11/2025.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

public struct StrokedBorderProgressViewStyle: ProgressViewStyle {
    public enum LabelDisplayMode: Equatable {
        case percent
        case fraction(total: Int)
        case none
        
        var isHidden: Bool { self == .none }
    }
    
    @Environment(\.backgroundStyle) private var envBackgroundStyle
    
    // MARK: - Style config
    public var tint: Color
    public var dynamicTint: Gradient? = nil
    public var tintInterpolation: Bool = true
    public var lineWidth: CGFloat
    public var cornerRadius: CGFloat
    public var cornerStyle: ParametricRoundedRectangle.Style
    public var padding: EdgeInsets
    public var fullWidth: Bool
    public var horizontalAlignment: HorizontalAlignment
    public var startEdge: Edge
    public var labelDisplayMode: LabelDisplayMode
    public var verb: String
    public var customBackgroundStyle: AnyShapeStyle?
    
    // MARK: - Init
    public init(
        tint: Color = .accentColor,
        dynamicTint: Gradient? = nil,
        tintInterpolation: Bool = true,
        lineWidth: CGFloat = 4,
        cornerRadius: CGFloat = 14,
        cornerStyle: ParametricRoundedRectangle.Style = .continuous,
        padding: EdgeInsets = .init(),
        fullWidth: Bool = false,
        horizontalAlignment: HorizontalAlignment = .center,
        startEdge: Edge = .top,
        labelDisplayMode: LabelDisplayMode = .percent,
        verb: String = "completed",
        customBackgroundStyle: AnyShapeStyle? = nil
    ) {
        self.tint = tint
        self.dynamicTint = dynamicTint
        self.tintInterpolation = tintInterpolation
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.cornerStyle = cornerStyle
        self.padding = padding
        self.fullWidth = fullWidth
        self.horizontalAlignment = horizontalAlignment
        self.startEdge = startEdge
        self.labelDisplayMode = labelDisplayMode
        self.verb = verb
        self.customBackgroundStyle = customBackgroundStyle
    }
    
    // MARK: - Body
    public func makeBody(configuration: Configuration) -> some View {
        AnimatableInnerView(
            tint: tint,
            dynamicTint: dynamicTint,
            tintInterpolation: tintInterpolation,
            lineWidth: lineWidth,
            cornerRadius: cornerRadius,
            cornerStyle: cornerStyle,
            padding: padding,
            fullWidth: fullWidth,
            horizontalAlignment: horizontalAlignment,
            startEdge: startEdge,
            labelDisplayMode: labelDisplayMode,
            verb: verb,
            customBackgroundStyle: customBackgroundStyle,
            configuration: configuration
        )
    }
}

extension ProgressViewStyle where Self == StrokedBorderProgressViewStyle {
    public static func strokedBorder(
        tint: Color = .accentColor,
        dynamicTint: Gradient? = nil,
        tintInterpolation: Bool = true,
        lineWidth: CGFloat = 4,
        cornerRadius: CGFloat = 14,
        cornerStyle: ParametricRoundedRectangle.Style = .continuous,
        padding: EdgeInsets = .init(),
        fullWidth: Bool = false,
        horizontalAlignment: HorizontalAlignment = .center,
        startEdge: Edge = .top,
        labelDisplayMode: StrokedBorderProgressViewStyle.LabelDisplayMode = .percent,
        verb: String = "completed",
        customBackgroundStyle: AnyShapeStyle? = nil
    ) -> StrokedBorderProgressViewStyle {
        .init(
            tint: tint,
            dynamicTint: dynamicTint,
            tintInterpolation: tintInterpolation,
            lineWidth: lineWidth,
            cornerRadius: cornerRadius,
            cornerStyle: cornerStyle,
            padding: padding,
            fullWidth: fullWidth,
            horizontalAlignment: horizontalAlignment,
            startEdge: startEdge,
            labelDisplayMode: labelDisplayMode,
            verb: verb,
            customBackgroundStyle: customBackgroundStyle
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var completedAmount: Double = 0.0
    VStack(spacing: 5) {
        ProgressView("Completed", value: completedAmount)
            .progressViewStyle(
                .strokedBorder(
                    tint: .blue,
                    dynamicTint: Gradient(stops: [
                        .init(color: .gray,    location: 0.0),
                        .init(color: .blue, location: 0.5),
                        .init(color: .green,  location: 0.8)
                    ]),
                    tintInterpolation: true,
                    lineWidth: 3,
                    cornerRadius: 30,
                    cornerStyle: .circular,
                    padding: .init(top: 15, leading: 10, bottom: 15, trailing: 10),
                    fullWidth: false,
                    horizontalAlignment: .leading,
                    startEdge: .bottom,
                    labelDisplayMode: .percent,
                    verb: "completed"
                )
            )
            .backgroundStyle(Material.thin)
            .font(.caption).fontDesign(.serif)
            .padding(.horizontal)
            .onTapGesture {
                    if completedAmount < 1.0 {
                        completedAmount += 0.25
                    } else {
                        completedAmount = 0.0
                    }
            }
        
        ProgressView("Completed", value: completedAmount)
            .progressViewStyle(
                .strokedBorder(
                    tint: .blue,
                    dynamicTint: Gradient(stops: [
                        .init(color: .gray,    location: 0.0),
                        .init(color: .blue, location: 0.5),
                        .init(color: .green,  location: 0.8)
                    ]),
                    tintInterpolation: true,
                    lineWidth: 3,
                    cornerRadius: 30,
                    cornerStyle: .smooth,
                    padding: .init(top: 15, leading: 10, bottom: 15, trailing: 10),
                    fullWidth: false,
                    horizontalAlignment: .leading,
                    startEdge: .top,
                    labelDisplayMode: .percent,
                    verb: "completed"
                )
            )
        
            .backgroundStyle(Material.thin)
            .font(.caption).fontDesign(.serif)
            .padding(.horizontal)
            .onTapGesture {
                if completedAmount < 1.0 {
                    completedAmount += 0.25
                } else {
                    completedAmount = 0.0
                }
            }
        
        ProgressView("Mastered", value: 19, total: 24)
            .progressViewStyle(
                .strokedBorder(
                    tint: .blue,
                    lineWidth: 3,
                    cornerRadius: 100,
                    padding: .init(top: 5, leading: 10, bottom: 5, trailing: 10),
                    fullWidth: true,
                    horizontalAlignment: .center,
                    startEdge: .top,
                    labelDisplayMode: .fraction(total: 24),
                    verb: "mastered"
                )
            )
            .padding(.horizontal)
        
        ProgressView("Learned", value: 0.85)
            .progressViewStyle(
                .strokedBorder(
                    tint: .blue,
                    lineWidth: 3,
                    cornerRadius: 100,
                    padding: .init(top: 5, leading: 10, bottom: 5, trailing: 10),
                    fullWidth: true,
                    horizontalAlignment: .trailing,
                    startEdge: .trailing,
                    labelDisplayMode: .percent,
                    verb: "learned"
                )
            )
            .padding(.horizontal)
        Spacer()
    }
    .padding()
    
}
