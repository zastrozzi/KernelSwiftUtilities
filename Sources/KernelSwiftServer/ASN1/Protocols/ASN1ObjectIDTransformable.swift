//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//
import Vapor
import KernelSwiftCommon

public protocol _KernelASN1ObjectIDTransformable: ASN1Decodable, ASN1Buildable, RawRepresentableAsString, Comparable {
    static var asn1ObjectIdTransformations: [(Self, KernelSwiftCommon.ObjectID)] { get }
    static func fallback(_ actual: [Int]) -> Self
    static var unknown: Self { get }
}

extension KernelASN1 {
    public typealias ASN1ObjectIDTransformable = _KernelASN1ObjectIDTransformable
}
extension KernelASN1.ASN1ObjectIDTransformable {
    
    
    public var asn1ObjectID: KernelSwiftCommon.ObjectID {
        guard let found = Self.asn1ObjectIdTransformations.first(where: { $0.0 == self })?.1 else { preconditionFailure("ASN1ObjectIDTransformable conforming types must include conversions for all defined cases") }
        return found
    }
    
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        return .objectIdentifier(.init(oid: asn1ObjectID))
    }
    
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .objectIdentifier(objectId) = asn1Type else { throw Self.decodingError(.objectIdentifier, asn1Type) }
        guard let oid = objectId.oid else {
            KernelASN1.logger.warning("Object Identifier \(objectId) is not known to this system.")
            self = .fallback(objectId.identifier)
            return
        }
        guard let found = Self.asn1ObjectIdTransformations.filter({ transformation in
            transformation.1 == oid
        }).first?.0 else {
            KernelASN1.logger.warning("Object Identifier \(objectId) is not known to this system.")
            self = .fallback(objectId.identifier)
            return
        }
        self = found
    }
    
    public static func fallback(_ actual: [Int]) -> Self {
        let cand: Self = .unknown
//        cand.rawUnknown = actual
        return cand
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.asn1ObjectID < rhs.asn1ObjectID }
}
