//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/09/2023.
//

import Foundation

extension KernelNumerics.EC {
    public struct Vector: Sendable, Equatable, Hashable {
        public static let zero: Self = .init(.zero)
        public static let one: Self = .init(.one)
        
        public var storage: KernelNumerics.BigInt.DoubleWords
        
        public var count: Int { storage.count }
        public var isEven: Bool { storage[.zero] & 0x01 == .zero }
        public var isPositive: Bool { count > 1 || storage[.zero] > .zero }
        public var isOne: Bool { count == 1 && storage[.zero] == 1 }
        
        public init(_ bigInt: KernelNumerics.BigInt) {
            storage = bigInt.storage
        }
        
        public mutating func reserveSize(_ size: Int) {
            storage.reserveCapacity(size)
            while count < size { storage.append(.zero) }
        }
        
        public mutating func normalise() {
            let c = count
            if c == 0 {
                self.storage.append(0)
            } else if c > 1 {
                var i = c - 1
                while self.storage[i] == 0 && i > 0 {
                    i -= 1
                }
                self.storage.removeSubrange(i + 1 ..< c)
            }
        }
        
        public mutating func add(_ other: borrowing Vector) {
            reserveSize(other.count)
            var carrying = false
            for i in .zero ..< other.count {
                if carrying {
                    storage[i] = storage[i] &+ 0x01
                    if storage[i] == .zero { storage[i] = other.storage[i] }
                    else { (storage[i], carrying) = storage[i].addingReportingOverflow(other.storage[i]) }
                }
                else { (storage[i], carrying) = storage[i].addingReportingOverflow(other.storage[i]) }
            }
            var i = other.count
            while carrying && i < count {
                storage[i] = storage[i] &+ 0x01
                carrying = storage[i] == .zero
                i += 1
            }
            if carrying { storage.append(0x01) }
        }
        
        public mutating func subtract(_ other: borrowing Vector) {
            var borrowing = false
            for i in .zero ..< other.count {
                if borrowing {
                    if storage[i] == .zero { storage[i] = .max - other.storage[i] }
                    else {
                        storage[i] -= 0x01
                        (storage[i], borrowing) = storage[i].subtractingReportingOverflow(other.storage[i])
                    }
                }
                else { (storage[i], borrowing) = storage[i].subtractingReportingOverflow(other.storage[i]) }
            }
            var i = other.count
            while borrowing && i < count {
                storage[i] = storage[i] &- 0x01
                borrowing = storage[i] == .max
                i += 1
            }
            normalise()
        }
        
        public mutating func multiply(_ other: borrowing Vector) {
            
            var words: KernelNumerics.BigInt.DoubleWords = .zeroes(count + other.count)
            var carry: KernelNumerics.BigInt.DoubleWord
            var overflow0: Bool
            var overflow1: Bool
            for i0 in .zero ..< count {
                carry = .zero
                for i1 in .zero ..< other.count {
                    let iSum = i0 + i1
                    let (high, low) = storage[i0].multipliedFullWidth(by: other.storage[i1])
                    (words[iSum], overflow0) = words[iSum].addingReportingOverflow(low)
                    (words[iSum], overflow1) = words[iSum].addingReportingOverflow(carry)
                    carry = high &+ ((overflow0 ? 1 : .zero) + (overflow1 ? 1 : .zero))
                }
                words[i0 + other.count] = carry
            }
            storage = words
            normalise()
        }
        
        public mutating func shiftLeft(_ amount: Int) {
            let wordShifts = amount >> 6
            let bitShifts = amount & 0x3f
            var word = storage[.zero] >> (0x40 - bitShifts)
            if bitShifts > .zero {
                storage[.zero] <<= bitShifts
                for i in 1 ..< count {
                    let iWord = storage[i] >> (0x40 - bitShifts)
                    storage[i] <<= bitShifts
                    storage[i] |= word
                    word = iWord
                }
            }
            if word != .zero { storage.append(word) }
            for _ in .zero ..< wordShifts { storage.insert(.zero, at: .zero) }
        }
        
        public mutating func shiftLeftOne() {
            if !storage.isEmpty {
                var word = storage[.zero] & .mask.bit.little.b63 != .zero
                storage[.zero] <<= 1
                for i in 1 ..< count {
                    let iWord = storage[i] & .mask.bit.little.b63 != .zero
                    storage[i] <<= 1
                    if word { storage[i] |= 1 }
                    word = iWord
                }
                if word { storage.append(0x01) }
            }
        }
        
        public mutating func shiftRightOne() {
            for i in .zero ..< count {
                if i > .zero && storage[i] & 0x01 == 0x01 { storage[i - 1] |= .mask.bit.little.b63 }
                storage[i] >>= 1
            }
            normalise()
        }
        
        public mutating func compare(_ other: borrowing Vector) -> Int {
            if count < other.count { return -1 }
            if count > other.count { return 1 }
            var i = count - 1
            while i >= .zero {
                if storage[i] < other.storage[i] { return -1 }
                if storage[i] > other.storage[i] { return 1 }
                i -= 1
            }
            return .zero
        }
    }
}
