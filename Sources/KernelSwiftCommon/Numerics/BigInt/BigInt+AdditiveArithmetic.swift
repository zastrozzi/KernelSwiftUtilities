//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/10/2023.
//

import Foundation

extension KernelNumerics.BigInt {
    public static prefix func -(lhs: Self) -> Self { lhs.negated() }
    
    public static func -(lhs: Self, rhs: Self) -> Self {
        var d = lhs
        d -= rhs
        return d
    }
    
    public static func -(lhs: Int, rhs: Self) -> Self {
        var sum = rhs
        sum -= lhs
        return -sum
    }
    
    public static func -(lhs: Self, rhs: Int) -> Self {
        var sum = lhs
        sum -= rhs
        return sum
    }
    
    public static func -=(lhs: inout Self, rhs: Self) {
        if lhs.isNegative == rhs.isNegative {
            let d = lhs.storage.difference(rhs.storage)
            if d < .zero { lhs.negate() }
            else if d == .zero { lhs.setSign(.positive) }
        }
        else { lhs.storage.add(rhs.storage) }
    }
    
    public static func -=(lhs: inout Self, rhs: Int) {
        if rhs > .zero {
            if lhs.isNegative { lhs.storage.add(.init(rhs)) }
            else {
                if lhs.storage.difference(.init(rhs)) < .zero { lhs.setSign(.negative) }
            }
        } else if rhs < .zero {
            let rhs1 = rhs == .min ? .mask.bit.big.b0 : DoubleWord(-rhs)
            if lhs.isPositive { lhs.storage.add(rhs1) }
            else {
                if lhs.storage.difference(rhs1) <= .zero { lhs.setSign(.positive) }
            }
        }
    }
    
    public prefix static func +(lhs: Self) -> Self { lhs }
    
    public static func +(lhs: Self, rhs: Self) -> Self {
        var sum = lhs
        sum += rhs
        return sum
    }
    
    public static func +(lhs: Int, rhs: Self) -> Self {
        var sum = rhs
        sum += lhs
        return sum
    }
    
    public static func +(lhs: Self, rhs: Int) -> Self {
        var sum = lhs
        sum += rhs
        return sum
    }

    public static func +=(lhs: inout Self, rhs: Self) {
        if lhs.isNegative == rhs.isNegative { lhs.storage.add(rhs.storage) }
        else {
            let cmp = lhs.storage.difference(rhs.storage)
            if cmp < .zero {
                lhs.setSign(lhs.isNegative ? .positive : .negative)
            } else if cmp == .zero {
                lhs.setSign(.positive)
            }
        }
    }

    public static func +=(lhs: inout Self, rhs: Int) {
        if rhs > .zero {
            if lhs.isNegative {
                if lhs.storage.difference(DoubleWord(rhs)) <= .zero {
                    lhs.setSign(.positive)
                }
            } else {
                lhs.storage.add(DoubleWord(rhs))
            }
        } else if rhs < .zero {
            let rhs1 = rhs == Int.min ? .mask.bit.big.b0 : DoubleWord(-rhs)
            if lhs.isNegative {
                lhs.storage.add(rhs1)
            } else {
                if lhs.storage.difference(rhs1) < .zero { lhs.setSign(.negative) }
            }
        }
    }
}

extension KernelNumerics.BigInt.DoubleWords {
    public mutating func add(_ rhs: Self, _ offset: Int = 0, _ useLastCarry: Bool = true) {
        if rhs.equalTo(.zero) { return }
        ensureSize(rhs.count + offset)
        var cry = false
        withUnsafeMutableBufferPointer { bp in
            for i in .zero ..< rhs.count {
                let io = i + offset
                if cry {
                    bp[io] &+= 1
                    if bp[io] == .zero { bp[io] = rhs[i] }
                    else { (bp[io], cry) = bp[io].addingReportingOverflow(rhs[i]) }
                } else { (bp[io], cry) = bp[io].addingReportingOverflow(rhs[i]) }
            }
            var i = rhs.count + offset
            while cry && i < bp.count {
                bp[i] &+= 1
                cry = bp[i] == .zero
                i += 1
            }
        }
        if cry && useLastCarry { append(1) }
    }
    
    public mutating func add(_ rhs: KernelNumerics.BigInt.DoubleWord) {
        var cry: Bool
        (self[.zero], cry) = self[.zero].addingReportingOverflow(rhs)
        var i = 1
        while cry && i < count {
            self[i] &+= 1
            cry = self[i] == .zero
            i += 1
        }
        if cry { append(1) }
    }
    
    @discardableResult
    public mutating func subtract(_ rhs: Self, _ offset: Int = 0) -> Bool {
        ensureSize(rhs.count + offset)
        var brw = false
        withUnsafeMutableBufferPointer { bp in
            for i in .zero..<rhs.count {
                let io = i + offset
                if brw {
                    if bp[io] == .zero { bp[io] = .val.little.max64bit - rhs[i] }
                    else {
                        bp[io] &-= 1
                        (bp[io], brw) = bp[io].subtractingReportingOverflow(rhs[i])
                    }
                }
                else { (bp[io], brw) =  bp[io].subtractingReportingOverflow(rhs[i]) }
            }
            var i = rhs.count + offset
            while brw && i < bp.count {
                bp[i] &-= 1
                brw = bp[i] == .val.little.max64bit
                i += 1
            }
        }
        return brw
    }
    
    public func subtracting(_ rhs: Self, _ offset: Int = 0) -> Self {
        var lhs = self
        lhs.subtract(rhs, offset)
        return lhs
    }
}
