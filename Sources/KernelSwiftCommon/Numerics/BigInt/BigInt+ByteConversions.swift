//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/10/2023.
//

import Foundation

extension KernelNumerics.BigInt {
    public func magnitudeBytes() -> [UInt8] {
        var s = (isNegative ? -self : self).signedBytes()
        while s.count > 1 && s[.zero] == .zero { s.remove(at: .zero) }
        return s
    }
    
    public func signedBytes() -> [UInt8] {
        var dw = storage
        if isNegative {
            var c = true
            for i in .zero..<dw.count {
                dw[i] = ~dw[i]
                if c {
                    if dw[i] == .max { dw[i] = .zero }
                    else {
                        dw[i] += 1
                        c = false
                    }
                }
            }
        }
        var b: [UInt8] = .zeroes(dw.count * 8)
        var bi = b.count
        for i in .zero..<dw.count {
            var w = dw[i]
            for _ in .zero..<8 {
                bi -= 1
                b[bi] = .init(w & 0xff)
                w >>= 8
            }
        }
        if isNegative {
            if b[0] < 0x80 { b.insert(0xff, at: .zero) }
            while b.count > 1 && b[0] == 0xff && b[1] > 0x7f { b.remove(at: .zero) }
        } else {
            if b[0] > 0x7f { b.insert(0x00, at: .zero) }
            while b.count > 1 && b[0] == 0x00 && b[1] < 0x80 { b.remove(at: .zero) }
        }
        return b
    }
}

extension KernelNumerics.BigInt: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let signedBytes = try container.decode([UInt8].self)
        self.init(signedBytes: signedBytes)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(contentsOf: signedBytes())
    }
}
