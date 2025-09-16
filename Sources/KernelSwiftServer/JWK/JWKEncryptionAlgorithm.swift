//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/04/2023.
//

import Foundation

public enum JWKEncryptionAlgorithm: String, Codable, Equatable, CaseIterable, Sendable {
    case rsaoaep = "RSA-OAEP"
    case rsaoeap256 = "RSA-OAEP-256"
    case rsaoeap384 = "RSA-OAEP-384"
    case rsaoeap512 = "RSA-OAEP-512"
    case ecdhes = "ECDH-ES"
    case ecdhesa128kw = "ECDH-ES+A128KW"
    case ecdhesa192kw = "ECDH-ES+A192KW"
    case ecdhesa256kw = "ECDH-ES+A256KW"
    case a128kw = "A128KW"
    case a192kw = "A192KW"
    case a256kw = "A256KW"
    case a128gcmkw = "A128GCMKW"
    case a192gcmkw = "A192GCMKW"
    case a256gcmkw = "A256GCMKW"
    case direct = "dir"
}

extension JWKEncryptionAlgorithm {
    public func jwkKeyPairType(curveAlg: JWKEllipticCurveAlgorithm? = nil) -> [JWKKeyPairType] {
        switch self {
        case .a128kw, .a192kw, .a256kw, .a128gcmkw, .a192gcmkw, .a256gcmkw: return [.oct]
        case .rsaoaep, .rsaoeap256, .rsaoeap384, .rsaoeap512: return [.rsa]
        case .ecdhes, .ecdhesa128kw, .ecdhesa192kw, .ecdhesa256kw:
            if let curveAlg {
                switch curveAlg {
                case .x25519, .x448: return [.okp]
                default: return [.ec]
                }
            }
            return [.okp, .ec]
            
        case .direct: return []
        }
    }
}
