//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/06/2023.
//
import KernelSwiftCommon

extension KernelASN1 {
    public enum ASN1AlgorithmIdentifier: String, ASN1Decodable, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable {
        public static let fluentEnumName: String = "k_asn1-alg_id"
        case sha1
        case sha256
        case sha384
        case sha512
        case x962PublicKey
        case x962PublicKeyRestricted
        case x962ECDSAWithSHA1
        case x962ECDSAWithSHA224
        case x962ECDSAWithSHA256
        case x962ECDSAWithSHA384
        case x962ECDSAWithSHA512
        case pkcs1SHA1WithRSAEncryption
        case pkcs1SHA256WithRSAEncryption
        case pkcs1SHA384WithRSAEncryption
        case pkcs1SHA512WithRSAEncryption
        case pkcs1SHA224WithRSAEncryption
        case pkcs1RSAEncryption
        case pkcs1MD2WithRSAEncryption
        case pkcs1MD5WithRSAEncryption
        
        public init(from decoder: ASN1Decoder) throws {
            throw Self.decodingError(nil, nil)
        }
    }
}
extension KernelASN1.ASN1AlgorithmIdentifier {
    public var asn1ObjectID: KernelSwiftCommon.ObjectID {
        switch self {
        case .sha1: return .sha1
        case .sha256: return .sha256
        case .sha384: return .sha384
        case .sha512: return .sha512
        case .x962PublicKey: return .x962PublicKey
        case .x962PublicKeyRestricted: return .x962PublicKeyRestricted
        case .x962ECDSAWithSHA1: return .x962ECDSAWithSHA1
        case .x962ECDSAWithSHA224: return .x962ECDSAWithSHA224
        case .x962ECDSAWithSHA256: return .x962ECDSAWithSHA256
        case .x962ECDSAWithSHA384: return .x962ECDSAWithSHA384
        case .x962ECDSAWithSHA512: return .x962ECDSAWithSHA512
        case .pkcs1SHA1WithRSAEncryption: return .pkcs1SHA1WithRSAEncryption
        case .pkcs1SHA256WithRSAEncryption: return .pkcs1SHA256WithRSAEncryption
        case .pkcs1SHA384WithRSAEncryption: return .pkcs1SHA384WithRSAEncryption
        case .pkcs1SHA512WithRSAEncryption: return .pkcs1SHA512WithRSAEncryption
        case .pkcs1SHA224WithRSAEncryption: return .pkcs1SHA224WithRSAEncryption
        case .pkcs1RSAEncryption: return .pkcs1RSAEncryption
        case .pkcs1MD2WithRSAEncryption: return .pkcs1MD2WithRSAEncryption
        case .pkcs1MD5WithRSAEncryption: return .pkcs1MD5WithRSAEncryption
        }
    }
}

extension KernelASN1.ASN1AlgorithmIdentifier: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        .objectIdentifier(.init(oid: asn1ObjectID))
    }
}

extension KernelASN1.ASN1AlgorithmIdentifier {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .objectIdentifier(objectId) = asn1Type else { throw Self.decodingError(.objectIdentifier, asn1Type) }
        let found: Self? = switch objectId.oid {
        case .sha1: .sha1
        case .sha256: .sha256
        case .sha384: .sha384
        case .sha512: .sha512
        case .x962PublicKey: .x962PublicKey
        case .x962PublicKeyRestricted: .x962PublicKeyRestricted
        case .x962ECDSAWithSHA1: .x962ECDSAWithSHA1
        case .x962ECDSAWithSHA224: .x962ECDSAWithSHA224
        case .x962ECDSAWithSHA256: .x962ECDSAWithSHA256
        case .x962ECDSAWithSHA384: .x962ECDSAWithSHA384
        case .x962ECDSAWithSHA512: .x962ECDSAWithSHA512
        case .pkcs1SHA1WithRSAEncryption: .pkcs1SHA1WithRSAEncryption
        case .pkcs1SHA256WithRSAEncryption: .pkcs1SHA256WithRSAEncryption
        case .pkcs1SHA384WithRSAEncryption: .pkcs1SHA384WithRSAEncryption
        case .pkcs1SHA512WithRSAEncryption: .pkcs1SHA512WithRSAEncryption
        case .pkcs1SHA224WithRSAEncryption: .pkcs1SHA224WithRSAEncryption
        case .pkcs1RSAEncryption: .pkcs1RSAEncryption
        case .pkcs1MD2WithRSAEncryption: .pkcs1MD2WithRSAEncryption
        case .pkcs1MD5WithRSAEncryption: .pkcs1MD5WithRSAEncryption
        default: nil
        }
        guard let found else { throw Self.decodingError(.objectIdentifier, asn1Type) }
        self = found
    }
}
