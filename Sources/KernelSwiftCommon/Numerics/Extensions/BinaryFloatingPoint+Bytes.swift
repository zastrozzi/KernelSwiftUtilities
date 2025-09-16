//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 25/09/2023.
//

import Foundation

extension KernelNumerics.UniversalFloat16 {
    public func toBigEndianByteArray() -> [UInt8] {
        var copy = self
        let res = withUnsafeBytes(of: &copy) { Array($0) }
        return Int(bigEndian: 10) == 10 ? res : res.reversed()
    }
}

extension Float32 {
    public func toBigEndianByteArray() -> [UInt8] {
        var copy = self
        let res = withUnsafeBytes(of: &copy) { Array($0) }
        return Int(bigEndian: 10) == 10 ? res : res.reversed()
    }
}

extension Float64 {
    public func toBigEndianByteArray() -> [UInt8] {
        var copy = self
        let res = withUnsafeBytes(of: &copy) { Array($0) }
        return Int(bigEndian: 10) == 10 ? res : res.reversed()
    }
}
