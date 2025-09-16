//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

import Vapor

extension KernelX509.Certificate {
    public struct PrivateKey: ASN1Decodable {
        public var keyAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier
        public var underlyingKey: UnderlyingKey
        
        public init(
            keyAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier,
            underlyingKey: UnderlyingKey
        ) {
            self.keyAlgorithm = keyAlgorithm
            self.underlyingKey = underlyingKey
        }
        
        internal func sign(bytes: [UInt8], signatureAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier) throws -> Signature {
            let digestAlgorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm
            switch signatureAlgorithm.algorithm {
            case .x962ECDSAWithSHA224: digestAlgorithm = .SHA2_224
            case .x962ECDSAWithSHA256, .pkcs1SHA256WithRSAEncryption: digestAlgorithm = .SHA2_256
            case .x962ECDSAWithSHA384, .pkcs1SHA384WithRSAEncryption: digestAlgorithm = .SHA2_384
            case .x962ECDSAWithSHA512, .pkcs1SHA512WithRSAEncryption: digestAlgorithm = .SHA2_512
            case .x962ECDSAWithSHA1, .pkcs1SHA1WithRSAEncryption: digestAlgorithm = .SHA1
            default: throw Abort(.forbidden, reason: "Unsupported signature algorithm")
            }
            
            switch  underlyingKey {
            case let .ec(key): return .ecdsa(key.sign(sigAlg: signatureAlgorithm, digestAlg: digestAlgorithm, message: bytes, deterministic: false))
            case let .rsa(key): return .rsa(.init(algorithmIdentifier: keyAlgorithm, rawBytes: try key.sign(algorithm: digestAlgorithm, message: bytes)))
            }
        }
    }
}

extension KernelX509.Certificate.PrivateKey {
    public enum UnderlyingKey: Hashable, Sendable, Codable, ASN1Decodable {
//        case p256(Crypto.P256.Signing.PrivateKey)
//        case p384(Crypto.P384.Signing.PrivateKey)
        case ec(KernelCryptography.EC.PrivateKey)
        case rsa(KernelCryptography.RSA.PrivateKey)
//        
//        public func hash(into hasher: inout Hasher) {
//            hasher.combine(hashableRepresentation())
//        }
        
        public func simpleLabel() -> String {
            switch self {
            case .ec: return "EC"
            case .rsa: return "RSA"
            }
        }
        
        public init(from decoder: Decoder) throws {
            throw Abort(.notImplemented, reason: "Not implemented")
        }
        
        public init(fromASN decoder: KernelASN1.ASN1Decoder) throws {
            throw Abort(.notImplemented, reason: "Not implemented")
        }
    }
}

extension KernelX509.Certificate.PrivateKey.UnderlyingKey: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        switch self {
        case let .ec(key): key.buildASN1Type()
        case let .rsa(key): key.buildASN1Type()
        }
    }
}
