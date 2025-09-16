//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/04/2023.
//

import Foundation
import KernelSwiftCommon

public struct AnyJSONWebKey: JSONWebKeyRepresentable {
    public func thumbprint() throws -> String {
        fatalError("Not implemented")
    }
    
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
