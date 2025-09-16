//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.RSA.PublicKey {
    public func verify(
        _ mode: KernelCryptography.RSA.SignatureMode,
        algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm,
        signature: [UInt8],
        message: [UInt8]
    ) -> Bool {
        switch mode {
        case .pkcs1: verifyPKCS1(algorithm: algorithm, signature: signature, message: message)
        case .pss: verifyPSS(algorithm: algorithm, signature: signature, message: message)
        }
    }
    
    public func verify(
        algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm,
        signature: [UInt8],
        message: [UInt8]
    ) -> Bool {
        switch algorithm.signatureMode {
        case .pkcs1: verifyPKCS1(algorithm: algorithm, signature: signature, message: message)
        case .pss: verifyPSS(algorithm: algorithm, signature: signature, message: message)
        }
    }
    
    private func verifyPKCS1(algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm, signature: [UInt8], message: [UInt8]) -> Bool {
        let k = n.count * 8, ic = algorithm.digestInfoOIDSize
        if signature.count != k { return false }
        var md: KernelCryptography.MD.Digest = .init(algorithm)
        md.update(message)
        let h = md.digest()
        let asn1: KernelASN1.ASN1Type = .sequence([
            .sequence([
                .objectIdentifier(.init(oid: algorithm.objectIdentifier)),
                .null(.init())
            ]),
            .octetString(.init(data: h))
        ])
        let asn1Bytes = KernelASN1.ASN1Writer.dataFromObject(asn1)
        var em: [UInt8] = [0x00, 0x01]
        em.append(contentsOf: [UInt8].fill((k - h.count - ic - 11), with: 0xff))
        em.append(.zero)
        em.append(contentsOf: asn1Bytes)
        
        let s: KernelNumerics.BigInt = .init(magnitudeBytes: signature)
        let m = s.expMod(e, n)
        var em1 = m.magnitudeBytes()
        if k > em1.count { em1.prepend(.zeroes(k - em1.count)) }
        return em == em1
    }
    
    private func verifyPSS(algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm, signature: [UInt8], message: [UInt8]) -> Bool {
        let k = n.count * 8, dl = algorithm.outputSizeBytes
        if signature.count != k { return false }
        let s: KernelNumerics.BigInt = .init(magnitudeBytes: signature)
        let m = s.expMod(e, n)
        var em = m.magnitudeBytes()
        if k > em.count { em.prepend(.zeroes(k - em.count)) }
        var md: KernelCryptography.MD.Digest = .init(algorithm)
        if k < 2 * dl + 2 { return false }
        md.update(message)
        let mh = md.digest()
        if em[k - 1] != .val.base10.oneHundredEightyEight { return false }
        let mdb: [UInt8] = .init(em[.zero..<(k - dl - 1)])
        let h: [UInt8] = .init(em[(k - dl - 1)..<(k - 1)])
        if mdb[.zero] >> 7 != .zero { return false }
        let dbm = KernelCryptography.RSA.MaskGeneration.mgf1(algorithm, mgfSeed: h, maskLen: k - dl - 1)
        var db = mdb
        for i in .zero..<db.count { db[i] ^= dbm[i] }
        db[.zero] <<= 1
        db[.zero] >>= 1
        for i in .zero..<(k - 2 * dl - 2) {
            if db[i] != .zero { return false }
        }
        if db[k - 2 * dl - 2] != .one { return false }
        let sa = db[(db.count - dl)..<db.count]
        let mb: [UInt8] = .zeroes(8) + mh + sa
        md.update(mb)
        let hm = md.digest()
        return h == hm
    }
}

