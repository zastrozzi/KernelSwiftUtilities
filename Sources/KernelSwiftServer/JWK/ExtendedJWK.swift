//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/04/2023.
//

import Foundation
import KernelSwiftCommon


public struct ExtendedJWK: Codable, Equatable {
        
        
    public var kid: String?
    public var x5c: [String]?
    public var alg: JWKAlgorithm?
    public var crv: JWKEllipticCurveAlgorithm?
    public var d: String?
    public var dp: String?
    public var dq: String?
    public var e: String?
    public var ext: Bool?
    public var k: String?
    public var keyOps: [String]?
    public var kty: JWKKeyPairType?
    public var n: String?
    public var p: String?
    public var q: String?
    public var qi: String?
    public var use: JWKPublicKeyUse?
    public var x: String?
    public var y: String?
    
    internal init(
        kid: String? = nil,
        x5c: [String]? = nil,
        alg: JWKAlgorithm? = nil,
        crv: JWKEllipticCurveAlgorithm? = nil,
        d: String? = nil,
        dp: String? = nil,
        dq: String? = nil,
        e: String? = nil,
        ext: Bool? = nil,
        k: String? = nil,
        keyOps: [String]? = nil,
        kty: JWKKeyPairType? = nil,
        n: String? = nil,
        p: String? = nil,
        q: String? = nil,
        qi: String? = nil,
        use: JWKPublicKeyUse? = nil,
        x: String? = nil,
        y: String? = nil
    ) {
        self.kid = kid
        self.x5c = x5c
        self.alg = alg
        self.crv = crv
        self.d = d
        self.dp = dp
        self.dq = dq
        self.e = e
        self.ext = ext
        self.k = k
        self.keyOps = keyOps
        self.kty = kty
        self.n = n
        self.p = p
        self.q = q
        self.qi = qi
        self.use = use
        self.x = x
        self.y = y
    }

    
    enum CodingKeys: String, CodingKey {
        case kid
        case x5c
        case alg
        case crv
        case d
        case dp
        case dq
        case e
        case ext
        case k
        case keyOps = "key_ops"
        case kty
        case n
        case p
        case q
        case qi
        case use
        case x
        case y
    }
    
    public mutating func setValue<V>(for keyPath: WritableKeyPath<ExtendedJWK, V>, value: V) {
        self[keyPath: keyPath] = value
    }
    
    public mutating func removeValue<V>(for keyPath: WritableKeyPath<ExtendedJWK, Optional<V>>) {
        self[keyPath: keyPath] = nil
    }
    
    public func calculateKid() -> String? {
        guard let kty else { return nil }
        let jwkComps: ExtendedJWK
        
        switch kty {
        case .rsa:
            jwkComps = .init(e: e, kty: .rsa, n: n)
            break
        case .ec:
            jwkComps = .init(crv: crv, kty: .ec, x: x, y: y)
            break
        case .okp:
            jwkComps = .init(crv: crv, kty: .okp, x: x)
            break
        case .oct:
            return nil
        }
        
        let encoder = JSONEncoder()
        guard let jwkCompData = try? encoder.encode(jwkComps) else { return nil }
//        let digest = jwkCompData.digest(using: Digest.Algorithm.sha256)
//        return digest.base64URLEscaped().base64EncodedString()
        //        let digest = jwkCompData.digest(using: Digest.Algorithm.sha256)
        let hash = KernelCryptography.MD.hash(.SHA2_256, jwkCompData.copyBytes())
        guard let digest: String = .init(bytes: KernelSwiftCommon.Coding.Base64.encode(hash, type: .url), encoding: .utf8) else { return nil }
        return digest
    }

    public func signatureAlgorithms() -> [JSONWebSignatureAlgorithm] {
        guard let kty else { return [] }
        guard use == nil || use == .signature else { return [] }
        let available: [JSONWebSignatureAlgorithm]
        switch kty {
        case .rsa:
            available = [.ps256, .ps384, .ps512, .rs256, .rs384, .rs512]
            break
        case .ec:
            if let crv {
                switch crv {
                case .p256:
                    available = [.es256]
                    break
                case .p384:
                    available = [.es384]
                    break
                case .p521:
                    available = [.es512]
                    break
                case .secp256k1:
                    available = [.es256k]
                    break
                default:
                    available = []
                    break
                }
            }
            else { available = [] }
            break
        case .okp:
            if let crv {
                switch crv {
                case .ed25519:
                    available = [.eddsa]
                    break
                case .ed448:
                    available = [.eddsa]
                    break
                default:
                    available = []
                    break
                }
            }
            else { available = [] }
            break
        case .oct:
            available = []
            break
        }
        guard let alg, let sigAlg = alg.left else { return available }
        return available.contains(sigAlg) ? [sigAlg] : []
    }
    
    public func encryptionAlgorithms() -> [JWKEncryptionAlgorithm] {
        guard let kty else { return [] }
        guard use == nil || use == .encryption else { return [] }
        let available: [JWKEncryptionAlgorithm]
        switch kty {
        case .rsa:
            available = [.rsaoaep, .rsaoeap256, .rsaoeap384, .rsaoeap512]
            break
        case .ec:
            if let crv {
                switch crv {
                case .p256:
                    available = [.ecdhes, .ecdhesa128kw, .ecdhesa192kw, .ecdhesa256kw]
                    break
                case .p384:
                    available = [.ecdhes, .ecdhesa128kw, .ecdhesa192kw, .ecdhesa256kw]
                    break
                case .p521:
                    available = [.ecdhes, .ecdhesa128kw, .ecdhesa192kw, .ecdhesa256kw]
                    break
                case .secp256k1:
                    available = []
                    break
                default:
                    available = []
                    break
                }
            }
            else { available = [] }
            break
        case .okp:
            if let crv {
                switch crv {
                case .x25519:
                    available = [.ecdhes, .ecdhesa128kw, .ecdhesa192kw, .ecdhesa256kw]
                    break
                case .x448:
                    available = [.ecdhes, .ecdhesa128kw, .ecdhesa192kw, .ecdhesa256kw]
                    break
                default:
                    available = []
                    break
                }
            }
            else { available = [] }
            break
        case .oct:
            available = []
            break
        }
        guard let alg, let encAlg = alg.right else { return available }
        return available.contains(encAlg) ? [encAlg] : []
    }
}
