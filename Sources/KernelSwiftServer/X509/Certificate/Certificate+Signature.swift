//
//  File.swift
//
//
//  Created by Jonathan Forbes on 20/06/2023.
//

extension KernelX509.Certificate {
    public enum Signature: ASN1CompositeTypedDecodable {
        public static let compositeCount: Int = 2
        case ecdsa(KernelCryptography.EC.Signature)
        case rsa(KernelCryptography.RSA.Signature)
        
        public init(from asn1TypeArray: [KernelASN1.ASN1Type]) throws {
            guard asn1TypeArray.count == Self.compositeCount else { throw Self.decodingError(nil, asn1TypeArray[0]) }
            let sigAlg: KernelCryptography.Algorithms.AlgorithmIdentifier = try .init(from: asn1TypeArray[0])
            var underlying: Self? = nil
            switch sigAlg.algorithm {
            case
                    .pkcs1RSAEncryption,
                    .pkcs1MD2WithRSAEncryption,
                    .pkcs1MD5WithRSAEncryption,
                    .pkcs1SHA1WithRSAEncryption,
                    .pkcs1SHA224WithRSAEncryption,
                    .pkcs1SHA256WithRSAEncryption,
                    .pkcs1SHA384WithRSAEncryption,
                    .pkcs1SHA512WithRSAEncryption: underlying = .rsa(try .init(from: asn1TypeArray))
            case 
                    .x962ECDSAWithSHA1,
                    .x962ECDSAWithSHA224,
                    .x962ECDSAWithSHA256,
                    .x962ECDSAWithSHA384,
                    .x962ECDSAWithSHA512:
            var underlyingEC: KernelCryptography.EC.Signature = try .init(from: asn1TypeArray)
                underlyingEC.algorithmIdentifier = sigAlg
                underlying = .ecdsa(underlyingEC)
            default: break
            }
            guard let underlying else {
//                debugPrint(sigAlg.algorithm)
                throw Self.decodingError(.bitString, asn1TypeArray[1])
            }
            self = underlying
        }
        
        public func signatureAlgorithmASN1() -> KernelASN1.ASN1Type {
            switch self {
            case let .ecdsa(sig): sig.algorithmIdentifier.buildASN1Type()
            case let .rsa(sig): sig.algorithmIdentifier.buildASN1Type()
            }
        }
    }
}

extension KernelX509.Certificate.Signature: ASN1ArrayBuildable {
    public func buildASN1TypeArray() -> [KernelASN1.ASN1Type] {
        switch self {
        case let .ecdsa(sig): sig.buildASN1TypeArray()
        case let .rsa(sig): sig.buildASN1TypeArray()
        }
    }
    
    public func rawSignatureBytes() -> [UInt8] {
        switch self {
        case let .ecdsa(sig): sig.signatureBytes()
        case let .rsa(sig): sig.signatureBytes()
        }
    }
    
    public func signatureBitString() -> KernelASN1.ASN1Type {
        switch self {
        case let .ecdsa(sig): sig.signatureBitString()
        case let .rsa(sig): sig.signatureBitString()
        }
    }
}
//
//extension KernelX509.Certificate.Signature {
//    public enum UnderlyingSignature: Hashable, Sendable, Codable, ASN1Decodable {
////        case p256(Crypto.P256.Signing.ECDSASignature)
////        case p384(Crypto.P384.Signing.ECDSASignature)
////        case p521(Crypto.P521.Signing.ECDSASignature)
//        case ecdsa(KernelCryptography.EC.Signature)
//        case rsa(KernelCryptography.RSA.Signature)
//        
//        public static func == (lhs: Self, rhs: Self) -> Bool {
//            switch (lhs, rhs) {
//            case
////                (.p256(let l as X509RawRepresentable), .p256(let r as X509RawRepresentable)),
////                (.p384(let l as X509RawRepresentable), .p384(let r as X509RawRepresentable)),
////                (.p521(let l as X509RawRepresentable), .p521(let r as X509RawRepresentable)),
//                (.rsa(let l as X509RawRepresentable), .rsa(let r as X509RawRepresentable)),
//                (.ecdsa(let l as X509RawRepresentable), .ecdsa(let r as X509RawRepresentable)):
//                return l.rawRepresentation == r.rawRepresentation
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
////            case .p256: return "P256"
////            case .p384: return "P384"
////            case .p521: return "P521"
//            case .ecdsa: return "ECDSA"
//            case .rsa: return "RSA"
//            }
//        }
//        
//        public func hashableRepresentation() -> [UInt8] {
//            switch self {
//            case let .rsa(sig): simpleLabel().utf8Bytes + sig.rawBytes
//            case let .ecdsa(sig): simpleLabel().utf8Bytes + sig.rawRepresentation
//            }
//        }
//        
//        public init(from decoder: Decoder) throws {
//            preconditionFailure("Decoder not implemented")
//        }
//    }
//}
//
//extension KernelX509.Certificate.Signature.UnderlyingSignature: ASN1Buildable {
//    public func buildASN1Type() -> KernelASN1.ASN1Type {
//        switch self {
//        case let .rsa(sig): return sig.buildASN1Type()
//        case let .ecdsa(sig): return sig.buildASN1Type()
//        }
//    }
//}

//extension KernelX509.Certificate.Signature.UnderlyingSignature {
//    public var coordinateByteCount: Int? {
//        switch self {
//        case .p256: 32
//        case .p384: 48
//        case .p521: 66
//        case .rsa: nil
//        }
//    }
//}
//
//extension Crypto.P256.Signing.ECDSASignature: @unchecked Sendable {}
//extension Crypto.P384.Signing.ECDSASignature: @unchecked Sendable {}
//extension Crypto.P521.Signing.ECDSASignature: @unchecked Sendable {}
//extension _CryptoExtras._RSA.Signing.RSASignature: @unchecked Sendable {}
//
//extension Crypto.P256.Signing.ECDSASignature: X509RawRepresentable {}
//extension Crypto.P384.Signing.ECDSASignature: X509RawRepresentable {}
//extension Crypto.P521.Signing.ECDSASignature: X509RawRepresentable {}
//extension _CryptoExtras._RSA.Signing.RSASignature: X509RawRepresentable {}
