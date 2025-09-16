//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/02/2022.
//

import Foundation

extension Double {
//    public func toFraction(of frac: Int) -> UInt64 {
//        if frac == .zero { .init(self) }
//        else { .init(self * (Double.pow(10, Double(frac)) as NSDecimalNumber).doubleValue) }
//    }
    
    public func toFraction(of fraction: Int) -> UInt64 {
        if fraction == 0 { .init(self) }
        else { .init(self * Double.pow(10, fraction)) }
    }
    
    public func round(to places: Int) -> Double {
        let divisor = Double.pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    public func negated() -> Double {
        var s = self
        s.negate()
        return s
    }
    
    public func negated(_ condition: Bool = true) -> Double {
        var s = self
        if condition { s.negate() }
        return s
    }
    
    public static let phi: Double = 1.6180339887498948482
}
