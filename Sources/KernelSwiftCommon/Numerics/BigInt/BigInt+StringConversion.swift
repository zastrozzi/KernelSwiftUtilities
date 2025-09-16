//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/10/2023.
//

import Foundation

extension KernelNumerics.BigInt: ExpressibleByStringLiteral {
    @inlinable
    public init(unicodeScalarLiteral value: UnicodeScalar) {
        self = KernelNumerics.BigInt(String(value), radix: 10)!
    }
    
    @inlinable
    public init(extendedGraphemeClusterLiteral value: String) {
        self = KernelNumerics.BigInt(value, radix: 10)!
    }
    
    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        if value.hasPrefix("0x") { self = KernelNumerics.BigInt(.init(value.dropFirst(2)), radix: 16)! }
        else if value.hasPrefix("0b") { self = KernelNumerics.BigInt(.init(value.dropFirst(2)), radix: 2)! }
        else { self = KernelNumerics.BigInt(value, radix: 10)! }
    }
}

extension KernelNumerics.BigInt: CustomDebugStringConvertible {
    @inlinable
    public var debugDescription: String { description }
}
