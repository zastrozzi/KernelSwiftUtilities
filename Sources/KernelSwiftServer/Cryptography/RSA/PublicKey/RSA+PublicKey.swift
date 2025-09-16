//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.RSA {
    public struct PublicKey: Sendable, Equatable, Hashable {
        public let n: KernelNumerics.BigInt
        public let e: KernelNumerics.BigInt
        public let keySize: KeySize
        public let keyFormat: KeyFormat
        
        public init(
            n: KernelNumerics.BigInt,
            e: KernelNumerics.BigInt,
            keySize: KeySize,
            keyFormat: KeyFormat
        ) {
            self.n = n
            self.e = e
            self.keySize = keySize
            self.keyFormat = keyFormat
        }
    }
}

extension KernelCryptography.RSA.PublicKey {
    public func keyAlg() -> KernelCryptography.Algorithms.AlgorithmIdentifier {
        .init(algorithm: .pkcs1RSAEncryption)
    }
}

extension KernelCryptography.RSA.PublicKey: ASN1Decodable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .sequence(sequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
        guard sequenceItems.count >= 2 else { throw Self.decodingError(.sequence, asn1Type) }
        switch sequenceItems[1] {
        case .bitString(_): try self.init(pkcs8: sequenceItems)
        default: try self.init(pkcs1: sequenceItems)
        }
    }
    
    public init(sequence: [KernelASN1.ASN1Type], keyFormat: KernelCryptography.RSA.KeyFormat) throws {
        switch keyFormat {
        case .json: try self.init(pkcs1: sequence)
        case .pkcs1: try self.init(pkcs1: sequence)
        case .pkcs8: try self.init(pkcs8: sequence)
        case .pkcs8Encrypted: try self.init(pkcs8: sequence)
        }
    }
}

extension KernelCryptography.RSA.PublicKey: ASN1Buildable, ASN1Serialisable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        switch keyFormat {
        case .json: buildASN1TypePKCS1()
        case .pkcs1: buildASN1TypePKCS1()
        case .pkcs8: buildASN1TypePKCS8()
        case .pkcs8Encrypted: buildASN1TypePKCS8()
        }
    }
    
    public func skidString(hashMode: KernelCryptography.Common.SKIDHashMode) -> String {
        switch hashMode {
        case .sha256pkcs1DerHex: return KernelCryptography.MD.hash(.SHA2_256, buildASN1TypePKCS1().serialise()).hexEncodedString(uppercase: true)
        case .sha256X509DerHex: return KernelCryptography.MD.hash(.SHA2_256, buildASN1TypePKCS8().serialise()).hexEncodedString(uppercase: true)
        case .sha1pkcs1DerHex: return KernelCryptography.MD.hash(.SHA1, buildASN1TypePKCS1().serialise()).hexEncodedString(uppercase: true)
        case .sha1X509DerHex: return KernelCryptography.MD.hash(.SHA1, buildASN1TypePKCS8().serialise()).hexEncodedString(uppercase: true)
        case .sha256pkcs1DerB64: return KernelCryptography.MD.hash(.SHA2_256, buildASN1TypePKCS1().serialise()).base64String()
        case .sha256X509DerB64: return KernelCryptography.MD.hash(.SHA2_256, buildASN1TypePKCS8().serialise()).base64String()
        case .sha1pkcs1DerB64: return KernelCryptography.MD.hash(.SHA1, buildASN1TypePKCS1().serialise()).base64String()
        case .sha1X509DerB64: return KernelCryptography.MD.hash(.SHA1, buildASN1TypePKCS8().serialise()).base64String()
        default: preconditionFailure("md5 not implemented")
        }
    }
    
    public func jwksKidString(hashMode: KernelCryptography.Common.JWKSKIDHashMode) -> String {
        let thumbData: KernelCryptography.RSA.JWKSThumbprintData = .init(
            e: e.signedBytes().base64String(),
            kty: "RSA",
            n: n.signedBytes().base64String()
        )
        guard let encoded = try? KernelSwiftCommon.Coding.lexicographicJSONEncoder.encode(thumbData)
        else {
            KernelCryptography.logger.report(error: KernelCryptography.TypedError(.invalidKeyLength))
            preconditionFailure()
        }
        switch hashMode {
        case .sha1ThumbBase64Url: return KernelCryptography.MD.hash(.SHA1, .init(encoded)).base64String()
        case .sha256ThumbBase64Url: return KernelCryptography.MD.hash(.SHA2_256, .init(encoded)).base64String()
        }
        
    }
}


