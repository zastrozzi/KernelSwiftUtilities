//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/04/2023.
//

import Foundation

public enum JSONWebSignatureAlgorithm: String, Codable, Equatable, CaseIterable, Sendable {
    case ps256 = "PS256"
    case ps384 = "PS384"
    case ps512 = "PS512"
    case es256 = "ES256"
    case es256k = "ES256K"
    case es384 = "ES384"
    case es512 = "ES512"
    case eddsa = "EdDSA"
    case rs256 = "RS256"
    case rs384 = "RS384"
    case rs512 = "RS512"
    case hs256 = "HS256"
    case hs384 = "HS384"
    case hs512 = "HS512"
    case fallback
}

extension JSONWebSignatureAlgorithm: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        guard let fromLiteral = JSONWebSignatureAlgorithm(rawValue: value) else {
            self = .fallback
            return
        }
        self = fromLiteral
    }
}

extension JSONWebSignatureAlgorithm {
    public func validKeyTypes() -> [JSONWebKeyType] {
        switch self {
        case .ps256, .ps384, .ps512, .rs256, .rs384, .rs512: return [.rsa]
        case .hs256, .hs384, .hs512: return [.oct]
        case .es256, .es384, .es512, .es256k: return [.ec]
        case .eddsa: return [.okp]
        case .fallback: return []
        }
    }
    
    public func validEllipticCurves(for keyType: JSONWebKeyType? = nil) -> [JSONWebEllipticCurve] {
        switch keyType {
        case .none:
            switch self {
            case .es256: return [.p256]
            case .es384: return [.p384]
            case .es512: return [.p521]
            case .es256k: return [.secp256k1]
            case .eddsa: return [.ed25519, .ed448]
            default: return []
            }
        case .ec:
            switch self {
            case .es256: return [.p256]
            case .es384: return [.p384]
            case .es512: return [.p521]
            case .es256k: return [.secp256k1]
            default: return []
            }
        case .okp:
            switch self {
            case .eddsa: return [.ed25519, .ed448]
            default: return []
            }
        default: return []
        }
        
    }
    
    public var isSymmetric: Bool {
        switch self {
        case .hs256, .hs384, .hs512: return true
        default: return false
        }
    }
    
    public var isAsymmetric: Bool {
        switch self {
        case .hs256, .hs384, .hs512: return false
        default: return true
        }
    }
    
//    public var secKeyAlgorithm: SecKeyAlgorithm {
//        switch self {
//        case .ps256:
//            return .rsaSignatureMessagePSSSHA256
//        case .ps384:
//            return .rsaSignatureMessagePSSSHA384
//        case .ps512:
//            return .rsaSignatureMessagePSSSHA512
//        case .es256:
//            fatalError("")
//        case .es256k:
//            fatalError("")
//        case .es384:
//            fatalError("")
//        case .es512:
//            fatalError("")
//        case .eddsa:
//            fatalError("")
//        case .rs256:
//            fatalError("")
//        case .rs384:
//            fatalError("")
//        case .rs512:
//            fatalError("")
//        case .hs256:
//            fatalError("")
//        case .hs384:
//            fatalError("")
//        case .hs512:
//            fatalError("")
//        case .fallback:
//            fatalError("")
//        }
//    }
}


// 460550 1 Apr Transaction
// 461249 3 Apr Transaction
// 464104 6 Apr Transaction
// 468694 10 Apr Transaction
// 476136 13 Apr Transaction
// 484366 15 Apr Transaction
// 496976 17 Apr Transaction

// 699 total 1 Apr - 3 Apr
// 71 moneymona 1 Apr - 3 Apr
// 10.1%


// 3554 total 1 Apr - 6 Apr
// 1622 moneymona 1 Apr - 6 Apr
// 45.6%

// 36426 total since 1 Apr
// 26862 moneymona since 1 Apr
// 74%

// 23721 moneymona since 10 Apr
// 28282 total since 10 Apr
// 83%

// 20840 total since 13 Apr
// 18195 moneymona since 13 Apr
// 87%

// 12610 total since 15 Apr
// 11443 moneymona since 15 Apr
// 90.7%




