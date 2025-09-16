//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/04/2023.
//

import Foundation

public enum JSONWebEncryptionAlgorithm: String, Codable, Equatable, CaseIterable, Sendable {
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
    case fallback
}

extension JSONWebEncryptionAlgorithm: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        guard let fromLiteral = JSONWebEncryptionAlgorithm(rawValue: value) else {
            self = .fallback
            return
        }
        self = fromLiteral
    }
}

extension JSONWebEncryptionAlgorithm {
    public func validKeyTypes(for curveAlg: JSONWebEllipticCurve? = nil) -> [JSONWebKeyType] {
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
            
        case .direct, .fallback: return []
        }
    }
    
    public func validEllipticCurves(for keyType: JSONWebKeyType? = nil) -> [JSONWebEllipticCurve] {
        switch self {
        case .ecdhes, .ecdhesa128kw, .ecdhesa192kw, .ecdhesa256kw:
            switch keyType {
            case .none: return [.p256, .p384, .p521, .x25519, .x448]
            case .ec: return [.p256, .p384, .p521]
            case .okp: return [.x25519, .x448]
            default: return []
            }
        default: return []
        }
    }
    
//    public var secKeyAlgorithm: SecKeyAlgorithm {
//        switch self {
//            
//        case .rsaoaep:
//            return .rsaEncryptionOAEPSHA1
//        case .rsaoeap256:
//            return .rsaEncryptionOAEPSHA256
//        case .rsaoeap384:
//            return .rsaEncryptionOAEPSHA384
//        case .rsaoeap512:
//            return .rsaEncryptionOAEPSHA512
//        case .ecdhes:
//            fatalError("")
//        case .ecdhesa128kw:
//            fatalError("")
//        case .ecdhesa192kw:
//            fatalError("")
//        case .ecdhesa256kw:
//            fatalError("")
//        case .a128kw:
//            fatalError("")
//        case .a192kw:
//            fatalError("")
//        case .a256kw:
//            fatalError("")
//        case .a128gcmkw:
//            fatalError("")
//        case .a192gcmkw:
//            fatalError("")
//        case .a256gcmkw:
//            fatalError("")
//        case .direct:
//            fatalError("")
//        case .fallback: fatalError("")
//        }
//    }
}
