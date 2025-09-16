//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/04/2023.
//

import Foundation
import KernelSwiftCommon

public enum JWKEllipticCurveAlgorithm: RawRepresentableAsString, Codable, Equatable, CaseIterable, Hashable, Sendable {
    case p256
    case p384
    case p521
    case secp256k1
    case ed25519
    case ed448
    case x25519
    case x448
    case custom(String)
    
    public var rawValue: String {
        switch self {
        case .p256: "P-256"
        case .p384: "P-384"
        case .p521: "P-521"
        case .secp256k1: "secp256k1"
        case .ed25519: "Ed25519"
        case .ed448: "Ed448"
        case .x25519: "X25519"
        case .x448: "X448"
        case let .custom(str): str
        }
    }
    
    nonisolated(unsafe) public static var allCases: [JWKEllipticCurveAlgorithm] = {
        var set: Set<JWKEllipticCurveAlgorithm> = [
            .p256,
            .p384,
            .p521,
            .secp256k1,
            .ed25519,
            .ed448,
            .x25519,
            .x448
        ]
        return .init(set.union(KernelNumerics.EC.Curve.knownCurveOIDs.compactMap { .init(from: $0) }))
    }()
}

extension JWKEllipticCurveAlgorithm {
    public init?(from oid: KernelSwiftCommon.ObjectID) {
        switch oid {
        case .ansip256k1: self = .p256
        case .ansip384r1: self = .p384
        case .ansip521r1: self = .p521
        case .frp256v1: self = .custom("frp256v1")
        case .x962Prime192v1: self = .custom("prime192v1")
        case .x962Prime192v2: self = .custom("prime192v2")
        case .x962Prime192v3: self = .custom("prime192v3")
        case .x962Prime239v1: self = .custom("prime239v1")
        case .x962Prime239v2: self = .custom("prime239v2")
        case .x962Prime239v3: self = .custom("prime239v3")
        case .x962Prime256v1: self = .custom("prime256v1")
        case .brainpoolP160r1: self = .custom("brainpoolP160r1")
        case .brainpoolP160t1: self = .custom("brainpoolP160t1")
        case .brainpoolP192r1: self = .custom("brainpoolP192r1")
        case .brainpoolP192t1: self = .custom("brainpoolP192t1")
        case .brainpoolP224r1: self = .custom("brainpoolP224r1")
        case .brainpoolP224t1: self = .custom("brainpoolP224t1")
        case .brainpoolP256r1: self = .custom("brainpoolP256r1")
        case .brainpoolP256t1: self = .custom("brainpoolP256t1")
        case .brainpoolP320r1: self = .custom("brainpoolP320r1")
        case .brainpoolP320t1: self = .custom("brainpoolP320t1")
        case .brainpoolP384r1: self = .custom("brainpoolP384r1")
        case .brainpoolP384t1: self = .custom("brainpoolP384t1")
        case .brainpoolP512r1: self = .custom("brainpoolP512r1")
        case .brainpoolP512t1: self = .custom("brainpoolP512t1")
        case .secp112r1: self = .custom("secp112r1")
        case .secp112r2: self = .custom("secp112r2")
        case .ansip160r1: self = .custom("ansip160r1")
        case .ansip160k1: self = .custom("ansip160k1")
//        case .ansip256k1: self = .custom("ansip256k1")
        case .secp128r1: self = .custom("secp128r1")
        case .secp128r2: self = .custom("secp128r2")
        case .ansip160r2: self = .custom("ansip160r2")
        case .ansip192k1: self = .custom("ansip192k1")
        case .ansip224k1: self = .custom("ansip224k1")
        case .ansip224r1: self = .custom("ansip224r1")
        default: return nil
//        case .ansip384r1: self = .custom("ansip384r1")
//        case .ansip521r1: self = .custom("ansip521r1")
        }
    }
}
