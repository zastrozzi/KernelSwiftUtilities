//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/10/2023.
//

import Foundation

extension KernelSwiftCommon.Cryptography.MD.Digest {
    @inlinable
    mutating func updateBufferSHA2_224_256() {
        var w: [UInt32] = .init(repeating: .zero, count: 64)
        for i in .zero ..< 16 {
            let wi = i * 4
            w[i] = (.init(buffer[wi]) << 24) | (.init(buffer[wi + 1]) << 16) | (.init(buffer[wi + 2]) << 8) | .init(buffer[wi + 3])
        }
        
        for i in 16 ..< 64 {
            w[i] = sigma(w[i - 2], r0: 17, r1: 19, s: 10)
                &+ w[i - 7] 
                &+ sigma(w[i - 15], r0: 7, r1: 18, s: 3)
                &+ w[i - 16]
        }
        
        var (s0, s1, s2, s3, 
             s4, s5, s6, s7) = 
            (storageWords[0], storageWords[1], storageWords[2], storageWords[3],
             storageWords[4], storageWords[5], storageWords[6], storageWords[7])
        for i in .zero ..< 64 {
            let t0 = s7
                &+ sigma(s4, r0: 6, r1: 11, r2: 25)
                &+ ch(s4, s5, s6)
                &+ KernelSwiftCommon.Cryptography.MD.DigestConstants.sha2_224_256_k_values[i]
                &+ w[i]
            
            let t1 = sigma(s0, r0: 2, r1: 13, r2: 22) &+ maj(s0, s1, s2)
            s7 = s6
            s6 = s5
            s5 = s4
            s4 = s3 &+ t0
            s3 = s2
            s2 = s1
            s1 = s0
            s0 = t0 &+ t1
        }
        storageWords[0] &+= s0
        storageWords[1] &+= s1
        storageWords[2] &+= s2
        storageWords[3] &+= s3
        storageWords[4] &+= s4
        storageWords[5] &+= s5
        storageWords[6] &+= s6
        storageWords[7] &+= s7
    }
    
    @inlinable
    mutating func updateBufferSHA2_384_512() {
        var dw: [UInt64] = .init(repeating: .zero, count: 80)
        for i in .zero ..< 16 {
            let dwi = i * 8
            let b0: UInt64 = .init(buffer[dwi]) << 56
            let b1: UInt64 = .init(buffer[dwi + 1]) << 48
            let b2: UInt64 = .init(buffer[dwi + 2]) << 40
            let b3: UInt64 = .init(buffer[dwi + 3]) << 32
            let b4: UInt64 = .init(buffer[dwi + 4]) << 24
            let b5: UInt64 = .init(buffer[dwi + 5]) << 16
            let b6: UInt64 = .init(buffer[dwi + 6]) << 8
            let b7: UInt64 = .init(buffer[dwi + 7])
            
            dw[i] = b0 | b1 | b2 | b3 | b4 | b5 | b6 | b7
        }
        
        for i in 16 ..< 80 {
            dw[i] = sigma(dw[i - 2], r0: 19, r1: 61, s: 6)
            &+ dw[i - 7]
            &+ sigma(dw[i - 15], r0: 1, r1: 8, s: 7)
            &+ dw[i - 16]
        }
        
        var (s0, s1, s2, s3,
             s4, s5, s6, s7) =
        (storageDoubleWords[0], storageDoubleWords[1], storageDoubleWords[2], storageDoubleWords[3],
         storageDoubleWords[4], storageDoubleWords[5], storageDoubleWords[6], storageDoubleWords[7])
        for i in .zero ..< 80 {
            let t0 = s7
            &+ sigma(s4, r0: 14, r1: 18, r2: 41)
            &+ ch(s4, s5, s6)
            &+ KernelSwiftCommon.Cryptography.MD.DigestConstants.sha2_384_512_k_values[i]
            &+ dw[i]
            
            let t1 = sigma(s0, r0: 28, r1: 34, r2: 39) &+ maj(s0, s1, s2)
            s7 = s6
            s6 = s5
            s5 = s4
            s4 = s3 &+ t0
            s3 = s2
            s2 = s1
            s1 = s0
            s0 = t0 &+ t1
        }
        storageDoubleWords[0] &+= s0
        storageDoubleWords[1] &+= s1
        storageDoubleWords[2] &+= s2
        storageDoubleWords[3] &+= s3
        storageDoubleWords[4] &+= s4
        storageDoubleWords[5] &+= s5
        storageDoubleWords[6] &+= s6
        storageDoubleWords[7] &+= s7
    }
    
    @inlinable
    func paddingSHA2_224_256() -> [UInt8] {
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
    
    @inlinable
    func paddingSHA2_384_512() -> [UInt8] {
        var b = totalBytes * 8
        let c = ((totalBytes + 16 + buffer.count) / buffer.count) * buffer.count - totalBytes
        var p: [UInt8] = .init(repeating: .zero, count: c)
        p[0] = 0x80
        for i in 1...8 {
            p[c - i] = .init(b & 0xff)
            b >>= 8
        }
        return p
    }
    
    @inlinable
    func sigma<V: FixedWidthInteger & UnsignedInteger>(_ v: V, r0: Int, r1: Int, r2: Int) -> V {
        v.rotatedRight(by: r0) ^ v.rotatedRight(by: r1) ^ v.rotatedRight(by: r2)
    }
    
    @inlinable
    func sigma<V: FixedWidthInteger & UnsignedInteger>(_ v: V, r0: Int, r1: Int, s: Int) -> V {
        v.rotatedRight(by: r0) ^ v.rotatedRight(by: r1) ^ (v >> s)
    }
    
    @inlinable
    func ch<V: FixedWidthInteger & UnsignedInteger>(_ v0: V, _ v1: V, _ v2: V) -> V {
        (v0 & v1) ^ (~v0 & v2)
    }
    
    @inlinable
    func maj<V: FixedWidthInteger & UnsignedInteger>(_ v0: V, _ v1: V, _ v2: V) -> V {
        (v0 & v1) ^ (v0 & v2) ^ (v1 & v2)
    }
}
