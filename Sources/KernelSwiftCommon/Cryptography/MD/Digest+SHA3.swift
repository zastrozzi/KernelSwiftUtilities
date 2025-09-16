//
//  File.swift
//
//
//  Created by Jonathan Forbes on 10/10/2023.
//

import Foundation

extension KernelSwiftCommon.Cryptography.MD.Digest {
    @inlinable
    mutating func updateBufferSHA3() {
        var lanes = storageDoubleWords
        for ls in .zero ..< 5 {
            for li in .zero ..< 5 {
                var b = UInt64.zero
                for i in .zero ..< 8 {
                    b |= .init(customisationBuffer[8 * (5 * ls + li) + i]) << (i * 8)
                }
                lanes[5 * ls + li] = b
            }
        }
        
        for i in .zero ..< 24 {
            theta(&lanes)
            phi(&lanes)
            chi(&lanes)
            iota(&lanes, i)
        }
        
        for ls in .zero ..< 5 {
            for li in .zero ..< 5 {
                var b = lanes[5 * ls + li]
                for i in .zero ..< 8 {
                    customisationBuffer[8 * (5 * ls + li) + i] = .init(b & 0xff)
                    b >>= 8
                }
            }
        }
    }
    
    @inlinable
    func paddingSHA3() -> [UInt8] {
        let c = ((totalBytes + buffer.count) / buffer.count) * buffer.count - totalBytes
        var p: [UInt8] = .init(repeating: .zero, count: c)
        p[0] = 0x06
        p[c - 1] |= 0x80
        return p
    }
    
    @inlinable
    func theta(_ doubleWords: inout [UInt64]) {
        let c0 = doubleWords[0] ^ doubleWords[5] ^ doubleWords[10] ^ doubleWords[15] ^ doubleWords[20]
        let c1 = doubleWords[1] ^ doubleWords[6] ^ doubleWords[11] ^ doubleWords[16] ^ doubleWords[21]
        let c2 = doubleWords[2] ^ doubleWords[7] ^ doubleWords[12] ^ doubleWords[17] ^ doubleWords[22]
        let c3 = doubleWords[3] ^ doubleWords[8] ^ doubleWords[13] ^ doubleWords[18] ^ doubleWords[23]
        let c4 = doubleWords[4] ^ doubleWords[9] ^ doubleWords[14] ^ doubleWords[19] ^ doubleWords[24]
        let d0 = c4 ^ c1.rotatedLeft(by: 1)
        let d1 = c0 ^ c2.rotatedLeft(by: 1)
        let d2 = c1 ^ c3.rotatedLeft(by: 1)
        let d3 = c2 ^ c4.rotatedLeft(by: 1)
        let d4 = c3 ^ c0.rotatedLeft(by: 1)
        
        for i in stride(from: .zero, through: 20, by: 5) {
            doubleWords[i + 0] ^= d0
            doubleWords[i + 1] ^= d1
            doubleWords[i + 2] ^= d2
            doubleWords[i + 3] ^= d3
            doubleWords[i + 4] ^= d4
        }
    }
    
    @inlinable
    func phi(_ doubleWords: inout [UInt64]) {
        let t = doubleWords[0x0a].rotatedLeft(by: 0x03)
        doubleWords[0x0a] = doubleWords[0x01].rotatedLeft(by: 0x01)
        doubleWords[0x01] = doubleWords[0x06].rotatedLeft(by: 0x2c)
        doubleWords[0x06] = doubleWords[0x09].rotatedLeft(by: 0x14)
        doubleWords[0x09] = doubleWords[0x16].rotatedLeft(by: 0x3d)
        doubleWords[0x16] = doubleWords[0x0e].rotatedLeft(by: 0x27)
        doubleWords[0x0e] = doubleWords[0x14].rotatedLeft(by: 0x12)
        doubleWords[0x14] = doubleWords[0x02].rotatedLeft(by: 0x3e)
        doubleWords[0x02] = doubleWords[0x0c].rotatedLeft(by: 0x2b)
        doubleWords[0x0c] = doubleWords[0x0d].rotatedLeft(by: 0x19)
        doubleWords[0x0d] = doubleWords[0x13].rotatedLeft(by: 0x08)
        doubleWords[0x13] = doubleWords[0x17].rotatedLeft(by: 0x38)
        doubleWords[0x17] = doubleWords[0x0f].rotatedLeft(by: 0x29)
        doubleWords[0x0f] = doubleWords[0x04].rotatedLeft(by: 0x1b)
        doubleWords[0x04] = doubleWords[0x18].rotatedLeft(by: 0x0e)
        doubleWords[0x18] = doubleWords[0x15].rotatedLeft(by: 0x02)
        doubleWords[0x15] = doubleWords[0x08].rotatedLeft(by: 0x37)
        doubleWords[0x08] = doubleWords[0x10].rotatedLeft(by: 0x2d)
        doubleWords[0x10] = doubleWords[0x05].rotatedLeft(by: 0x24)
        doubleWords[0x05] = doubleWords[0x03].rotatedLeft(by: 0x1c)
        doubleWords[0x03] = doubleWords[0x12].rotatedLeft(by: 0x15)
        doubleWords[0x12] = doubleWords[0x11].rotatedLeft(by: 0x0f)
        doubleWords[0x11] = doubleWords[0x0b].rotatedLeft(by: 0x0a)
        doubleWords[0x0b] = doubleWords[0x07].rotatedLeft(by: 0x06)
        doubleWords[0x07] = t
    }
    
    @inlinable
    func chi(_ doubleWords: inout [UInt64]) {
        for i in stride(from: .zero, through: 20, by: 5) {
            let a0 = doubleWords[i]
            let a1 = doubleWords[i + 1]
            let a2 = doubleWords[i + 2]
            let a3 = doubleWords[i + 3]
            let a4 = doubleWords[i + 4]
            doubleWords[i + 0] = a0 ^ (~a1 & a2)
            doubleWords[i + 1] = a1 ^ (~a2 & a3)
            doubleWords[i + 2] = a2 ^ (~a3 & a4)
            doubleWords[i + 3] = a3 ^ (~a4 & a0)
            doubleWords[i + 4] = a4 ^ (~a0 & a1)
        }
    }
    
    @inlinable
    func iota(_ doubleWords: inout [UInt64], _ r: Int) {
        doubleWords[0] ^= KernelSwiftCommon.Cryptography.MD.DigestConstants.sha3_r_values[r]
    }
}
