//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//
import Foundation

extension KernelNumerics.BigUInt: Comparable {
    @inlinable
    public static func compare(_ a: KernelNumerics.BigUInt, _ b: KernelNumerics.BigUInt) -> ComparisonResult {
        if a.count != b.count { return a.count > b.count ? .orderedDescending : .orderedAscending }
        for i in (0 ..< a.count).reversed() {
            let ad = a[i]
            let bd = b[i]
            if ad != bd { return ad > bd ? .orderedDescending : .orderedAscending }
        }
        return .orderedSame
    }

    /// Return true iff `a` is equal to `b`.
    ///
    /// - Complexity: O(count)
//    @inlinable
    public static func ==(a: KernelNumerics.BigUInt, b: KernelNumerics.BigUInt) -> Bool {
        return compare(a, b) == .orderedSame
    }

    /// Return true iff `a` is less than `b`.
    ///
    /// - Complexity: O(count)
//    @inlinable
    public static func <(a: KernelNumerics.BigUInt, b: KernelNumerics.BigUInt) -> Bool {
        return compare(a, b) == .orderedAscending
    }
    
    public var isEven: Bool { return self[.zero].and(0x01, equals: .zero) }
    public var isOne: Bool { return self.count == 1 && self[.zero] == 0x01 }
}
