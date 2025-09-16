//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/04/2023.
//

import Foundation
import KernelSwiftCommon

public struct OctetKeyPairJSONWebKey: JSONWebKeyRepresentable {
//    public var _stored: (any JSONWebKey)? = nil
    
    public var kty: JSONWebKeyType?
    public var use: JSONWebKeyUse?
    public var keyOps: [JSONWebKeyOperation]?
    public var alg: JSONWebAlgorithm?
    public var kid: String?
    
    public var x5u: String?
    public var x5t: String?
    public var x5tS256: String?
    public var x5c: [String]?
    
    public var crv: JSONWebEllipticCurve
    
    /// OKP Public Key X Coordinate
    /// Base64URLEncoded octet string
    public var x: String
    
    /// OKP Private Key
    /// Base64UrlEncoded octet string
    public var d: String
    
    public init(
        crv: JSONWebEllipticCurve,
        x: String,
        d: String,
        use: JSONWebKeyUse? = nil,
        alg: JSONWebAlgorithm? = nil,
        kid: String? = nil,
        keyOps: [JSONWebKeyOperation]? = nil,
        x5u: String? = nil,
        x5t: String? = nil,
        x5tS256: String? = nil,
        x5c: [String]? = nil
    ) {
        self.kty = .okp
        self.crv = crv
        self.x = x
        self.d = d
        self.use = use
        self.alg = alg
        self.kid = kid
        self.keyOps = keyOps
        self.x5u = x5u
        self.x5c = x5c
        self.x5t = x5t
        self.x5tS256 = x5tS256
    }

    
    enum CodingKeys: String, CodingKey {
        case kty
        case use
        case keyOps = "key_ops"
        case alg
        case kid
        case x5u
        case x5t
        case x5tS256 = "x5t#S256"
        case x5c
        case crv
        case x
        case d
    }
    
    struct Thumbprint: Codable {
        var crv: String
        var kty: String
        var x: String
    }
    
    public func thumbprint() throws -> String {
        guard let kty else { throw JOSEError.jwkThumbprintFailed }
        let thumb: Thumbprint = .init(crv: crv.rawValue, kty: kty.rawValue, x: x)
        let encoder = JSONEncoder()
        guard let thumbData = try? encoder.encode(thumb) else { throw JOSEError.jwkThumbprintFailed }
//        let hash = thumbData.digest(using: Digest.Algorithm.sha256).base64URLEncodedString()
        //        let digest = jwkCompData.digest(using: Digest.Algorithm.sha256)
        let hash = KernelCryptography.MD.hash(.SHA2_256, thumbData.copyBytes())
        guard let hash: String = .init(bytes: KernelSwiftCommon.Coding.Base64.encode(hash, type: .url), encoding: .utf8) else { throw JOSEError.jwkThumbprintFailed }
//        return digest
        return hash
    }
    
    var signatureAlgorithms: [JSONWebSignatureAlgorithm] {
        switch crv {
        case .p256, .p384, .p521, .secp256k1, .x25519, .x448: return []
        case .ed25519, .ed448: return [.eddsa]
        }
    }
    
    var encryptionAlgorithms: [JSONWebEncryptionAlgorithm] {
        switch crv {
        case .p256, .p384, .p521, .secp256k1, .ed25519, .ed448: return []
        case .x25519, .x448: return [.ecdhes, .ecdhesa128kw, .ecdhesa192kw, .ecdhesa256kw]
        }
    }
    
    public enum SignatureAlgorithm: JSONWebSignatureAlgorithm, CaseIterable, Codable, Equatable {
        
        case eddsa
        
        public init?(rawValue: JSONWebSignatureAlgorithm) {
            switch rawValue {
            case .eddsa: self = .eddsa
            default: return nil
            }
        }
        
        public var rawValue: JSONWebSignatureAlgorithm {
            switch self {
            case .eddsa: return .eddsa
            }
        }
    }
    
    public enum EncryptionAlgorithm: JSONWebEncryptionAlgorithm, CaseIterable, Codable, Equatable {
        
        case ecdhes
        case ecdhesa128kw
        case ecdhesa192kw
        case ecdhesa256kw
        
        public init?(rawValue: JSONWebEncryptionAlgorithm) {
            switch rawValue {
            case .ecdhes: self = .ecdhes
            case .ecdhesa128kw: self = .ecdhesa128kw
            case .ecdhesa192kw: self = .ecdhesa192kw
            case .ecdhesa256kw: self = .ecdhesa256kw
            default: return nil
            }
        }
        
        public var rawValue: JSONWebEncryptionAlgorithm {
            switch self {
            case .ecdhes: return .ecdhes
            case .ecdhesa128kw: return .ecdhesa128kw
            case .ecdhesa192kw: return .ecdhesa192kw
            case .ecdhesa256kw: return .ecdhesa256kw
            }
        }
    }
}
