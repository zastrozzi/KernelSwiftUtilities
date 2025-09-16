//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.RSA.PublicKey {
    public func encrypt(_ mode: KernelCryptography.RSA.EncryptionMode, message: [UInt8], label: [UInt8] = []) throws -> [UInt8] {
        switch mode {
        case .pkcs1: try encryptPKCS1(message: message)
        case let .oaep(algorithm): try encryptOAEP(algorithm: algorithm, message: message, label: label)
        }
    }
    
    private func encryptOAEP(algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm, message: [UInt8], label: [UInt8] = []) throws -> [UInt8] {
        let k = n.count * 8, ml = message.count, dl = algorithm.outputSizeBytes
        let cl = k - 2 * dl - 2, cl2 = k - ml - 2 * dl - 2
        var d: KernelCryptography.MD.Digest = .init(algorithm)
        if ml > cl { throw KernelCryptography.TypedError(.encryptionFailed, reason: "Message too large for encryption") }
        d.update(label)
        let h = d.digest()
        let ps: [UInt8] = .zeroes(cl2)
        let db = h + ps + .fill(1, with: 0x01) + message
        let s: [UInt8] = .generateSecRandom(count: dl)
        let dbm = KernelCryptography.RSA.MaskGeneration.mgf1(algorithm, mgfSeed: s, maskLen: k - dl - 1)
        var mdb = db
        for i in .zero..<mdb.count { mdb[i] ^= dbm[i] }
        let sm = KernelCryptography.RSA.MaskGeneration.mgf1(algorithm, mgfSeed: mdb, maskLen: dl)
        var ms = s
        for i in .zero..<ms.count { ms[i] ^= sm[i] }
        let em: [UInt8] = .zeroes(1) + ms + mdb
        assert(em.count == k)
        let m: KernelNumerics.BigInt = .init(magnitudeBytes: em).expMod(e, n)
        var b = m.magnitudeBytes()
        if b.count < k { b.prepend(.zeroes(k - b.count)) }
        return b
    }
    
    private func encryptPKCS1(message: [UInt8]) throws -> [UInt8] {
        let k = n.count * 8
        let l = message.count
        if l > k - 11 { throw KernelCryptography.TypedError(.encryptionFailed, reason: "Message too large for encryption") }
        var em: [UInt8] = .init(repeating: 0x00, count: k)
        em[1] = 0x02
        em.replaceSubrange(2..<(k - 1 - l), with: [UInt8].generateSecRandom(count: k - 3 - l))
        for i in 2..<(k - l - 1) { if em[i] == .zero { em[i] = 0x01 } }
        for i in .zero..<l { em[k - l + i] = message[i] }
        let emu: KernelNumerics.BigInt = .init(magnitudeBytes: em).expMod(e, n)
        var b = emu.magnitudeBytes()
        if b.count < k { b.prepend(.zeroes(k - b.count)) }
        return b
    }
}
