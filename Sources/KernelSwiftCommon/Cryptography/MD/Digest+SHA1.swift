//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/10/2023.
//

import Foundation

extension KernelSwiftCommon.Cryptography.MD.Digest {
    @inlinable
    mutating func updateBufferSHA1() {
        var w: [UInt32] = .init(repeating: .zero, count: 80)
        for i in .zero ..< 16 {
            let wi = i * 4
            let w0: UInt32 = .init(buffer[wi]) << 24
            let w1: UInt32 = .init(buffer[wi + 1]) << 16
            let w2: UInt32 = .init(buffer[wi + 2]) << 8
            let w3: UInt32 = .init(buffer[wi + 3])
            w[i] = w0 | w1 | w2 | w3
        }
        
        for i in 16 ..< 80 {
            w[i] = (w[i - 3] ^ w[i - 8] ^ w[i - 14] ^ w[i - 16]).rotatedLeft(by: 1)
        }
        
        var (s0, s1, s2, s3, s4) = (storageWords[0], storageWords[1], storageWords[2], storageWords[3], storageWords[4])
        
        var f, k: UInt32
        for i in .zero ..< 80 {
//            switch i {
            if i < 20 {
                f = (s1 & s2) | (~s1 & s3)
                k = KernelSwiftCommon.Cryptography.MD.DigestConstants.sha1_k_values[0]
            }
            else if i < 40 {
                f = s1 ^ s2 ^ s3
                k = KernelSwiftCommon.Cryptography.MD.DigestConstants.sha1_k_values[1]
            }
            else if i < 60 {
                f = (s1 & s2) | (s1 & s3) | (s2 & s3)
                k = KernelSwiftCommon.Cryptography.MD.DigestConstants.sha1_k_values[2]
            }
            else {
                f = s1 ^ s2 ^ s3
                k = KernelSwiftCommon.Cryptography.MD.DigestConstants.sha1_k_values[3]
            }
            let _s0 = s0.rotatedLeft(by: 5) &+ f &+ s4 &+ k &+ w[i]
            s4 = s3
            s3 = s2
            s2 = s1.rotatedLeft(by: 30)
            s1 = s0
            s0 = _s0
        }
        storageWords[0] &+= s0
        storageWords[1] &+= s1
        storageWords[2] &+= s2
        storageWords[3] &+= s3
        storageWords[4] &+= s4
    }
    
    @inlinable
    func paddingSHA1() -> [UInt8] {
        var b = totalBytes * 8
        let c = ((totalBytes + 8 + buffer.count) / buffer.count) * buffer.count - totalBytes
        var p: [UInt8] = .init(repeating: .zero, count: c)
        p[0] = 0x80
        for i in 1...8 {
            p[c - i] = .init(b & 0xff)
            b >>= 8
        }
        return p
    }
}
