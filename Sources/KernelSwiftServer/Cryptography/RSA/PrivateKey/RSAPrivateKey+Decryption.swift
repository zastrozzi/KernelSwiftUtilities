//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.RSA.PrivateKey {
    public func decrypt(
        _ mode: KernelCryptography.RSA.EncryptionMode,
        cipher: [UInt8],
        label: [UInt8] = []
    ) throws -> [UInt8] {
        switch mode {
        case .pkcs1: try decryptPKCS1(cipher: cipher)
        case let .oaep(algorithm): try decryptOAEP(algorithm: algorithm, cipher: cipher, label: label)
        }
    }
    
    private func decryptPKCS1(cipher: [UInt8]) throws -> [UInt8] {
        let k = n.count * 8
        let l = cipher.count
        guard k == l else { throw KernelCryptography.TypedError(.decryptionFailed, reason: "Cipher does not match key size") }
        let c: KernelNumerics.BigInt = .init(magnitudeBytes: cipher)
        let m = signaturePrimitive(c)
        var em = Array(m.magnitudeBytes())
        if k > em.count { em.prepend(.zeroes(k - em.count)) }
        //        if em[0] != .zero || em[1] != 2 { throw KernelCryptography.TypedError(.decryptionFailed) }
        var i = 2
        while i < em.count && em[i] != .zero { i += 1 }
        //        if i < 10 || i == em.count || em[i] != .zero { throw KernelCryptography.TypedError(.decryptionFailed) }
        return .init(em[(i + 1)..<em.count])
    }
    
    private func decryptOAEP(
        algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm,
        cipher: [UInt8],
        label: [UInt8] = []
    ) throws -> [UInt8] {
        let k = n.count * 8
        let l = cipher.count
        guard k == l else { throw KernelCryptography.TypedError(.decryptionFailed, reason: "Cipher does not match key size") }
        var dig: KernelCryptography.MD.Digest = .init(algorithm)
        guard k >= 2 * algorithm.outputSizeBytes + 2 else { throw KernelCryptography.TypedError(.decryptionFailed, reason: "Hash size too large for key size") }
        let c: KernelNumerics.BigInt = .init(magnitudeBytes: cipher)
        let m = signaturePrimitive(c)
        var em: [UInt8] = .init(m.magnitudeBytes())
        if k > em.count { em.prepend(.zeroes(k - em.count)) }
        dig.update(label)
        let lh = dig.digest()
        guard em[.zero] == .zero else { throw KernelCryptography.TypedError(.decryptionFailed) }
        let ms: [UInt8] = .init(em[1...algorithm.outputSizeBytes])
        let mdb: [UInt8] = .init(em[(algorithm.outputSizeBytes + 1)..<em.count])
        let sm = KernelCryptography.RSA.MaskGeneration.mgf1(algorithm, mgfSeed: mdb, maskLen: algorithm.outputSizeBytes)
        var s: [UInt8] = ms
        for i in 0..<s.count { s[i] ^= sm[i] }
        let dbm = KernelCryptography.RSA.MaskGeneration.mgf1(algorithm, mgfSeed: s, maskLen: k - algorithm.outputSizeBytes - 1)
        var db: [UInt8] = mdb
        for i in .zero..<db.count { db[i] ^= dbm[i] }
        guard [UInt8].init(db[0..<algorithm.outputSizeBytes]) == lh else { throw KernelCryptography.TypedError(.decryptionFailed) }
        var i = algorithm.outputSizeBytes
        while (i < db.count && db[i] == .zero) { i += 1 }
        if i == db.count || db[i] != .one { throw KernelCryptography.TypedError(.decryptionFailed) }
        return .init(db[(i + 1)..<db.count])
    }
}

