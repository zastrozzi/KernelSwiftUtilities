//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.EC {
    public struct PrivateKey: Sendable, Equatable, Hashable {
        public let domain: KernelNumerics.EC.Domain
        public let s: KernelNumerics.BigInt
        public let keyFormat: KeyFormat
        
        public init(domain: KernelNumerics.EC.Domain, s: KernelNumerics.BigInt, keyFormat: KeyFormat) {
            self.domain = domain
            self.s = s
            self.keyFormat = keyFormat
        }
    }
}

extension KernelCryptography.EC.PrivateKey: ASN1Decodable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard
            case let .sequence(sequenceItems) = asn1Type,
            sequenceItems.count >= 2
        else { throw Self.decodingError(.sequence, asn1Type) }
        
        if case .sequence(_) = sequenceItems[1] { try self.init(pkcs8: sequenceItems) }
        else { try self.init(pkcs1: sequenceItems) }
    }
    
    public init(sequence: [KernelASN1.ASN1Type], keyFormat: KernelCryptography.EC.KeyFormat) throws {
        switch keyFormat {
        case .pkcs1: try self.init(pkcs1: sequence)
        case .pkcs8, .json: try self.init(pkcs8: sequence)
        case let .pkcs8Encrypted(password, _): try self.init(pkcs8Encrypted: .sequence(sequence), password: password ?? [])
        }
    }
}

extension KernelCryptography.EC.PrivateKey: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        switch keyFormat {
        case .pkcs1: buildASN1TypePKCS1()
        case .pkcs8, .json: buildASN1TypePKCS8()
        case let .pkcs8Encrypted(password, aes): buildEncryptedPKCS8(password: password ?? [], aes: aes ?? .b128)
        }
    }
}

extension KernelCryptography.EC.PrivateKey {
    func generateRS(_ input: [UInt8], _ tagLength: Int) throws -> (bw: Int, r: [UInt8], s: KernelNumerics.EC.Point) {
        let bw = 2 * ((domain.p.bitWidth + 7) / 8) + 1
        if input.count < bw + tagLength { throw KernelCryptography.TypedError(.invalidAESBufferLength) }
        let r: [UInt8] = .init(input[.zero..<bw])
        let sp = try domain.multiply(domain.decode(r), s)
        if sp.isInfinite { throw KernelCryptography.TypedError(.decryptionFailed) }
        return (bw, r, sp)
    }
    
    public func decrypt<S: KernelCryptography.Cipher.CipherStrategy>(input: [UInt8], keySize: KernelCryptography.AES.KeySize, as: S.Type = KernelCryptography.Cipher.GCM.self) throws -> [UInt8] {
        let (bw, r, sec) = try generateRS(input, S.blockMode.macSize)
        let tag1: [UInt8] = .init(input[input.count - S.blockMode.macSize ..< input.count])
        var b: [UInt8] = .init(input[bw ..< input.count - S.blockMode.macSize])
        var cipher = KernelCryptography.Cipher.initialise(keySize, S.self, sec.x.magnitudeBytes(), r)
        let tag2 = try cipher.decrypt(&b)
        if tag1 == tag2 { return b }
        throw KernelCryptography.TypedError(.decryptionFailed)
    }
    
    public func decryptChaCha(input: [UInt8], aad: [UInt8] = []) throws -> [UInt8] {
        let tagLength = 16
        let (bw, r, sec) = try generateRS(input, tagLength)
        let cipher: [UInt8] = .init(input[bw ..< input.count - tagLength])
        let tag: [UInt8] = .init(input[input.count - tagLength ..< input.count])
        let (key, nonce) = KernelCryptography.Cipher.deriveKey(32, 12, sec.x.magnitudeBytes(), r)
        let aead = try KernelCryptography.ChaCha.ChaChaPoly(key, nonce)
        var b = cipher
        let decrypted = aead.decrypt(&b, tag, aad)
        guard decrypted else { throw KernelCryptography.TypedError(.decryptionFailed) }
        return b
    }
    
    public func sign(sigAlg: KernelCryptography.Algorithms.AlgorithmIdentifier? = nil, digestAlg: KernelCryptography.Algorithms.MessageDigestAlgorithm? = nil, message: [UInt8], deterministic: Bool = false) -> KernelCryptography.EC.Signature {
        let digestAlg: KernelCryptography.Algorithms.MessageDigestAlgorithm = digestAlg ?? digestAlgFromDomain()
        let sigAlg: KernelCryptography.Algorithms.AlgorithmIdentifier = sigAlg ?? sigAlgFromDigestAlg(digestAlg)
        let hash = KernelCryptography.MD.hash(digestAlg, message)
        let order = domain.order
        let k = deterministic ? KernelCryptography.DSA.deterministicK(.init(digestAlg), order, s, hash) : .randomLessThan(order - .one) + .one
        let r = domain.generatePointForSecret(k)
        var h: KernelNumerics.BigInt = .init(magnitudeBytes: hash)
        let d = hash.count * 8 - order.bitWidth
        if d > .zero { h >>= d }
        let rm = r.x.mod(order)
        let sm = (k.modInverse(order) * (h + rm * s)).mod(order)
        return .init(algorithmIdentifier: sigAlg, r: rm, s: sm)
    }
    
    func digestAlgFromDomain() -> KernelCryptography.Algorithms.MessageDigestAlgorithm {
        switch domain.p.bitWidth {
        case ...224: .SHA2_224
        case ...256: .SHA2_256
        case ...384: .SHA2_384
        case ...512: .SHA2_512
        default: .SHA2_512
        }
    }
    
    func sigAlgFromDigestAlg(_ digestAlg: KernelCryptography.Algorithms.MessageDigestAlgorithm) -> KernelCryptography.Algorithms.AlgorithmIdentifier {
        switch digestAlg {
        case .SHA2_224, .SHA3_224: .init(algorithm: .x962ECDSAWithSHA224)
        case .SHA2_256, .SHA3_256: .init(algorithm: .x962ECDSAWithSHA256)
        case .SHA2_384, .SHA3_384: .init(algorithm: .x962ECDSAWithSHA384)
        case .SHA2_512, .SHA3_512: .init(algorithm: .x962ECDSAWithSHA512)
        case .SHA1: .init(algorithm: .x962ECDSAWithSHA1)
        }
    }
    
    public func sigAlg() -> KernelCryptography.Algorithms.AlgorithmIdentifier {
        sigAlgFromDigestAlg(digestAlgFromDomain())
    }
}
