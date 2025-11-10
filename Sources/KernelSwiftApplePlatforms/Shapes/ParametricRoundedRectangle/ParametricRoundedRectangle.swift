//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/11/2025.
//

import Foundation
import SwiftUI

public struct ParametricRoundedRectangle: InsettableShape {
    let topLeftCorner: CornerAttributes
    let topRightCorner: CornerAttributes
    let bottomLeftCorner: CornerAttributes
    let bottomRightCorner: CornerAttributes
    let startEdge: Edge
    
    var insetAmount = 0.0
    
    public init(
        radius: CGFloat,
        style: Style = .smooth,
        startEdge: Edge = .top
    ) {
        self.init(
            topLeadingRadius: radius,
            bottomLeadingRadius: radius,
            bottomTrailingRadius: radius,
            topTrailingRadius: radius,
            style: style,
            startEdge: startEdge
        )
    }
    
    public init(
        radius: CGFloat,
        corners: Corners,
        style: Style = .smooth,
        startEdge: Edge = .top
    ) {
        self.init(
            topLeadingRadius: corners.contains(.topLeading) ? radius : 0,
            bottomLeadingRadius: corners.contains(.bottomLeading) ? radius : 0,
            bottomTrailingRadius: corners.contains(.bottomTrailing) ? radius : 0,
            topTrailingRadius: corners.contains(.topTrailing) ? radius : 0,
            style: style,
            startEdge: startEdge
        )
    }
    
    public init(
        topLeadingRadius: CGFloat = 0,
        bottomLeadingRadius: CGFloat = 0,
        bottomTrailingRadius: CGFloat = 0,
        topTrailingRadius: CGFloat = 0,
        style: Style,
        startEdge: Edge = .top
    ) {
        let smoothnessValue = style.value
        self.topLeftCorner = .init(radius: topLeadingRadius, smoothness: smoothnessValue)
        self.topRightCorner = .init(radius: topTrailingRadius, smoothness: smoothnessValue)
        self.bottomLeftCorner = .init(radius: bottomLeadingRadius, smoothness: smoothnessValue)
        self.bottomRightCorner = .init(radius: bottomTrailingRadius, smoothness: smoothnessValue)
        self.startEdge = startEdge
    }
    
    public func path(in rect: CGRect) -> Path {
        let insetRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
            
        let offsetRect = insetRect.offsetBy(dx: -insetAmount, dy: -insetAmount)
        
        let edges: [Edge] = [.top, .trailing, .bottom, .leading]
        
        // Rotate starting point based on chosen edge
        let startIndex = edges.firstIndex(of: startEdge) ?? 0
        let orderedEdges = Array(edges[startIndex...] + edges[..<startIndex])
        
        let normRect = normaliseCorners(
            insetRect,
            rectAttributes: .init(
                topRight: topRightCorner,
                bottomRight: bottomRightCorner,
                bottomLeft: bottomLeftCorner,
                topLeft: topLeftCorner
            )
        )
        
        func midpoint(for edge: Edge, in contRect: CGRect) -> CGPoint {
            switch edge {
            case .top: return CGPoint(x: contRect.midX, y: contRect.minY)
            case .bottom: return CGPoint(x: contRect.midX, y: contRect.maxY)
            case .leading: return CGPoint(x: contRect.minX, y: contRect.midY)
            case .trailing: return CGPoint(x: contRect.maxX, y: contRect.midY)
            }
        }
        
        var path = Path()
        path.move(to: midpoint(for: startEdge, in: offsetRect))
        
        for edge in orderedEdges {
            switch edge {
            case .top:
                drawCornerPath(&path, in: insetRect, cornerAttributes: normRect.topRight, corner: .topRight)
            case .trailing:
                drawCornerPath(&path, in: insetRect, cornerAttributes: normRect.bottomRight, corner: .bottomRight)
            case .bottom:
                drawCornerPath(&path, in: insetRect, cornerAttributes: normRect.bottomLeft, corner: .bottomLeft)
            case .leading:
                drawCornerPath(&path, in: insetRect, cornerAttributes: normRect.topLeft, corner: .topLeft)
            }
        }
        path.addLine(to: midpoint(for: startEdge, in: offsetRect))
        
        return path.offsetBy(dx: insetAmount, dy: insetAmount)
    }
    
    public func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}

// MARK: - Computations
extension ParametricRoundedRectangle {
    public func computeCornerParameters(
        cornerAttributes: CornerAttributes
    ) -> CornerParameters {
        let smoothnessFactor = cornerAttributes.smoothness
        let p = (1 + smoothnessFactor) * cornerAttributes.radius
        
        let angleBeta = 90 * (1 - smoothnessFactor)
        let angleTheta = 45 * smoothnessFactor
        
        let c = cornerAttributes.radius * tan(angleTheta / 2 * .pi / 180) * cos(angleTheta * .pi / 180)
        let d = cornerAttributes.radius * tan(angleTheta / 2 * .pi / 180) * sin(angleTheta * .pi / 180)
        let argSegment = sin(angleBeta / 2 * .pi / 180) * cornerAttributes.radius * sqrt(2)
        let b = (p - argSegment - c - d) / 3
        let a = 2 * b
        
        return .init(
            a: a,
            b: b,
            c: c,
            d: d,
            p: p,
            r: cornerAttributes.radius,
            theta: angleTheta
        )
    }
    
    public func computeCurvePoints(
        cornerParameters: CornerParameters,
        rect: CGRect,
        corner: CornerPosition
    ) -> [CGPoint] {
        let (a, b, c, d, p, _, _) = cornerParameters.unpack()
        
        return switch corner {
        case .topRight: [
            .init(x: rect.size.width - (p - a - b - c), y: d),
            .init(x: rect.size.width - (p - a), y: 0),
            .init(x: rect.size.width - (p - a - b), y: 0),
            .init(x: rect.size.width, y: p),
            .init(x: rect.size.width, y: (p - a - b)),
            .init(x: rect.size.width, y: (p - a))
        ]
        case .bottomRight: [
            .init(x: rect.size.width - d, y: rect.size.height - (p - a - b - c)),
            .init(x: rect.size.width, y: rect.size.height - (p - a)),
            .init(x: rect.size.width, y: rect.size.height - (p - a - b)),
            .init(x: rect.size.width - p, y: rect.size.height),
            .init(x: rect.size.width - (p - a - b), y: rect.size.height),
            .init(x: rect.size.width - (p - a), y: rect.size.height),
        ]
        case .bottomLeft: [
            .init(x: (p - a - b - c), y: rect.size.height - d),
            .init(x: (p - a), y: rect.size.height),
            .init(x: (p - a - b), y: rect.size.height),
            .init(x: 0, y: rect.size.height - p),
            .init(x: 0, y: rect.size.height - (p - a - b)),
            .init(x: 0, y: rect.size.height - (p - a))
        ]
        case .topLeft: [
            .init(x: d, y: (p - a - b - c)),
            .init(x: 0, y: (p - a)),
            .init(x: 0, y: (p - a - b)),
            .init(x: p, y: 0),
            .init(x: (p - a - b), y: 0),
            .init(x: (p - a), y: 0)
        ]
        }
    }
    
    public func normaliseEdge(
        _ base: CornerAttributes,
        _ adjacent: CornerAttributes,
        edge: CGFloat
    ) -> (CGFloat, CGFloat) {
        if (base.radius + adjacent.radius) >= edge {
            let scaleFactor = edge / (base.radius + adjacent.radius)
            return (base.radius * scaleFactor, 0)
        } else if (base.segmentLength + adjacent.segmentLength) > edge {
            let scaleFactor = edge / (base.segmentLength + adjacent.segmentLength)
            return (base.radius, (1 + base.smoothness) * scaleFactor - 1)
        } else {
            return (base.radius, base.smoothness)
        }
    }
    
    public func normaliseCorner(
        _ base: CornerAttributes,
        in rect: CGRect,
        verticalNeighbour: CornerAttributes,
        horizontalNeighbour: CornerAttributes
    ) -> CornerAttributes {
        let (trR1, trS1) = normaliseEdge(base, horizontalNeighbour, edge: rect.size.width)
        let (trR2, trS2) = normaliseEdge(base, verticalNeighbour, edge: rect.size.height)
        return .init(radius: min(trR1, trR2), smoothness: min(trS1, trS2))
    }
    
    public func normaliseCorners(
        _ rect: CGRect,
        rectAttributes: Attributes
    ) -> Attributes {
        let topRight = normaliseCorner(
            rectAttributes.topRight,
            in: rect,
            verticalNeighbour: rectAttributes.bottomRight,
            horizontalNeighbour: rectAttributes.topLeft
        )
        
        let bottomRight = normaliseCorner(
            rectAttributes.bottomRight,
            in: rect,
            verticalNeighbour: rectAttributes.topRight,
            horizontalNeighbour: rectAttributes.bottomLeft
        )
        
        let bottomLeft = normaliseCorner(
            rectAttributes.bottomLeft,
            in: rect,
            verticalNeighbour: rectAttributes.topLeft,
            horizontalNeighbour: rectAttributes.bottomRight
        )
        
        let topLeft = normaliseCorner(
            rectAttributes.topLeft,
            in: rect,
            verticalNeighbour: rectAttributes.bottomLeft,
            horizontalNeighbour: rectAttributes.topRight
        )
        
        return .init(
            topRight: topRight,
            bottomRight: bottomRight,
            bottomLeft: bottomLeft,
            topLeft: topLeft
        )
    }
}

// MARK: - Drawing
extension ParametricRoundedRectangle {
    public func drawCornerPath(
        _ path: inout Path,
        in rect: CGRect,
        cornerAttributes: CornerAttributes,
        corner: CornerPosition
    ) {
        if cornerAttributes.radius != 0 {
            let parameters = computeCornerParameters(cornerAttributes: cornerAttributes)
            let (_, _, _, _, p, radius, theta) = parameters.unpack()
            let points = computeCurvePoints(cornerParameters: parameters, rect: rect, corner: corner)
            let startAngle = startAngle(corner)
            path.addLine(to: curveStart(rect, corner: corner, p: p))
            path.addCurve(to: points[0], control1: points[1], control2: points[2])
            path.addArc(
                center: centerPoint(rect, corner: corner, radius: radius),
                radius: radius,
                startAngle: Angle(degrees: Double(startAngle + theta)),
                endAngle: Angle(degrees: Double(startAngle + 90 - theta)),
                clockwise: false
            )
            path.addCurve(to: points[3], control1: points[4], control2: points[5])
        } else {
            path.addLine(to: curveStart(rect, corner: corner, p: 0))
        }
    }
    
    public func curveStart(
        _ rect: CGRect,
        corner: CornerPosition,
        p: CGFloat
    ) -> CGPoint {
        switch corner {
        case .topRight: .init(x: rect.width - p, y: 0)
        case .bottomRight: .init(x: rect.width, y: rect.height - p)
        case .bottomLeft: .init(x: p, y: rect.height)
        case .topLeft: .init(x: 0, y: p)
        }
    }
    
    public func startAngle(
        _ corner: CornerPosition
    ) -> CGFloat {
        switch corner {
        case .topRight: 270
        case .bottomRight: 0
        case .bottomLeft: 90
        case .topLeft: 180
        }
    }
    
    public func centerPoint(
        _ rect: CGRect,
        corner: CornerPosition,
        radius: CGFloat
    ) -> CGPoint {
        switch corner {
        case .topRight: .init(x: rect.width - radius, y: radius)
        case .bottomRight: .init(x: rect.width - radius, y: rect.height - radius)
        case .bottomLeft: .init(x: radius, y: rect.height - radius)
        case .topLeft: .init(x: radius, y: radius)
        }
    }
}
