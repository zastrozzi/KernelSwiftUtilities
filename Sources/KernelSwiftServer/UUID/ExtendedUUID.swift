//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 01/05/2023.
//

import Foundation

public struct ExtendedUUID: Sendable {
    public typealias Bytes = (
        UInt8, UInt8, UInt8, UInt8,
        UInt8, UInt8, UInt8, UInt8,
        UInt8, UInt8, UInt8, UInt8,
        UInt8, UInt8, UInt8, UInt8
    )
    
    public static let zeroBytes: Bytes = (
        .zero,  .zero, .zero, .zero,
        .zero,  .zero, .zero, .zero,
        .zero,  .zero, .zero, .zero,
        .zero,  .zero, .zero, .zero
    )
    
    public let bytes: Bytes
    
    @inlinable
    public init(bytes: Bytes) {
        self.bytes = bytes
    }
    
    public static let zero: Self = .init(bytes: zeroBytes)
    
    @inlinable
    public init?<Bytes>(bytes: Bytes) where Bytes: Sequence, Bytes.Element == UInt8 {
        var uuid = Self.zero.bytes
        let copied = withUnsafeMutableBytes(of: &uuid) { uuidBytes in
            UnsafeMutableBufferPointer(start: uuidBytes.baseAddress.unsafelyUnwrapped.assumingMemoryBound(to: UInt8.self), count: 16).initialize(from: bytes).1
        }
        guard copied == 16 else { return nil }
        self.init(bytes: uuid)
    }
}

extension ExtendedUUID: Equatable, Hashable, Comparable {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        withUnsafeBytes(of: lhs.bytes) { lhsBytes in
            withUnsafeBytes(of: rhs.bytes) { rhsBytes in
                lhsBytes.elementsEqual(rhsBytes)
            }
        }
    }
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        withUnsafeBytes(of: bytes) { hasher.combine(bytes: $0) }
    }
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        withUnsafeBytes(of: lhs.bytes) { lhsBytes in
            withUnsafeBytes(of: rhs.bytes) { rhsBytes in
                lhsBytes.lexicographicallyPrecedes(rhsBytes)
            }
        }
    }
}
