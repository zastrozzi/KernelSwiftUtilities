//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography {
    public struct HMAC {
        var digest: MD.Digest
        var iSec: [UInt8] = []
        var oSec: [UInt8] = []
        
        public init(_ algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm) {
            self.digest = .init(algorithm)
        }
        
        public init(_ algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm, _ sec: [UInt8]) {
            self.digest = .init(algorithm)
            initialise(sec)
        }
        
        public init(_ digest: KernelCryptography.MD.Digest, _ sec: [UInt8]) {
            self.digest = digest
            initialise(sec)
        }
        
        public mutating func initialise(_ sec: [UInt8]) {
            var macSec: [UInt8] = .init(repeating: 0x00, count: digest.algorithm.blockSizeBytes)
            if sec.count > digest.algorithm.blockSizeBytes {
                digest.update(sec)
                let d = digest.digest()
                for i in .zero ..< d.count { macSec[i] = d[i] }
            } else {
                for i in .zero ..< sec.count { macSec[i] = sec[i] }
            }
            iSec = .zeroes(digest.algorithm.blockSizeBytes)
            oSec = .zeroes(digest.algorithm.blockSizeBytes)
            for i in .zero ..< digest.algorithm.blockSizeBytes {
                iSec[i] = macSec[i] ^ .hmac.ipad
                oSec[i] = macSec[i] ^ .hmac.opad
            }
            reset()
        }
        
        public mutating func reset() {
            digest.reset()
            digest.update(iSec)
        }
        
        public mutating func update(_ message: [UInt8]) {
            digest.update(message)
        }
        
        public mutating func finalise() -> [UInt8] {
            let d = digest.digest()
            digest.update(oSec)
            digest.update(d)
            return digest.digest()
        }
        
        public mutating func finalise(_ message: [UInt8]) -> [UInt8] {
            update(message)
            return finalise()
        }
    }
}

extension KernelCryptography.HMAC {
    public static func hash(_ algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm, _ sec: [UInt8], _ message: [UInt8]) -> [UInt8] {
        var digest: KernelCryptography.MD.Digest = .init(algorithm)
        var macSec: [UInt8] = .init(repeating: 0x00, count: digest.algorithm.blockSizeBytes)
        if sec.count > digest.algorithm.blockSizeBytes {
            digest.update(sec)
            let d = digest.digest()
            for i in .zero ..< d.count { macSec[i] = d[i] }
        } else {
            for i in .zero ..< sec.count { macSec[i] = sec[i] }
        }
        var iSec: [UInt8] = .init(repeating: 0x00, count: digest.algorithm.blockSizeBytes)
        var oSec: [UInt8] = .init(repeating: 0x00, count: digest.algorithm.blockSizeBytes)
        for i in .zero ..< digest.algorithm.blockSizeBytes {
            iSec[i] = macSec[i] ^ .hmac.ipad
            oSec[i] = macSec[i] ^ .hmac.opad
        }
        digest.update(iSec)
        digest.update(message)
        let d = digest.digest()
        digest.update(oSec)
        digest.update(d)
        return digest.digest()
    }
    
    public static func deriveKeySHA1(
        _ password: [UInt8],
        _ salt: [UInt8],
        _ length: Int,
        iterations: Int = KernelCryptography.AES.val.keyDerivationIterations
    ) -> [UInt8] {
        var hmac: Self = .init(.SHA1, password)
        let dLen = hmac.digest.algorithm.outputSizeBytes
        var t: [UInt8] = []
        let l = (length + dLen - 1) / dLen
        for i in 1...l {
            var f: [UInt8] = .zeroes(dLen)
            var u = salt
            u.append(.init((i >> 0x18) & 0xff))
            u.append(.init((i >> 0x10) & 0xff))
            u.append(.init((i >> 0x08) & 0xff))
            u.append(.init((i >> 0x00) & 0xff))
            for _ in .zero..<iterations {
                hmac.reset()
                u = hmac.finalise(u)
                for j in .zero..<dLen {
                    f[j] ^= u[j]
                }
            }
            t += f
        }
        return .init(t[.zero..<length])
    }
    
    public static func authenticationCode(
        _ algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm,
        _ sec: [UInt8],
        _ message: [UInt8]
    ) -> [UInt8] {
        var hmac: Self = .init(algorithm)
        hmac.initialise(sec)
        hmac.update(message)
        return hmac.finalise()
    }
}
