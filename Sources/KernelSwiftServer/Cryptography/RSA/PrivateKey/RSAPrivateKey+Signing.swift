//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.RSA.PrivateKey {
    public func sign(
        _ mode: KernelCryptography.RSA.SignatureMode,
        algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm,
        message: [UInt8]
    ) throws -> [UInt8] {
        switch mode {
        case .pkcs1: try signPKCS1(algorithm: algorithm, message: message)
        case .pss: try signPSS(algorithm: algorithm, message: message)
        }
    }
    
    public func sign(
        algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm,
        message: [UInt8]
    ) throws -> [UInt8] {
        switch algorithm.signatureMode {
        case .pkcs1: try signPKCS1(algorithm: algorithm, message: message)
        case .pss: try signPSS(algorithm: algorithm, message: message)
        }
    }
    
    private func signPKCS1(
        algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm,
        message: [UInt8]
    ) throws -> [UInt8] {
        let k = n.count * 8, dl = algorithm.outputSizeBytes, ic = algorithm.digestInfoOIDSize
        var md: KernelCryptography.MD.Digest = .init(algorithm)
        if k < dl + ic + 19 { throw KernelCryptography.TypedError(.signatureFailed, reason: "Hash size too large for key size") }
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
        let m: KernelNumerics.BigInt = .init(magnitudeBytes: em)
        let s = signaturePrimitive(m)
        var r = s.magnitudeBytes()
        if k > r.count { r.prepend(.zeroes(k - r.count)) }
        return r
    }
    
    private func signPSS(
        algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm,
        message: [UInt8]
    ) throws -> [UInt8] {
        let k = n.count * 8, dl = algorithm.outputSizeBytes
        var md: KernelCryptography.MD.Digest = .init(algorithm)
        guard k >= 2 * dl + 2 else { throw KernelCryptography.TypedError(.signatureFailed, reason: "Hash size too large for key size") }
        md.update(message)
        let mh = md.digest()
        let s: [UInt8] = .generateSecRandom(count: dl)
        let m: [UInt8] = .zeroes(8) + mh + s
        md.update(m)
        let h = md.digest()
        let ps: [UInt8] = .zeroes(k - 2 * dl - 2)
        let db = ps + [0x01] + s
        let dbm = KernelCryptography.RSA.MaskGeneration.mgf1(algorithm, mgfSeed: h, maskLen: k - dl - 1)
        var mdb = db
        for i in .zero..<mdb.count { mdb[i] ^= dbm[i] }
        mdb[.zero] <<= 1
        mdb[.zero] >>= 1
        let em = mdb + h + [0xbc]
        let im: KernelNumerics.BigInt = .init(magnitudeBytes: em)
        let es = signaturePrimitive(im)
        var r = es.magnitudeBytes()
        if k > r.count { r.prepend(.zeroes(k - r.count)) }
        return r
    }
    
    internal func signaturePrimitive(_ v: KernelNumerics.BigInt) -> KernelNumerics.BigInt {
        let a0 = v.expMod(dp, p)
        let a1 = v.expMod(dq, q)
        let h = ((a0 - a1) * q.modInverse(p)).mod(p)
        return (a1 + q * h).mod(n)
    }
}
