//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography {
    public struct AES {
        public let key: [UInt8]
        public var encryptionStorage: KernelNumerics.Words
        public var decryptionStorage: KernelNumerics.Words
        
        public init(key: [UInt8], nr: Int) {
            self.key = key
            self.encryptionStorage = Self.prepareEncryptionStorage(key: key, storageLength: 4 * (nr + 1))
            self.decryptionStorage = []
        }
    }
}

extension KernelCryptography.AES {
    public static func encrypt(_ input: consuming [UInt8], aes: borrowing Self) -> [UInt8] {
        var (s0, s1, s2, s3) = decode(input, o: 0)
        s0 ^= aes.encryptionStorage[0]; s1 ^= aes.encryptionStorage[1]
        s2 ^= aes.encryptionStorage[2]; s3 ^= aes.encryptionStorage[3]
        let nr = aes.encryptionStorage.count / 4 - 2
        var k = 4
        var t0, t1, t2, t3: KernelNumerics.Word
        (t0, t1, t2, t3) = (.zero, .zero, .zero, .zero)
        for _ in .zero..<nr {
            t0  =   aes.encryptionStorage[k]
            ^   val.transform.encryptionTable0[.init(s0 >> 24)]
            ^   val.transform.encryptionTable1[.init(s1 >> 16 & 0xff)]
            ^   val.transform.encryptionTable2[.init(s2 >> 8 & 0xff)]
            ^   val.transform.encryptionTable3[.init(s3 & 0xff)]
            
            t1  =   aes.encryptionStorage[k + 1]
            ^   val.transform.encryptionTable0[.init(s1 >> 24)]
            ^   val.transform.encryptionTable1[.init(s2 >> 16 & 0xff)]
            ^   val.transform.encryptionTable2[.init(s3 >> 8 & 0xff)]
            ^   val.transform.encryptionTable3[.init(s0 & 0xff)]
            
            t2  =   aes.encryptionStorage[k + 2]
            ^   val.transform.encryptionTable0[.init(s2 >> 24)]
            ^   val.transform.encryptionTable1[.init(s3 >> 16 & 0xff)]
            ^   val.transform.encryptionTable2[.init(s0 >> 8 & 0xff)]
            ^   val.transform.encryptionTable3[.init(s1 & 0xff)]
            
            t3  =   aes.encryptionStorage[k + 3]
            ^   val.transform.encryptionTable0[.init(s3 >> 24)]
            ^   val.transform.encryptionTable1[.init(s0 >> 16 & 0xff)]
            ^   val.transform.encryptionTable2[.init(s1 >> 8 & 0xff)]
            ^   val.transform.encryptionTable3[.init(s2 & 0xff)]
            
            k += 4; s0 = t0; s1 = t1; s2 = t2; s3 = t3
        }
        
        s0  =   .init(val.sub.table[.init(t0 >> 24)]) << 24
            |   .init(val.sub.table[.init(t1 >> 16 & 0xff)]) << 16
            |   .init(val.sub.table[.init(t2 >> 8 & 0xff)]) << 8
            |   .init(val.sub.table[.init(t3 & 0xff)])
        
        s1  =   .init(val.sub.table[.init(t1 >> 24)]) << 24
            |   .init(val.sub.table[.init(t2 >> 16 & 0xff)]) << 16
            |   .init(val.sub.table[.init(t3 >> 8 & 0xff)]) << 8
            |   .init(val.sub.table[.init(t0 & 0xff)])
        
        s2  =   .init(val.sub.table[.init(t2 >> 24)]) << 24
            |   .init(val.sub.table[.init(t3 >> 16 & 0xff)]) << 16
            |   .init(val.sub.table[.init(t0 >> 8 & 0xff)]) << 8
            |   .init(val.sub.table[.init(t1 & 0xff)])
        
        s3  =   .init(val.sub.table[.init(t3 >> 24)]) << 24
            |   .init(val.sub.table[.init(t0 >> 16 & 0xff)]) << 16
            |   .init(val.sub.table[.init(t1 >> 8 & 0xff)]) << 8
            |   .init(val.sub.table[.init(t2 & 0xff)])
        
        s0 ^= aes.encryptionStorage[k]; s1 ^= aes.encryptionStorage[k + 1];
        s2 ^= aes.encryptionStorage[k + 2]; s3 ^= aes.encryptionStorage[k + 3]
        return encode(input, s0, s1, s2, s3, .zero)
    }
    
    public static func decrypt(_ input: consuming [UInt8], aes: inout Self) -> [UInt8] {
        if aes.decryptionStorage.isEmpty { prepareDecryptionStorage(aes: &aes) }
        var (s0, s1, s2, s3) = decode(input, o: 0)
        s0 ^= aes.decryptionStorage[0]; s1 ^= aes.decryptionStorage[1]
        s2 ^= aes.decryptionStorage[2]; s3 ^= aes.decryptionStorage[3]
        let nr = aes.decryptionStorage.count / 4 - 2
        var k = 4
        var t0, t1, t2, t3: KernelNumerics.Word
        (t0, t1, t2, t3) = (.zero, .zero, .zero, .zero)
        for _ in .zero..<nr {
            t0  =   aes.decryptionStorage[k]
                ^   val.transform.decryptionTable0[.init(s0 >> 24)]
                ^   val.transform.decryptionTable1[.init(s3 >> 16 & 0xff)]
                ^   val.transform.decryptionTable2[.init(s2 >> 8 & 0xff)]
                ^   val.transform.decryptionTable3[.init(s1 & 0xff)]
            
            t1  =   aes.decryptionStorage[k + 1]
                ^   val.transform.decryptionTable0[.init(s1 >> 24)]
                ^   val.transform.decryptionTable1[.init(s0 >> 16 & 0xff)]
                ^   val.transform.decryptionTable2[.init(s3 >> 8 & 0xff)]
                ^   val.transform.decryptionTable3[.init(s2 & 0xff)]
            
            t2  =   aes.decryptionStorage[k + 2]
                ^   val.transform.decryptionTable0[.init(s2 >> 24)]
                ^   val.transform.decryptionTable1[.init(s1 >> 16 & 0xff)]
                ^   val.transform.decryptionTable2[.init(s0 >> 8 & 0xff)]
                ^   val.transform.decryptionTable3[.init(s3 & 0xff)]
            
            t3  =   aes.decryptionStorage[k + 3]
                ^   val.transform.decryptionTable0[.init(s3 >> 24)]
                ^   val.transform.decryptionTable1[.init(s2 >> 16 & 0xff)]
                ^   val.transform.decryptionTable2[.init(s1 >> 8 & 0xff)]
                ^   val.transform.decryptionTable3[.init(s0 & 0xff)]
            
            k += 4; s0 = t0; s1 = t1; s2 = t2; s3 = t3
        }
        s0  =   .init(val.sub.inverseTable[.init(t0 >> 24)]) << 24
            |   .init(val.sub.inverseTable[.init(t3 >> 16 & 0xff)]) << 16
            |   .init(val.sub.inverseTable[.init(t2 >> 8 & 0xff)]) << 8
            |   .init(val.sub.inverseTable[.init(t1 & 0xff)])
        
        s1  =   .init(val.sub.inverseTable[.init(t1 >> 24)]) << 24
            |   .init(val.sub.inverseTable[.init(t0 >> 16 & 0xff)]) << 16
            |   .init(val.sub.inverseTable[.init(t3 >> 8 & 0xff)]) << 8
            |   .init(val.sub.inverseTable[.init(t2 & 0xff)])
        
        s2  =   .init(val.sub.inverseTable[.init(t2 >> 24)]) << 24
            |   .init(val.sub.inverseTable[.init(t1 >> 16 & 0xff)]) << 16
            |   .init(val.sub.inverseTable[.init(t0 >> 8 & 0xff)]) << 8
            |   .init(val.sub.inverseTable[.init(t3 & 0xff)])
        
        s3  =   .init(val.sub.inverseTable[.init(t3 >> 24)]) << 24
            |   .init(val.sub.inverseTable[.init(t2 >> 16 & 0xff)]) << 16
            |   .init(val.sub.inverseTable[.init(t1 >> 8 & 0xff)]) << 8
            |   .init(val.sub.inverseTable[.init(t0 & 0xff)])
        s0 ^= aes.decryptionStorage[k]; s1 ^= aes.decryptionStorage[k + 1];
        s2 ^= aes.decryptionStorage[k + 2]; s3 ^= aes.decryptionStorage[k + 3]
        return encode(input, s0, s1, s2, s3, .zero)
    }
}

extension KernelCryptography.AES {
    public static func prepareDecryptionStorage(aes: inout Self) {
        var ds: KernelNumerics.Words = .zeroes(aes.encryptionStorage.count)
        for i in stride(from: .zero, to: ds.count, by: 4) {
            let ei = ds.count - i - 4
            for j in .zero..<4 {
                var x = aes.encryptionStorage[ei + j]
                if i > .zero && i + 4 < ds.count {
                    x   =   val.transform.decryptionTable0[.init(val.sub.table[.init(x >> 24)])]
                        ^   val.transform.decryptionTable1[.init(val.sub.table[.init(x >> 16 & 0xff)])]
                        ^   val.transform.decryptionTable2[.init(val.sub.table[.init(x >> 8 & 0xff)])]
                        ^   val.transform.decryptionTable3[.init(val.sub.table[.init(x & 0xff)])]
                }
                ds[i + j] = x
            }
        }
        aes.decryptionStorage = ds
    }
    
    public static func prepareEncryptionStorage(key: [UInt8], storageLength: Int) -> KernelNumerics.Words {
        var es: KernelNumerics.Words = .zeroes(storageLength)
        let nk = key.count / 4
        for i in .zero..<nk {
            es[i] = (.init(key[4 * i]) << 24) | (.init(key[4 * i + 1]) << 16) | (.init(key[4 * i + 2]) << 8) | .init(key[4 * i + 3])
        }
        for i in nk ..< es.count {
            var t = es[i - 1]
            if i % nk == .zero { t = substitute(rotate(t)) ^ (.init(val.round.rcTable[i / nk]) << 24) }
            else if nk > 6 && i % nk == 4 { t = substitute(t) }
            es[i] = es[i - nk] ^ t
        }
        return es
    }
}

extension KernelCryptography.AES {
    public static func substitute(_ x: KernelNumerics.Word) -> KernelNumerics.Word {
        .init(val.sub.table[.init(x >> 24)]) << 24 |
        .init(val.sub.table[.init(x >> 16 & 0xff)]) << 16 |
        .init(val.sub.table[.init(x >> 8 & 0xff)]) << 8 |
        .init(val.sub.table[.init(x & 0xff)])
    }
    
    public static func rotate(_ x: KernelNumerics.Word) -> KernelNumerics.Word { x << 8 | x >> 24 }
    
    public static func decode(_ b: [UInt8], _ n: Int) -> KernelNumerics.Word {
        .init(b[n]) << 24 | .init(b[n + 1]) << 16 | .init(b[n + 2]) << 8 | .init(b[n + 3])
    }

    public static func decode(
        _ b: [UInt8],
        o: Int
    ) -> (KernelNumerics.Word, KernelNumerics.Word, KernelNumerics.Word, KernelNumerics.Word) {
        (
            .init(b[o + 0x00])  << 24 | .init(b[o + 0x01])  << 16 | .init(b[o + 0x02])  << 8 | .init(b[o + 0x03]),
            .init(b[o + 0x04])  << 24 | .init(b[o + 0x05])  << 16 | .init(b[o + 0x06])  << 8 | .init(b[o + 0x07]),
            .init(b[o + 0x08])  << 24 | .init(b[o + 0x09])  << 16 | .init(b[o + 0x0a])  << 8 | .init(b[o + 0x0b]),
            .init(b[o + 0x0c])  << 24 | .init(b[o + 0x0d])  << 16 | .init(b[o + 0x0e])  << 8 | .init(b[o + 0x0f])
        )
    }
    
    public static func encode(_ b: inout [UInt8], _ w: KernelNumerics.Word, _ n: Int) {
        b[n] = .init(w >> 24)
        b[n + 1] = .init(w >> 16 & 0xff)
        b[n + 2] = .init(w >> 8 & 0xff)
        b[n + 3] = .init(w & 0xff)
    }
    
    public static func encode(
        _ b: consuming [UInt8],
        _ w0: KernelNumerics.Word,
        _ w1: KernelNumerics.Word,
        _ w2: KernelNumerics.Word,
        _ w3: KernelNumerics.Word,
        _ o: Int
    ) -> [UInt8] {
        var b = b
        b[o + 0x00] = .init(w0 >> 24)
        b[o + 0x01] = .init(w0 >> 16 & 0xff)
        b[o + 0x02] = .init(w0 >> 8 & 0xff)
        b[o + 0x03] = .init(w0 & 0xff)
        b[o + 0x04] = .init(w1 >> 24)
        b[o + 0x05] = .init(w1 >> 16 & 0xff)
        b[o + 0x06] = .init(w1 >> 8 & 0xff)
        b[o + 0x07] = .init(w1 & 0xff)
        b[o + 0x08] = .init(w2 >> 24)
        b[o + 0x09] = .init(w2 >> 16 & 0xff)
        b[o + 0x0a] = .init(w2 >> 8 & 0xff)
        b[o + 0x0b] = .init(w2 & 0xff)
        b[o + 0x0c] = .init(w3 >> 24)
        b[o + 0x0d] = .init(w3 >> 16 & 0xff)
        b[o + 0x0e] = .init(w3 >> 8 & 0xff)
        b[o + 0x0f] = .init(w3 & 0xff)
        return b
    }
}
