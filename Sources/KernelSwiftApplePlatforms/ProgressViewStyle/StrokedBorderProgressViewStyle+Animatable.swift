//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/11/2025.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

extension StrokedBorderProgressViewStyle {
    @Animatable
    public struct AnimatableInnerView: View {
        
        @AnimatableIgnored
        @Environment(\.backgroundStyle) private var envBackgroundStyle
        
        // MARK: - Style config
        @AnimatableIgnored public var tint: Color
        @AnimatableIgnored public var dynamicTint: Gradient? = nil
        @AnimatableIgnored public var tintInterpolation: Bool = true
        @AnimatableIgnored public var fullWidth: Bool
        @AnimatableIgnored public var horizontalAlignment: HorizontalAlignment
        @AnimatableIgnored public var startEdge: Edge
        @AnimatableIgnored public var labelDisplayMode: LabelDisplayMode
        @AnimatableIgnored public var verb: String
        @AnimatableIgnored public var customBackgroundStyle: AnyShapeStyle?
        @AnimatableIgnored public var currentValueLabel: ProgressViewStyleConfiguration.CurrentValueLabel?
        @AnimatableIgnored public var label: ProgressViewStyleConfiguration.Label?
        @AnimatableIgnored public var cornerStyle: ParametricRoundedRectangle.Style
        
        public var lineWidth: CGFloat
        public var cornerRadius: CGFloat
        public var padding: EdgeInsets
        public var fractionCompleted: Double
        
        
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
            customBackgroundStyle: AnyShapeStyle? = nil,
            configuration: ProgressViewStyleConfiguration
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
            self.currentValueLabel = configuration.currentValueLabel
            self.label = configuration.label
            self.fractionCompleted = configuration.fractionCompleted ?? 0.0
        }
        
        public var body: some View {
            HStack {
                if fullWidth && horizontalAlignment != .leading { Spacer() }
                Text(formattedLabelString)
                if fullWidth && horizontalAlignment != .trailing { Spacer() }
            }
            .foregroundStyle(.primary)
            .padding(lineWidth)
            .padding(padding)
            .background {
                if let backgroundStyle {
                    Color.clear
                        .background(backgroundStyle, in: baseShape)
                }
                insetBaseShape
                    .stroke(progressTint.quaternary, style: strokeStyle, antialiased: true)
                    .animation(.smooth(duration: 0.35), value: clampedFractionCompleted)
                insetBaseShape
                    .trim(from: 0, to: clampedFractionCompleted)
                    .stroke(progressTint, style: strokeStyle, antialiased: true)
                    
                
                label.opacity(0).accessibilityHidden(false)
            }
            .animation(.smooth(duration: 0.35), value: clampedFractionCompleted)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text("Progress"))
            .accessibilityValue(Text(formattedLabelString))
        }
        
        public var backgroundStyle: AnyShapeStyle? {
            customBackgroundStyle ?? envBackgroundStyle
        }
        
        public var phaseOffset: CGFloat {
            switch startEdge {
            case .leading: 0.5
            case .top: 0.75
            case .trailing: 0.0
            case .bottom: 0.25
            }
        }
        
        public var phaseOffsettedStrokeEnd: CGFloat {
            phaseOffset + clampedFractionCompleted
        }
        
        public var baseShape: ParametricRoundedRectangle {
            ParametricRoundedRectangle(radius: cornerRadius, style: cornerStyle, startEdge: startEdge)
        }
        
        public var insetBaseShape: some Shape {
            baseShape.inset(by: lineWidth / 2)
        }
        
        public var strokeStyle: StrokeStyle {
            .init(
                lineWidth: lineWidth,
                lineCap: .round,
                lineJoin: .round
            )
        }
        
        public var clampedFractionCompleted: CGFloat {
            .init(fractionCompleted).clamped(to: 0...1)
        }
        
        public var formattedLabelString: String {
            switch labelDisplayMode {
            case .percent:
                let p = Int((clampedFractionCompleted * 100).rounded())
                return "\(p)% \(verb)"
            case let .fraction(total) where total > 0:
                let current = Int((clampedFractionCompleted * CGFloat(total)).rounded())
                let clampedCurrent = min(max(current, 0), total)
                return "\(clampedCurrent)/\(total) \(verb)"
            default:
                return ""
            }
        }
        
        public var progressTint: Color {
            if let gradient = dynamicTint {
                return GradientResolver.color(at: clampedFractionCompleted, in: gradient, interpolated: tintInterpolation)
            } else {
                return tint
            }
        }
    }
}
