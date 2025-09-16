//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/04/2023.
//

import Foundation
import KernelSwiftCommon

public struct RSAJSONWebKey: JSONWebKeyRepresentable {
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
    
    /// RSA Public Key Modulus
    /// Base64URLEncoded UInt
    public var n: String?
    
    /// RSA Public Key Exponent
    /// Base64URLEncoded UInt
    public var e: String?
    
    /// RSA Private Key Exponent
    /// Base64URLEncoded UInt
    public var d: String?
    
    /// RSA Private Key First Prime Factor
    /// Base64URLEncoded UInt
    public var p: String?
    
    /// RSA Private Key Second Prime Factor
    /// Base64URLEncoded UInt
    public var q: String?
    
    /// RSA Private Key First Factor CRT Exponent
    /// Base64URLEncoded UInt
    public var dp: String?
    
    /// RSA Private Key Second Factor CRT Exponent
    /// Base64URLEncoded UInt
    public var dq: String?
    
    /// RSA Private Key First CRT Coefficient
    /// Base64URLEncoded UInt
    public var qi: String?
    
    /// RSA Private Key Other Primes Info
    public var oth: [JSONWebKeyOtherPrimeInfo]?
    
    public init(
        use: JSONWebKeyUse? = nil,
        keyOps: [JSONWebKeyOperation]? = nil,
        alg: JSONWebAlgorithm? = nil,
        kid: String? = nil,
        n: String? = nil,
        e: String? = nil,
        d: String? = nil,
        p: String? = nil,
        q: String? = nil,
        dp: String? = nil,
        dq: String? = nil,
        qi: String? = nil,
        oth: [JSONWebKeyOtherPrimeInfo]? = nil,
        x5u: String? = nil,
        x5t: String? = nil,
        x5tS256: String? = nil,
        x5c: [String]? = nil
    ) {
        self.kty = .rsa
        self.use = use
        self.keyOps = keyOps
        self.alg = alg
        self.kid = kid
        self.x5u = x5u
        self.x5t = x5t
        self.x5tS256 = x5tS256
        self.x5c = x5c
        self.n = n
        self.e = e
        self.d = d
        self.p = p
        self.q = q
        self.dp = dp
        self.dq = dq
        self.qi = qi
        self.oth = oth
    }

    public enum CodingKeys: String, CodingKey {
        case kty
        case use
        case keyOps = "key_ops"
        case alg
        case kid
        case x5u
        case x5t
        case x5tS256 = "x5t_s256"
        case x5c
        case n
        case e
        case d
        case p
        case q
        case dp
        case dq
        case qi
        case oth
    }
    
    struct Thumbprint: Codable {
        var e: String
        var kty: String
        var n: String
    }
    
    public func thumbprint() throws -> String {
        guard let e, let n, let kty else { throw JOSEError.jwkThumbprintFailed }
        let thumb: Thumbprint = .init(e: e, kty: kty.rawValue, n: n)
        let encoder = JSONEncoder()
        guard let thumbData = try? encoder.encode(thumb) else { throw JOSEError.jwkThumbprintFailed }
//        let hash = thumbData.digest(using: Digest.Algorithm.sha256).base64URLEncodedString()
        let hash = KernelCryptography.MD.hash(.SHA2_256, thumbData.copyBytes())
        guard let hash: String = .init(bytes: KernelSwiftCommon.Coding.Base64.encode(hash, type: .url), encoding: .utf8) else { throw JOSEError.jwkThumbprintFailed }
        return hash
    }
    
    var signatureAlgorithms: [JSONWebSignatureAlgorithm] {
        [.ps256, .ps384, .ps512, .rs256, .rs384, .rs512]
    }
    
    var encryptionAlgorithms: [JSONWebEncryptionAlgorithm] {
        [.rsaoaep, .rsaoeap256, .rsaoeap384, .rsaoeap512]
    }
    
    public enum SignatureAlgorithm: JSONWebSignatureAlgorithm, CaseIterable, Codable, Equatable {
        
        case ps256
        case ps384
        case ps512
        case rs256
        case rs384
        case rs512
        
        public init?(rawValue: JSONWebSignatureAlgorithm) {
            switch rawValue {
            case .ps256: self = .ps256
            case .ps384: self = .ps384
            case .ps512: self = .ps512
            case .rs256: self = .rs256
            case .rs384: self = .rs384
            case .rs512: self = .rs512
            default: return nil
            }
        }
        
        public var rawValue: JSONWebSignatureAlgorithm {
            switch self {
            case .ps256: return .ps256
            case .ps384: return .ps384
            case .ps512: return .ps512
            case .rs256: return .rs256
            case .rs384: return .rs384
            case .rs512: return .rs512
            }
        }
    }
    
    public enum EncryptionAlgorithm: JSONWebEncryptionAlgorithm, CaseIterable, Codable, Equatable {
        
        case rsaoaep
        case rsaoeap256
        case rsaoeap384
        case rsaoeap512
        
        public init?(rawValue: JSONWebEncryptionAlgorithm) {
            switch rawValue {
            case .rsaoaep: self = .rsaoaep
            case .rsaoeap256: self = .rsaoeap256
            case .rsaoeap384: self = .rsaoeap384
            case .rsaoeap512: self = .rsaoeap512
            default: return nil
            }
        }
        
        public var rawValue: JSONWebEncryptionAlgorithm {
            switch self {
            case .rsaoaep: return .rsaoaep
            case .rsaoeap256: return .rsaoeap256
            case .rsaoeap384: return .rsaoeap384
            case .rsaoeap512: return .rsaoeap512
            }
        }
    }
}
