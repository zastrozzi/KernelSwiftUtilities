//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/10/2023.
//

import Foundation

public protocol SecRandomGeneratableInteger: FixedWidthInteger {
    static func generateSecRandom() -> Self
}

extension SecRandomGeneratableInteger {
    @inlinable @inline(__always)
    public static func generateSecRandom() -> Self { Self.random(in: .min ... .max) }
}

extension RangeReplaceableCollection where Element: SecRandomGeneratableInteger {
//    public static func generateSecRandom(count: Int) -> Self {
//        let size = MemoryLayout<Element>.size
//        var bytes: [UInt8] = .zeroes(size * count)
//        guard SecRandomCopyBytes(kSecRandomDefault, size * count, &bytes) == errSecSuccess else { preconditionFailure("sec random failed") }
//        return bytes.withUnsafeBytes { $0.load(as: Self.self) }
//    }
//    @inlinable @inline(__always)
    public static func generateSecRandom(count: Int) -> [Element] {
        var array: [Element] = .zeroes(count)
        (0..<count).forEach { array[$0] = Element.generateSecRandom() }
//        while array[.zero] == .zero { array[.zero] = Element.generateSecRandom() }
        return array
    }
}

extension Int: SecRandomGeneratableInteger {}
extension Int8: SecRandomGeneratableInteger {}
extension Int16: SecRandomGeneratableInteger {}
extension Int32: SecRandomGeneratableInteger {}
extension Int64: SecRandomGeneratableInteger {}
extension UInt: SecRandomGeneratableInteger {}
extension UInt8: SecRandomGeneratableInteger {}
extension UInt16: SecRandomGeneratableInteger {}
extension UInt32: SecRandomGeneratableInteger {}
extension UInt64: SecRandomGeneratableInteger {}
