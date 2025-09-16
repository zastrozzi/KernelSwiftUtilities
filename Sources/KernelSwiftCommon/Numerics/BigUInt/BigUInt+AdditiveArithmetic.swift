//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

// MARK: - AdditiveArithmetic
extension KernelNumerics.BigUInt {
//    @inlinable
    public static func +(a: KernelNumerics.BigUInt, b: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt { a.adding(b) }
    
//    @inlinable
    public static func +=(a: inout KernelNumerics.BigUInt, b: KernelNumerics.BigUInt) { a.add(b, shiftedBy: 0) }
    
//    @inlinable
    public static func -(a: KernelNumerics.BigUInt, b: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt { a.subtracting(b) }
    
//    @inlinable
    public static func -=(a: inout KernelNumerics.BigUInt, b: KernelNumerics.BigUInt) { a.subtract(b, shiftedBy: 0) }
    
    @inlinable
    func addingWord(_ word: Word, shiftedBy shift: Int = 0) -> KernelNumerics.BigUInt {
        var r = self
        r.addWord(word, shiftedBy: shift)
        return r
    }
    
    @inlinable
    func adding(_ other: KernelNumerics.BigUInt, shiftedBy shift: Int = 0) -> KernelNumerics.BigUInt {
        var r = self
        r.add(other, shiftedBy: shift)
        return r
    }
    
    @inlinable
    func subtractingWord(_ word: Word, shiftedBy shift: Int = 0) -> KernelNumerics.BigUInt {
        var r = self
        r.subtractWord(word, shiftedBy: shift)
        return r
    }
    
    @inlinable
    public func subtracting(_ other: KernelNumerics.BigUInt, shiftedBy shift: Int = 0) -> KernelNumerics.BigUInt {
        var r = self
        r.subtract(other, shiftedBy: shift)
        return r
    }
    
    @inlinable
    func subtractingWordReportingOverflow(_ word: Word, shiftedBy shift: Int = 0) -> (partialValue: KernelNumerics.BigUInt, overflow: Bool) {
        var r = self
        let overflow = r.subtractWordReportingOverflow(word, shiftedBy: shift)
        return (r, overflow)
    }
    
    @inlinable
    public func subtractingReportingOverflow(_ other: KernelNumerics.BigUInt, shiftedBy shift: Int) -> (partialValue: KernelNumerics.BigUInt, overflow: Bool) {
        var r = self
        let overflow = r.subtractReportingOverflow(other, shiftedBy: shift)
        return (r, overflow)
    }

    @inlinable
    public func subtractingReportingOverflow(_ other: KernelNumerics.BigUInt) -> (partialValue: KernelNumerics.BigUInt, overflow: Bool) {
        return subtractingReportingOverflow(other, shiftedBy: 0)
    }
    
    @inlinable
    mutating func addWord(_ word: Word, shiftedBy shift: Int = 0) {
        precondition(shift >= 0)
        var carry = word, idx = shift
        while carry > 0 {
            let (d, c) = self[idx].addingReportingOverflow(carry)
            self[idx] = d
            carry = (c ? 1 : 0)
            idx += 1
        }
    }
    
    @inlinable
    mutating func add(_ other: KernelNumerics.BigUInt, shiftedBy shift: Int = 0) {
        precondition(shift >= 0)
        var carrying = false
        var idx1 = 0
        let c1 = other.count
        while idx1 < c1 || carrying {
            let idx0 = shift + idx1
            let (d0, c0) = self[idx0].addingReportingOverflow(other[idx1])
            if carrying {
                let (d1, c1) = d0.addingReportingOverflow(1)
                self[idx0] = d1
                carrying = c0 || c1
            } else {
                self[idx0] = d0
                carrying = c0
            }
            idx1 += 1
        }
    }
    
    @inlinable
    public mutating func increment(shiftedBy shift: Int = 0) {
        addWord(1, shiftedBy: shift)
    }
    
    @inlinable
    mutating func subtractWord(_ word: Word, shiftedBy shift: Int = 0) {
        let overflow = subtractWordReportingOverflow(word, shiftedBy: shift)
        precondition(!overflow)
    }
    
    @inlinable
    mutating func subtractWordReportingOverflow(_ word: Word, shiftedBy shift: Int = 0) -> Bool {
        precondition(shift >= 0)
        var carry = word, idx = shift, count = count
        while carry > 0 && idx < count {
            let (d, c) = self[idx].subtractingReportingOverflow(carry)
            self[idx] = d
            carry = (c ? 1 : 0)
            idx += 1
        }
        return carry > 0
    }
    
    @inlinable
    mutating func subtractReportingOverflow(_ other: KernelNumerics.BigUInt, shiftedBy shift: Int = 0) -> Bool {
        precondition(shift >= 0)
        var carrying = false
        var idx1 = 0
        let c1 = other.count
        let count = self.count
        while idx1 < c1 || (shift + idx1 < count && carrying) {
            let idx0 = shift + idx1
            let (d0, c0) = self[idx0].subtractingReportingOverflow(other[idx1])
            if carrying {
                let (d1, c1) = d0.subtractingReportingOverflow(1)
                self[idx0] = d1
                carrying = c0 || c1
            } else {
                self[idx0] = d0
                carrying = c0
            }
            idx1 += 1
        }
        return carrying
    }
    
    @inlinable
    public mutating func subtract(_ other: KernelNumerics.BigUInt, shiftedBy shift: Int = 0) {
        let overflow = subtractReportingOverflow(other, shiftedBy: shift)
        precondition(!overflow)
    }
    
    @inlinable
    public mutating func decrement(shiftedBy shift: Int = 0) {
        subtract(1, shiftedBy: shift)
    }
}
