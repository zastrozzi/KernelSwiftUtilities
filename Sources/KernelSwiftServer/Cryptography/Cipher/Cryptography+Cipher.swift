//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 25/10/2023.
//

import Foundation

extension KernelCryptography {
    public enum Cipher {}
}

extension KernelCryptography.Cipher {
    public static let initialisationVector: [UInt8] = .zeroes(AES.val.blockSize)
    
    public static func initialise<S: CipherStrategy>(
        kdf: Bool = true,
        _ keySize: AES.KeySize,
        _ as: S.Type = S.self,
        _ s: [UInt8],
        _ r: [UInt8],
        _ v: [UInt8] = Self.initialisationVector
    ) -> S {
        
        let (key, mac) = kdf ? deriveKey(keySize, S.blockMode, s, r) : (s, r)
        switch S.blockMode {
        case .CBC: return CBC(secret: key, macSecret: mac, xor: v) as! S
        case .CFB: return CFB(secret: key, macSecret: mac, xor: v) as! S
        case .CTR: return CTR(secret: key, macSecret: mac, xor: v) as! S
        case .ECB: return ECB(secret: key, macSecret: mac) as! S
        case .GCM: return GCM(secret: key, macSecret: mac) as! S
        case .OFB: return OFB(secret: key, macSecret: mac, xor: v) as! S
        }
    }
    
    public static func deriveKey(
        _ keySize: AES.KeySize,
        _ mode: BlockMode,
        _ s: [UInt8],
        _ r: [UInt8]
    ) -> (key: [UInt8], mac: [UInt8]) { deriveKey(keySize.byteWidth, mode.macSize, s, r) }
    
    public static func deriveKey(
        _ keySize: Int,
        _ macSize: Int,
        _ s: [UInt8],
        _ r: [UInt8]
    ) -> (key: [UInt8], mac: [UInt8]) {
        var key: [UInt8] = .zeroes(keySize)
        var mac: [UInt8] = .zeroes(macSize)
        var md: MD.Digest = .init(.SHA2_256)
        md.update(s)
        md.update([.zero, .zero, .zero, .one])
        md.update(r)
        let d1 = md.digest()
        md.update(s)
        md.update([.zero, .zero, .zero, .two])
        md.update(r)
        let d2 = md.digest()
        key = .init(d1[.zero..<keySize])
        mac = if keySize + macSize < md.algorithm.outputSizeBytes { .init(d1[keySize..<(keySize + macSize)]) }
        else {
            .init(d1[keySize..<md.algorithm.outputSizeBytes])
            + .init(d2[.zero..<(macSize + keySize - md.algorithm.outputSizeBytes)])
        }
        return (key, mac)
    }
}
