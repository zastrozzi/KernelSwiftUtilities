//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.DSA {
    public struct DeterministicK {
        var md: KernelCryptography.MD.Digest
        var storage: [UInt8]
        let q: KernelNumerics.BigInt
        let count: Int
        let qc: Int
        
        public init(
            _ md: KernelCryptography.MD.Digest,
            _ q: KernelNumerics.BigInt,
            _ p: KernelNumerics.BigInt
        ) {
            self.md = md
            self.q = q
            self.qc = q.bitWidth
            self.count = (q.bitWidth + 7) >> 3
            self.storage = p.magnitudeBytes()
            storage.prepend(.zeroes(count - storage.count))
        }
        
        func generate(_ digest: [UInt8]) -> KernelNumerics.BigInt {
            var v: [UInt8] = .fill(md.algorithm.outputSizeBytes, with: .one), k: [UInt8] = .zeroes(md.algorithm.outputSizeBytes)
            var hmac: KernelCryptography.HMAC = .init(md, k)
            hmac.update(v)
            hmac.update([.zero])
            hmac.update(storage)
            hmac.update(alignBytes(digest))
            k = hmac.finalise()
            hmac.initialise(k)
            v = hmac.finalise(v)
            hmac.reset()
            hmac.update(v)
            hmac.update([.one])
            hmac.update(storage)
            hmac.update(alignBytes(digest))
            k = hmac.finalise()
            hmac.initialise(k)
            v = hmac.finalise(v)
            
            while true {
                var t: [UInt8] = []
                while t.count * 8 < qc {
                    hmac.reset()
                    v = hmac.finalise(v)
                    t.append(contentsOf: v)
                }
                let res = alignInt(t)
                if res < q { return res }
                hmac.reset()
                hmac.update(v)
                hmac.update([.zero])
                k = hmac.finalise()
                hmac.initialise(k)
                v = hmac.finalise(v)
            }
            
        }
        
        func alignBytes(_ x: [UInt8]) -> [UInt8] {
            let z1 = alignInt(x)
            var b = (z1 < q ? z1 : z1 - q).magnitudeBytes()
            b.prepend(.zeroes(count - b.count))
            return b
        }
        
        func alignInt(_ x: [UInt8]) -> KernelNumerics.BigInt {
            var b: KernelNumerics.BigInt = .init(magnitudeBytes: x)
            if q.bitWidth < x.count * 8 { b >>= x.count * 8 - qc }
            return b
        }
    }
    
    public static func deterministicK(
        _ md: KernelCryptography.MD.Digest,
        _ q: KernelNumerics.BigInt,
        _ p: KernelNumerics.BigInt,
        _ digest: [UInt8]
    ) -> KernelNumerics.BigInt {
        DeterministicK(md, q, p).generate(digest)
    }
}
