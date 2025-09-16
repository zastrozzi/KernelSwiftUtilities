//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/04/2023.
//

import Foundation
import KernelSwiftCommon

public struct OctetSequenceJSONWebKey: JSONWebKeyRepresentable {
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
    
    public var k: String
    
//    public init(
//        use: JSONWebKeyUse? = nil,
//        keyOps: [JSONWebKeyOperation]? = nil,
//        alg: JSONWebAlgorithm? = nil,
//        kid: String? = nil,
//        x5u: String? = nil,
//        x5t: String? = nil,
//        x5tS256: String? = nil,
//        x5c: [String]? = nil,
//        k: String
//    ) {
//        self.kty = .oct
//        self.use = use
//        self.keyOps = keyOps
//        self.alg = alg
//        self.kid = kid
//        self.x5u = x5u
//        self.x5t = x5t
//        self.x5tS256 = x5tS256
//        self.x5c = x5c
//        self.k = k
//    }

    
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
        case k
    }
    
    struct Thumbprint: Codable {
        var k: String
        var kty: String
    }
    
    public func thumbprint() throws -> String {
        guard let kty else { throw JOSEError.jwkThumbprintFailed }
        let thumb: Thumbprint = .init(k: k, kty: kty.rawValue)
        let encoder = JSONEncoder()
        guard let thumbData = try? encoder.encode(thumb) else { throw JOSEError.jwkThumbprintFailed }
//        let hash = thumbData.digest(using: Digest.Algorithm.sha256).base64URLEncodedString()
        let hash = KernelCryptography.MD.hash(.SHA2_256, thumbData.copyBytes())
        guard let hash: String = .init(bytes: KernelSwiftCommon.Coding.Base64.encode(hash, type: .url), encoding: .utf8) else { throw JOSEError.jwkThumbprintFailed }
        return hash
    }
    
    public enum SignatureAlgorithm: JSONWebSignatureAlgorithm, CaseIterable, Codable, Equatable {
        
        case fallback
        
        public init?(rawValue: JSONWebSignatureAlgorithm) { self = .fallback }
        public var rawValue: JSONWebSignatureAlgorithm { .fallback }
    }
    
    public enum EncryptionAlgorithm: JSONWebEncryptionAlgorithm, CaseIterable, Codable, Equatable {
        
        case fallback
        
        public init?(rawValue: JSONWebEncryptionAlgorithm) { self = .fallback }
        public var rawValue: JSONWebEncryptionAlgorithm { .fallback }
    }
}
