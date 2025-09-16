//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/10/2023.
//

import Foundation



extension KernelNumerics.BigInt.DoubleWords {
    
    @discardableResult
    @inlinable
    public mutating func difference(_ rhs: Self) -> Int {
        var rhs = rhs
        let c = compare(rhs)
        if c < .zero { swap(&self, &rhs) }
        var brw = false
        withUnsafeMutableBufferPointer { b in
            for i in .zero ..< rhs.count {
                if brw {
                    if b[i] == .zero { b[i] = .max - rhs[i] }
                    else {
                        b[i] &-= 1
                        (b[i], brw) = b[i].subtractingReportingOverflow(rhs[i])
                    }
                } else {
                    (b[i], brw) = b[i].subtractingReportingOverflow(rhs[i])
                }
            }
            var i = rhs.count
            while brw && i < b.count {
                b[i] &-= 1
                brw = b[i] == .max
                i += 1
            }
        }
        normalise()
        return c
    }
    
    @inlinable
    public mutating func difference(_ rhs: Element) -> Int {
        var dw = [rhs]
        let cmp = self.compare(dw)
        if cmp < .zero { swap(&self, &dw) }
        var brw: Bool
        (self[.zero], brw) = self[.zero].subtractingReportingOverflow(dw[.zero])
        var i = 1
        while brw && i < count {
            self[i] &-= 1
            brw = self[i] == .val.little.max64bit
            i += 1
        }
        normalise()
        return cmp
    }
    
    @inlinable
    public func compare(_ rhs: Self) -> Int {
        var c = count
        while c > 1 && self[c - 1] == .zero { c -= 1 }
        var rc = rhs.count
        while rc > 1 && rhs[rc - 1] == .zero { rc -= 1 }
        if c < rc { return -1 }
        else if c > rc { return 1 }
        var i = rc - 1
        while i >= .zero {
            if self[i] < rhs[i] { return -1 }
            else if self[i] > rhs[i] { return 1 }
            i -= 1
        }
        return .zero
    }
    
    @inlinable
    public func compare(_ rhs: Element) -> Int {
        var c = count
        while c > 1 && self[c - 1] == .zero { c -= 1 }
        if c > 1 { return 1 }
        return self[.zero] == rhs ? .zero : (self[.zero] < rhs ? -1 : 1)
    }
    
    @inlinable
    public func lessThan(_ rhs: Self) -> Bool { compare(rhs) < .zero }
    
    @inlinable
    public func greaterThan(_ rhs: Self) -> Bool { compare(rhs) > .zero }
    
    @inlinable
    public func equalTo(_ rhs: Element) -> Bool {
        count == 1 && self[.zero] == rhs
    }
}

extension KernelNumerics.BigInt: Comparable, Equatable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sign)
        hasher.combine(storage)
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage && lhs.isNegative == rhs.isNegative
    }
    public static func ==(lhs: Self, rhs: Int) -> Bool { lhs == .init(rhs) }
    public static func ==(lhs: Int, rhs: Self) -> Bool { .init(lhs) == rhs }
    public static func !=(lhs: Self, rhs: Self) -> Bool {
        lhs.storage != rhs.storage || lhs.isNegative != rhs.isNegative
    }
    public static func !=(lhs: Self, rhs: Int) -> Bool { lhs != .init(rhs) }
    public static func !=(lhs: Int, rhs: Self) -> Bool { .init(lhs) != rhs }
    public static func <(lhs: Self, rhs: Self) -> Bool {
        if lhs.isNegative {
            if rhs.isNegative { rhs.storage.compare(lhs.storage) < .zero }
            else { true }
        } else {
            if rhs.isNegative { false }
            else { lhs.storage.compare(rhs.storage) < .zero }
        }
    }
    
    public static func <(lhs: Self, rhs: Int) -> Bool {
        if lhs.isNegative {
            if rhs < Int.zero { rhs == Int.min ? lhs < .init(rhs) : lhs.storage.compare(.init(-rhs)) > Int.zero }
            else { true }
        } else {
            if rhs < Int.zero { false }
            else { lhs.storage.compare(.init(rhs)) < Int.zero }
        }
    }
    
    public static func <(lhs: Int, rhs: Self) -> Bool {
        if rhs.isNegative {
            if lhs < Int.zero { lhs == Int.min ? Self(lhs) < rhs : rhs.storage.compare(.init(-lhs)) <= Int.zero }
            else { false }
        } else {
            if lhs < Int.zero { true }
            else { rhs.storage.compare(.init(lhs)) > Int.zero }
        }
    }
    
    public static func >(lhs: Self, rhs: Self) -> Bool { rhs < lhs }
    public static func >(lhs: Int, rhs: Self) -> Bool { rhs < lhs }
    public static func >(lhs: Self, rhs: Int) -> Bool { rhs < lhs }
    
    public static func <=(lhs: Self, rhs: Self) -> Bool { !(rhs < lhs) }
    public static func <=(lhs: Int, rhs: Self) -> Bool { !(rhs < lhs) }
    public static func <=(lhs: Self, rhs: Int) -> Bool { !(rhs < lhs) }
    
    public static func >=(lhs: Self, rhs: Self) -> Bool { !(lhs < rhs) }
    public static func >=(lhs: Int, rhs: Self) -> Bool { !(lhs < rhs) }
    public static func >=(lhs: Self, rhs: Int) -> Bool { !(lhs < rhs) }
}
