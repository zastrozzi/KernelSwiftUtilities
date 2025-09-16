//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2023.
//

extension KernelX509.Certificate {
    public struct PublicKey: ASN1Decodable {
//        public static var asn1DecodingSchema: DecodingSchema {
//            []
//        }
//        
        public var keyAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier
        public var underlyingKey: UnderlyingKey
        
        public init(
            keyAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier,
            underlyingKey: KernelX509.Certificate.PublicKey.UnderlyingKey
        ) {
            self.keyAlgorithm = keyAlgorithm
            self.underlyingKey = underlyingKey
        }
        
        public init(
            underlyingKey: KernelX509.Certificate.PublicKey.UnderlyingKey
        ) {
            self.keyAlgorithm = underlyingKey.keyAlg()
            self.underlyingKey = underlyingKey
        }
        
        public init(from decoder: KernelASN1.ASN1Decoder) throws {
            try self.init(from: decoder.asn1Type)
        }
        
        // TODO add EC
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            guard case let .sequence(sequenceItems) = asn1Type, sequenceItems.count == 2 else { throw Self.decodingError(.sequence, asn1Type) }
            if case .integer = sequenceItems[0], case .integer = sequenceItems[1] {
                self = .init(underlyingKey: .rsa(try .init(pkcs1: sequenceItems)))
            } else {
                let keyAlg: KernelCryptography.Algorithms.AlgorithmIdentifier = try .init(from: sequenceItems[0])
                var underlying: KernelX509.Certificate.PublicKey.UnderlyingKey? = nil
                switch keyAlg.algorithm {
                case
                        .pkcs1RSAEncryption,
                        .pkcs1MD2WithRSAEncryption,
                        .pkcs1MD5WithRSAEncryption,
                        .pkcs1SHA1WithRSAEncryption,
                        .pkcs1SHA224WithRSAEncryption,
                        .pkcs1SHA256WithRSAEncryption,
                        .pkcs1SHA384WithRSAEncryption,
                        .pkcs1SHA512WithRSAEncryption: underlying = .rsa(try .init(from: asn1Type))
                case .x962PublicKey: underlying  = .ec(try .init(from: asn1Type))
                    
                    
                default: underlying = nil
                }
                guard let underlying else { throw Self.decodingError(nil, asn1Type) }
                self.keyAlgorithm = keyAlg
                self.underlyingKey = underlying
            }
        }
        
        public func getDerivedIdentifier(idType: KernelCryptography.Common.DerivedKeyIdentifierType) -> KernelCryptography.Common.KeyIdentifier {
            switch idType {
            case .jwks: .jwks(underlyingKey.jwks())
            case .skid: .skid(underlyingKey.skid())
            case .x509t: .skid(underlyingKey.x509t())
            }
        }
    }
}

extension KernelX509.Certificate.PublicKey: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        underlyingKey.buildASN1Type()
    }
    
    public func buildASN1TypePKCS8() -> KernelASN1.ASN1Type {
        switch underlyingKey {
        case let .ec(underlying): underlying.buildASN1Type()
        case let .rsa(underlying): underlying.buildASN1TypePKCS8()
        }
    }
}

// TODO ADD EC
extension KernelX509.Certificate.PublicKey {
    public enum UnderlyingKey: Hashable, Sendable, ASN1Decodable {
        case ec(KernelCryptography.EC.PublicKey)
        case rsa(KernelCryptography.RSA.PublicKey)
        
//        public init(from decoder: Decoder) throws {
//            fatalError()
//        }
//        
//        public func encode(to encoder: Encoder) throws {
//            fatalError()
//        }
//        
        public func keyAlg() -> KernelCryptography.Algorithms.AlgorithmIdentifier {
            switch self {
            case let .ec(key): key.keyAlg()
            case let .rsa(key): key.keyAlg()
            }
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            guard case let .sequence(sequenceItems) = asn1Type, sequenceItems.count == 2 else { throw Self.decodingError(.sequence, asn1Type) }
            if case .integer = sequenceItems[0], case .integer = sequenceItems[1] {
                self = .rsa(try .init(pkcs1: sequenceItems))
            } else {
                let keyAlg: KernelCryptography.Algorithms.AlgorithmIdentifier = try .init(from: sequenceItems[0])
                var underlying: KernelX509.Certificate.PublicKey.UnderlyingKey? = nil
                switch keyAlg.algorithm {
                case
                        .pkcs1RSAEncryption,
                        .pkcs1MD2WithRSAEncryption,
                        .pkcs1MD5WithRSAEncryption,
                        .pkcs1SHA1WithRSAEncryption,
                        .pkcs1SHA224WithRSAEncryption,
                        .pkcs1SHA256WithRSAEncryption,
                        .pkcs1SHA384WithRSAEncryption,
                        .pkcs1SHA512WithRSAEncryption: underlying = .rsa(try .init(from: asn1Type))
                case .x962PublicKey: underlying  = .ec(try .init(from: asn1Type))
                    
                    
                default: underlying = nil
                }
                guard let underlying else { throw Self.decodingError(nil, asn1Type) }
                self = underlying
            }
        }
//
//        public static func == (lhs: Self, rhs: Self) -> Bool {
//            switch (lhs, rhs) {
//            case
//                (.ec(let l as X509PEMRepresentable), .ec(let r as X509PEMRepresentable)),
//                (.rsa(let l as X509PEMRepresentable), .rsa(let r as X509PEMRepresentable)):
//                return l.pemRepresentation == r.pemRepresentation
//            default: return false
//            }
//        }
//        
//        public func hash(into hasher: inout Hasher) {
//            hasher.combine(hashableRepresentation())
//        }
//        
//        public func simpleLabel() -> String {
//            switch self {
//            case .p256: return "P256"
//            case .p384: return "P384"
//            case .p521: return "P521"
//            case .rsa: return "RSA"
//            }
//        }
//        
//        public func hashableRepresentation() -> String {
//            switch self {
//            case
//                .p256(let key as X509PEMRepresentable),
//                .p384(let key as X509PEMRepresentable),
//                .p521(let key as X509PEMRepresentable),
//                .rsa(let key as X509PEMRepresentable):
//                return simpleLabel() + key.pemRepresentation
//            }
//        }
//        
        public func asn1KeyBytes() -> [UInt8] {
            switch self {
            case let .ec(key): key.buildASN1Type().serialise()
            case let .rsa(key): key.buildASN1Type().serialise()
            }
        }
        
        public func asn1KeyBytesPKCS1() -> [UInt8] {
            switch self {
            case let .ec(key): key.buildASN1Type().serialise()
            case let .rsa(key): key.buildASN1TypePKCS1().serialise()
            }
        }
        
        public func asn1KeyBytesPKCS8() -> [UInt8] {
            switch self {
            case let .ec(key): key.buildASN1TypePKCS8().serialise()
            case let .rsa(key): key.buildASN1TypePKCS8().serialise()
            }
        }
        
        public func skid() -> String {
            switch self {
            case let .ec(key): key.skidString(hashMode: .sha1pkcs1DerHex)
            case let .rsa(key): key.skidString(hashMode: .sha1pkcs1DerHex)
            }
        }
        
        public func x509t() -> String {
            switch self {
            case let .ec(key): key.skidString(hashMode: .sha1X509DerB64)
            case let .rsa(key): key.skidString(hashMode: .sha1X509DerB64)
            }
        }
        
        public func jwks() -> String {
            switch self {
            case let .ec(key): key.jwksKidString(hashMode: .sha1ThumbBase64Url)
            case let .rsa(key): key.jwksKidString(hashMode: .sha1ThumbBase64Url)
            }
        }
        
        public func fingerprintBytes(_ hashMode: KernelCryptography.Common.SKIDHashMode? = nil) -> [UInt8] {
            let algAndMsg: (KernelCryptography.Algorithms.MessageDigestAlgorithm, [UInt8]) = switch hashMode {
            case .sha256pkcs1DerHex: (.SHA2_256, asn1KeyBytesPKCS1())
            case .sha256X509DerHex: (.SHA2_256, asn1KeyBytesPKCS8())
            case .sha1pkcs1DerHex: (.SHA1, asn1KeyBytesPKCS1())
            case .sha1X509DerHex: (.SHA1, asn1KeyBytesPKCS8())
//            case .md5pkcs1DerHex: return Insecure.MD5.hash(data: key.pkcs1DERRepresentation).hexEncodedBytes(uppercase: true)
//            case .md5X509DerHex: return Insecure.MD5.hash(data: key.derRepresentation).hexEncodedBytes(uppercase: true)
            case .sha256pkcs1DerB64: (.SHA2_256, asn1KeyBytesPKCS1())
            case .sha256X509DerB64: (.SHA2_256, asn1KeyBytesPKCS8())
            case .sha1pkcs1DerB64: (.SHA1, asn1KeyBytesPKCS1())
            case .sha1X509DerB64: (.SHA1, asn1KeyBytesPKCS8())
//            case .md5pkcs1DerB64: return Array(Insecure.MD5.hash(data: key.pkcs1DERRepresentation)).base64Bytes()
//            case .md5X509DerB64: .SHA1
            default: (.SHA1, asn1KeyBytes())
            }
            let hash = KernelCryptography.MD.hash(algAndMsg.0, algAndMsg.1)
            return switch hashMode {
            case .sha256pkcs1DerB64, .sha256X509DerB64, .sha1pkcs1DerB64, .sha1X509DerB64: hash.base64Bytes()
            default: hash.hexEncodedBytes(uppercase: true)
            }
            
            
        }
        
        public func verify(signature: KernelX509.Certificate.Signature, digest: [UInt8], customPadding: Int? = nil) throws -> Bool {
            switch signature {
            case let .ecdsa(sig):
                switch self {
                case let .ec(key): key.verify(signature: sig, message: digest)
                case let .rsa(key): key.verify(algorithm: sig.digestAlg, signature: sig.rawRepresentation, message: digest)
                }
            case let .rsa(sig):
                switch self {
                case .ec: throw KernelX509.TypedError(.invalidSignatureForKeyType)
                case let .rsa(key): key.verify(algorithm: sig.digestAlg, signature: sig.rawRepresentation, message: digest)
                }
            }
        }
    }
}

extension KernelX509.Certificate.PublicKey.UnderlyingKey: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        switch self {
        case let .ec(key): key.buildASN1Type()
        case let .rsa(key): key.buildASN1Type()
        }
    }
}
