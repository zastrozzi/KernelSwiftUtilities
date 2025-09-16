//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/06/2023.
//

import Vapor
//
//extension KernelX509.Certificate {
//    @usableFromInline
//    enum Digest {
//        case insecureSHA1(Insecure.SHA1Digest)
//        case sha256(SHA256Digest)
//        case sha384(SHA384Digest)
//        case sha512(SHA512Digest)
//
//        @inlinable
//        static func computeDigest<Bytes: DataProtocol>(for bytes: Bytes, using digestIdentifier: KernelCryptography.Algorithms.AlgorithmIdentifier) throws -> Digest {
//            let mda: KernelCryptography.Algorithms.MessageDigestAlgorithm = switch digestIdentifier.algorithm {
//            case .sha1: .SHA1
//            case .sha256: .SHA2_256
//            case .sha384: .SHA2_384
//            case .sha512: .SHA2_512
//            default: throw Abort(.insufficientStorage)
//            }
//            
//            var md = KernelCryptography.MD.Digest(mda)
//            switch digestIdentifier.algorithm {
//            case .sha1:
//                return .insecureSHA1(Insecure.SHA1.hash(data: bytes))
//            case .sha256:
//                return .sha256(SHA256.hash(data: bytes))
//            case .sha384:
//                return .sha384(SHA384.hash(data: bytes))
//            case .sha512:
//                return .sha512(SHA512.hash(data: bytes))
//            default:
//                throw Abort(.insufficientStorage)
//            }
//        }
//    }
//}
//
//extension P256.Signing.PrivateKey {
//    @inlinable
//    func signature<Bytes: DataProtocol>(for bytes: Bytes, digestAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier) throws -> KernelX509.Certificate.Signature {
//        switch try KernelX509.Certificate.Digest.computeDigest(for: bytes, using: digestAlgorithm) {
//        case .insecureSHA1(let hash): .init(signatureAlgorithm: .init(algorithm: .x962ECDSAWithSHA256), underlyingSignature: .ecdsa(try .init(self.signature(for: hash))))
//        case .sha256(let hash): .init(signatureAlgorithm: .init(algorithm: .x962ECDSAWithSHA256), underlyingSignature: .ecdsa(try .init(self.signature(for: hash))))
//        case .sha384(let hash): .init(signatureAlgorithm: .init(algorithm: .x962ECDSAWithSHA256), underlyingSignature: .ecdsa(try .init(self.signature(for: hash))))
//        case .sha512(let hash): .init(signatureAlgorithm: .init(algorithm: .x962ECDSAWithSHA256), underlyingSignature: .ecdsa(try .init(self.signature(for: hash))))
//        }
//    }
//}
//
//extension P384.Signing.PrivateKey {
//    @inlinable
//    func signature<Bytes: DataProtocol>(for bytes: Bytes, digestAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier) throws -> KernelX509.Certificate.Signature {
//        switch try KernelX509.Certificate.Digest.computeDigest(for: bytes, using: digestAlgorithm) {
//        case .insecureSHA1(let hash): .init(signatureAlgorithm: .init(algorithm: .x962ECDSAWithSHA384), underlyingSignature: .ecdsa(try .init(self.signature(for: hash))))
//        case .sha256(let hash): .init(signatureAlgorithm: .init(algorithm: .x962ECDSAWithSHA384), underlyingSignature: .ecdsa(try .init(self.signature(for: hash))))
//        case .sha384(let hash): .init(signatureAlgorithm: .init(algorithm: .x962ECDSAWithSHA384), underlyingSignature: .ecdsa(try .init(self.signature(for: hash))))
//        case .sha512(let hash): .init(signatureAlgorithm: .init(algorithm: .x962ECDSAWithSHA384), underlyingSignature: .ecdsa(try .init(self.signature(for: hash))))
//        }
//    }
//}
//
//extension P521.Signing.PrivateKey {
//    @inlinable
//    func signature<Bytes: DataProtocol>(for bytes: Bytes, digestAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier) throws -> KernelX509.Certificate.Signature {
//        switch try KernelX509.Certificate.Digest.computeDigest(for: bytes, using: digestAlgorithm) {
//        case .insecureSHA1(let hash): .init(signatureAlgorithm: .init(algorithm: .x962ECDSAWithSHA384), underlyingSignature: .ecdsa(try .init(self.signature(for: hash))))
//        case .sha256(let hash): .init(signatureAlgorithm: .init(algorithm: .x962ECDSAWithSHA384), underlyingSignature: .ecdsa(try .init(self.signature(for: hash))))
//        case .sha384(let hash): .init(signatureAlgorithm: .init(algorithm: .x962ECDSAWithSHA384), underlyingSignature: .ecdsa(try .init(self.signature(for: hash))))
//        case .sha512(let hash): .init(signatureAlgorithm: .init(algorithm: .x962ECDSAWithSHA384), underlyingSignature: .ecdsa(try .init(self.signature(for: hash))))
//        }
//    }
//}
//
//extension _RSA.Signing.PrivateKey {
//    @inlinable
//    func signature<Bytes: DataProtocol>(for bytes: Bytes, digestAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier, padding: _RSA.Signing.Padding) throws -> KernelX509.Certificate.Signature {
//        let signature: _RSA.Signing.RSASignature
//
//        switch try KernelX509.Certificate.Digest.computeDigest(for: bytes, using: digestAlgorithm) {
//        case .insecureSHA1(let sha1):
//            signature = try self.signature(for: sha1, padding: padding)
//        case .sha256(let sha256):
//            signature = try self.signature(for: sha256, padding: padding)
//        case .sha384(let sha384):
//            signature = try self.signature(for: sha384, padding: padding)
//        case .sha512(let sha512):
//            signature = try self.signature(for: sha512, padding: padding)
//        }
//
//        return KernelX509.Certificate.Signature.init(signatureAlgorithm: .init(algorithm: .pkcs1SHA256WithRSAEncryption), underlyingSignature: .rsa(signature))
//    }
//}
