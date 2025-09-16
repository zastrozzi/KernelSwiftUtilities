//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/05/2023.
//

import Foundation

extension UnsignedInteger {
    public init<C: RandomAccessCollection>(exactBytes: C) where C.Element == UInt8, C.Index == Int {
//        precondition(exactBytes.count <= MemoryLayout<Self>.size)
        var value: Self = 0
        for byte in exactBytes {
            value <<= 8
            value |= Self(byte)
        }
        self.init(value)
    }
}

extension FixedWidthInteger {
    public init<C: RandomAccessCollection>(bigEndianBytes bytes: C) where C.Element == UInt8 {
//        precondition(bytes.count <= MemoryLayout<Self>.size)
        var accumulatedBits = 0
        self = bytes.reduce(into: .zero) {
            $0 <<= 8
            $0 |= Self(truncatingIfNeeded: $1)
            accumulatedBits += 8
        }
//        precondition(accumulatedBits == Self.bitWidth)
    }
    
    public init<C: RandomAccessCollection>(littleEndianBytes: C) where C.Element == UInt8 {
        self = Self(bigEndianBytes: littleEndianBytes).byteSwapped
//        self = big.byteSwapped
    }
}



public protocol UnsignedIntegerBytesConvertible {}

extension UnsignedIntegerBytesConvertible where Self: FixedWidthInteger {
    public func tolittleEndianByteArray() -> [UInt8] {
        var _little = self.littleEndian
        let arrPtr = withUnsafePointer(to: &_little) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<Self>.size) { ptr in
                UnsafeBufferPointer(start: ptr, count: MemoryLayout<Self>.size)
            }
        }
        return [UInt8](arrPtr)
    }
    
    public func toBigEndianByteArray() -> [UInt8] {
        var _big = self.bigEndian
        let arrPtr = withUnsafePointer(to: &_big) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<Self>.size) { ptr in
                UnsafeBufferPointer(start: ptr, count: MemoryLayout<Self>.size)
            }
        }
        return [UInt8](arrPtr)
    }
}

extension RandomAccessCollection where Element: UnsignedInteger & FixedWidthInteger {
    public func toHexString(spaced: Bool = true, uppercased: Bool = true) -> String
    {
        var s = ""
        for i in 0 ..< self.count {
            if i != 0 && spaced { s += " " }
            let c = self[_offset: i]
            if (i % 16 == 0 && i != 0) {
//                s += "\n"
            }
            if c < 0x10 { s += "0" }
            if uppercased {
                s += "\(String(c, radix: 16).uppercased())"
            } else {
                s += "\(String(c, radix: 16).lowercased())"
            }
        }

        return s
    }
    
    
}

extension RangeReplaceableCollection where Element: FixedWidthInteger {
    @inline(__always) @inlinable
    public init(zeroCount: Int) { self.init(repeating: .zero, count: zeroCount) }
    
    @inline(__always) @inlinable
    public static func zeroes(_ count: Int) -> Self { .init(zeroCount: count) }
    
    @inline(__always) @inlinable
    public static func fill(_ count: Int, with el: Element) -> Self { .init(repeating: el, count: count) }
}

extension RangeReplaceableCollection where Element: FixedWidthInteger, Index == Int {
    @inline(__always) @inlinable
    public mutating func prepend(_ el: Element) { self.insert(el, at: .zero) }
    
    @inline(__always) @inlinable
    public mutating func prepend(_ elements: Self) { self.insert(contentsOf: elements, at: .zero) }
}

extension Array where Element == UInt8 {
    public init?(fromHexString hex: String) {
        var b: [UInt8] = []
        var odd = false
        var b0: UInt8 = .zero
        var b1: UInt8 = .zero
        for char in hex {
            guard char.isASCII else { return nil }
            b0 = char.asciiValue!.hexFromASCII
            if odd { b.append(b1 * 0x10 + b0) }
            else { b1 = b0 }
            odd.toggle()
        }
        if odd { return nil }
        self = b
    }
}

extension UnsignedIntegerBytesConvertible where Self: FixedWidthInteger {
    public func toHexOctetString() -> String {
        let bigBytes = self.toBigEndianByteArray()
        var s = ""
        for i in 0 ..< bigBytes.count {
            let c = bigBytes[i]
            if (i % 16 == 0 && i != 0) {
                //                s += "\n"
            }
            if c < 0x10 { s += "0" }
            s += "\(String(c, radix: 16).uppercased())"
        }
        
        return s
    }
}

extension UInt8: UnsignedIntegerBytesConvertible {}
extension UInt16: UnsignedIntegerBytesConvertible {}
extension UInt32: UnsignedIntegerBytesConvertible {}
extension UInt64: UnsignedIntegerBytesConvertible {}
extension UInt: UnsignedIntegerBytesConvertible {}
