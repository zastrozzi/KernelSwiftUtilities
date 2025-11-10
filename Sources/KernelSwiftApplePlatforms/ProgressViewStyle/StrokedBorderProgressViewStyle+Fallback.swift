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
    public struct FallbackInnerView: View {
        
        @Environment(\.backgroundStyle) private var envBackgroundStyle
        
        // MARK: - Style config
        public var tint: Color
        public var dynamicTint: Gradient? = nil
        public var tintInterpolation: Bool = true
        public var lineWidth: CGFloat
        public var cornerRadius: CGFloat
        public var padding: EdgeInsets
        public var fullWidth: Bool
        public var horizontalAlignment: HorizontalAlignment
        public var startEdge: Edge
        public var labelDisplayMode: LabelDisplayMode
        public var verb: String
        public var customBackgroundStyle: AnyShapeStyle?
        public var configuration: ProgressViewStyleConfiguration
        
        // MARK: - Init
        public init(
            tint: Color = .accentColor,
            dynamicTint: Gradient? = nil,
            tintInterpolation: Bool = true,
            lineWidth: CGFloat = 4,
            cornerRadius: CGFloat = 14,
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
            self.padding = padding
            self.fullWidth = fullWidth
            self.horizontalAlignment = horizontalAlignment
            self.startEdge = startEdge
            self.labelDisplayMode = labelDisplayMode
            self.verb = verb
            self.customBackgroundStyle = customBackgroundStyle
            self.configuration = configuration
        }
        
        public var body: some View {
            let fraction = fraction(configuration.fractionCompleted)
            let formattedLabel = formattedLabelString(for: fraction)
            let phaseOffsettedStrokeEnd = phaseOffset + fraction
            let calculatedTint = progressTint(fraction: fraction)
            let calculatedTrackTint = calculatedTint.quaternary
            
            return HStack {
                if fullWidth && horizontalAlignment != .leading { Spacer() }
                Text(formattedLabel)
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
                insetBaseShape.stroke(calculatedTrackTint, lineWidth: lineWidth)
                
                Group {
                    if fraction >= 1 {
                        insetBaseShape.stroke(calculatedTint, style: strokeStyle)
                    } else if fraction > 0 {
                        if phaseOffsettedStrokeEnd <= 1 {
                            insetBaseShape
                                .trim(from: phaseOffset, to: phaseOffsettedStrokeEnd)
                                .stroke(calculatedTint, style: strokeStyle)
                        } else {
                            // Wrap-around: draw two segments
                            insetBaseShape
                                .trim(from: phaseOffset, to: 1)
                                .stroke(calculatedTint, style: strokeStyle)
                            insetBaseShape
                                .trim(from: 0, to: phaseOffsettedStrokeEnd - 1)
                                .stroke(calculatedTint, style: strokeStyle)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.35), value: fraction)
                
                configuration.label.opacity(0).accessibilityHidden(false)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text("Progress"))
            .accessibilityValue(Text(formattedLabel))
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
        
        public var baseShape: RoundedRectangle { RoundedRectangle(cornerRadius: cornerRadius, style: .continuous) }
        public var insetBaseShape: some Shape { baseShape.inset(by: lineWidth / 2) }
        
        public var strokeStyle: StrokeStyle {
            .init(
                lineWidth: lineWidth,
                lineCap: .round,
                lineJoin: .round
            )
        }
        
        public func fraction(_ completed: Double? = nil) -> CGFloat {
            return .init(completed ?? 0).clamped(to: 0...1)
        }
        
        public func formattedLabelString(for fraction: CGFloat) -> String {
            switch labelDisplayMode {
            case .percent:
                let p = Int((fraction * 100).rounded())
                return "\(p)% \(verb)"
            case let .fraction(total) where total > 0:
                let current = Int((fraction * CGFloat(total)).rounded())
                let clampedCurrent = min(max(current, 0), total)
                return "\(clampedCurrent)/\(total) \(verb)"
            default:
                return ""
            }
        }
        
        public func progressTint(fraction: CGFloat) -> Color {
            if let gradient = dynamicTint {
                return GradientResolver.color(at: fraction, in: gradient, interpolated: tintInterpolation)
            } else {
                return tint
            }
        }
    }
}
