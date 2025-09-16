//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/02/2022.
//

import Foundation

extension Decimal {
    public enum CompatRoundingMode: Int, CaseIterable {
        case plain = 0
        case down = 1
        case up = 2
        case bankers = 3
    }
    
    public var uint64Value: UInt64 {
        return NSDecimalNumber(decimal: self).uint64Value
    }
    
    public var int64Value: Int64 { (self as NSNumber).int64Value }
    
    public func toFraction(of fraction: Int) -> UInt64 {
        if fraction == 0 {
            return self.uint64Value
        }

        return (self * pow(10, fraction)).uint64Value
    }
    
    public func rounded(_ scale: Int, _ roundingMode: CompatRoundingMode) -> Decimal {
        let floatingPointRoundingRule: FloatingPointRoundingRule = switch roundingMode {
            case .plain: .toNearestOrAwayFromZero
            case .down: .down
            case .up: .up
            case .bankers: .toNearestOrEven
        }
        return self.rounded(scale, rule: floatingPointRoundingRule)
    }
    
    public func rounded(_ scale: Int = 0, rule: FloatingPointRoundingRule = .toNearestOrEven) -> Decimal {
        
        let significand = Decimal((Double(truncating: self.number) * pow(10, Double(scale))).rounded(rule))
        return Decimal(sign: self.sign, exponent: -scale, significand: significand)
    }
    
    public var number: NSDecimalNumber { return NSDecimalNumber(decimal: self) }
    
    public static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.alwaysShowsDecimalSeparator = true
        return formatter
    }()
    
    public static let currencyCompactFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.alwaysShowsDecimalSeparator = false
        return formatter
    }()
    
    public var currencyFormattedNoSymbol: String {
        Self.currencyFormatter.string(from: self.number) ?? ""
    }
    
    public var compactCurrencyFormattedNoSymbol: String {
        Self.currencyCompactFormatter.string(from: self.number) ?? ""
    }
}
