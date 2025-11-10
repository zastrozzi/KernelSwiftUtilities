//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/11/2025.
//

import Foundation
import SwiftUI

public enum GradientResolver {
    public static func color(at fraction: CGFloat, in gradient: Gradient, interpolated: Bool) -> Color {
        let f = fraction.clamped(to: 0...1)
        let stops = normalisedStops(gradient.stops)
        guard !stops.isEmpty else { return .clear }
        if stops.count == 1 { return stops[0].color }
        
        // Fast path for exact stop
        if let exact = stops.first(where: { abs($0.location - f) < .ulpOfOne * 8 }) {
            return exact.color
        }
        
        // Find bounding stops
        var lower = stops.first!
        var upper = stops.last!
        for i in 0..<(stops.count - 1) {
            let a = stops[i], b = stops[i + 1]
            if a.location <= f, f <= b.location {
                lower = a; upper = b
                break
            }
        }
        
        if interpolated {
            let span = max(upper.location - lower.location, .leastNonzeroMagnitude)
            let t = CGFloat((f - lower.location) / span).clamped(to: 0...1)
            return ColorInterpolator.interpolate(from: lower.color, to: upper.color, t: t) ?? (t < 0.5 ? lower.color : upper.color)
        } else {
            // Stepped: choose the nearer stop
            let chooseUpper = (f - lower.location) >= (upper.location - f)
            return chooseUpper ? upper.color : lower.color
        }
    }
    
    public static func normalisedStops(_ s: [Gradient.Stop]) -> [Gradient.Stop] {
        // Ensure 0 and 1 coverage if author omitted ends; sort ascending by location.
        var stops = s.sorted(by: { $0.location < $1.location })
        if stops.first?.location ?? 1 > 0 {
            stops.insert(.init(color: stops.first!.color, location: 0), at: 0)
        }
        if stops.last?.location ?? 0 < 1 {
            stops.append(.init(color: stops.last!.color, location: 1))
        }
        return stops
    }
}
