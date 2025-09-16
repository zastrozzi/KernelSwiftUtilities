//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 02/10/2023.
//

import Foundation

extension KernelNumerics.EC {
    public enum Curve {
        case oid(KernelSwiftCommon.ObjectID)
    }
}

extension KernelNumerics.EC.Curve {
    public static let knownCurveOIDs: [KernelSwiftCommon.ObjectID] = [
        .frp256v1,
        .x962Prime192v1,
        .x962Prime192v2,
        .x962Prime192v3,
        .x962Prime239v1,
        .x962Prime239v2,
        .x962Prime239v3,
        .x962Prime256v1,
        .brainpoolP160r1,
        .brainpoolP160t1,
        .brainpoolP192r1,
        .brainpoolP192t1,
        .brainpoolP224r1,
        .brainpoolP224t1,
        .brainpoolP256r1,
        .brainpoolP256t1,
        .brainpoolP320r1,
        .brainpoolP320t1,
        .brainpoolP384r1,
        .brainpoolP384t1,
        .brainpoolP512r1,
        .brainpoolP512t1,
        .secp112r1,
        .secp112r2,
        .ansip160r1,
        .ansip160k1,
        .ansip256k1,
        .secp128r1,
        .secp128r2,
        .ansip160r2,
        .ansip192k1,
        .ansip224k1,
        .ansip224r1,
        .ansip384r1,
        .ansip521r1
//        .unknownOID("bn158")
    ]
}

extension KernelNumerics.EC.Curve: Codable, Equatable, Sendable, Hashable {}

extension KernelNumerics.EC.Curve: RawRepresentableAsString {
    public var rawValue: String { asObjectId.rawValue }
    
    public var asObjectId: KernelSwiftCommon.ObjectID {
        guard case let .oid(oid) = self else { return .unknownOID("") }
        return oid
    }
    
    public static let allCases: [Self] = knownCurveOIDs.map { .oid($0) }
}

extension KernelNumerics.EC.Curve: Comparable {
    public static func < (lhs: KernelNumerics.EC.Curve, rhs: KernelNumerics.EC.Curve) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}


extension KernelNumerics.EC.Domain {
    public typealias curve = KernelNumerics.EC.Curve
    
    public init(fromOID oid: KernelSwiftCommon.ObjectID) throws {
        switch oid {
        case .frp256v1              : self = .curve.anssi.frp256v1
        case .x962Prime192v1            : self = .curve.x962.prime192v1
        case .x962Prime192v2            : self = .curve.x962.prime192v2
        case .x962Prime192v3            : self = .curve.x962.prime192v3
        case .x962Prime239v1            : self = .curve.x962.prime239v1
        case .x962Prime239v2            : self = .curve.x962.prime239v2
        case .x962Prime239v3            : self = .curve.x962.prime239v3
        case .x962Prime256v1            : self = .curve.x962.prime256v1
        case .brainpoolP160r1       : self = .curve.brainpool.brainpoolP160r1
        case .brainpoolP160t1       : self = .curve.brainpool.brainpoolP160t1
        case .brainpoolP192r1       : self = .curve.brainpool.brainpoolP192r1
        case .brainpoolP192t1       : self = .curve.brainpool.brainpoolP192t1
        case .brainpoolP224r1       : self = .curve.brainpool.brainpoolP224r1
        case .brainpoolP224t1       : self = .curve.brainpool.brainpoolP224t1
        case .brainpoolP256r1       : self = .curve.brainpool.brainpoolP256r1
        case .brainpoolP256t1       : self = .curve.brainpool.brainpoolP256t1
        case .brainpoolP320r1       : self = .curve.brainpool.brainpoolP320r1
        case .brainpoolP320t1       : self = .curve.brainpool.brainpoolP320t1
        case .brainpoolP384r1       : self = .curve.brainpool.brainpoolP384r1
        case .brainpoolP384t1       : self = .curve.brainpool.brainpoolP384t1
        case .brainpoolP512r1       : self = .curve.brainpool.brainpoolP512r1
        case .brainpoolP512t1       : self = .curve.brainpool.brainpoolP512t1
        case .secp112r1             : self = .curve.secg.secp112r1
        case .secp112r2             : self = .curve.secg.secp112r2
        case .ansip160r1            : self = .curve.x963.ansip160r1
        case .ansip160k1            : self = .curve.x963.ansip160k1
        case .ansip256k1            : self = .curve.x963.ansip256k1
        case .secp128r1             : self = .curve.secg.secp128r1
        case .secp128r2             : self = .curve.secg.secp128r2
        case .ansip160r2            : self = .curve.x963.ansip160r2
        case .ansip192k1            : self = .curve.x963.ansip192k1
        case .ansip224k1            : self = .curve.x963.ansip224k1
        case .ansip224r1            : self = .curve.x963.ansip224r1
        case .ansip384r1            : self = .curve.x963.ansip384r1
        case .ansip521r1            : self = .curve.x963.ansip521r1
        case .unknownOID("bn158")   : self = .curve.bn.bn158
        default: throw KernelNumerics.TypedError(.unknownECDomain)
        }
    }
    
    
}
