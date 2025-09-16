//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/07/2023.
//

import Vapor

extension KernelX509.Policy {
    public enum QualifierInfo {
        case cps(String)
        case userNotice(UserNotice)
        case unknown([Int], KernelASN1.ASN1Type)
    }
}

extension KernelX509.Policy.QualifierInfo: ASN1Decodable, ASN1Buildable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .sequence(items) = asn1Type, items.count == 2 else { throw Self.decodingError(.sequence, asn1Type) }
        let identifier: KernelX509.Policy.QualifierIdentifier = try .init(from: items[0])
        switch identifier {
        case .cps:
            guard case let .ia5String(asn1IA5String) = items[1] else { throw Self.decodingError(.ia5String, items[1]) }
            self = .cps(asn1IA5String.string)
            return
        case .userNotice:
            self = .userNotice(try .init(from: items[1]))
            return
        case .unknown:
            let rawIdentifier: KernelASN1.ASN1ObjectIdentifier = try .init(from: items[0])
            self = .unknown(rawIdentifier.identifier, items[1])
            return
        }
    }
    
    public init(from decoder: Decoder) throws {
        fatalError()
    }
    
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        switch self {
        case let .cps(str): .sequence([
            KernelX509.Policy.QualifierIdentifier.cps.buildASN1Type(),
            .ia5String(.init(string: str))
        ])
        case let .userNotice(userNotice): .sequence([
            KernelX509.Policy.QualifierIdentifier.userNotice.buildASN1Type(),
            userNotice.buildASN1Type()
        ])
        case let .unknown(rawId, rawType): .sequence([
            KernelASN1.ASN1ObjectIdentifier(identifier: rawId).buildASN1Type(),
            rawType
        ])
        }
//        switch self {
//        case let .ia5String(nativeString): .ia5String(.init(string: nativeString))
//        case let .visibleString(nativeString): .visibleString(.init(string: nativeString))
//        case let .bmpString(nativeString): .bmpString(.init(string: nativeString))
//        case let .utf8String(nativeString): .utf8String(.init(string: nativeString))
//        }
//        fatalError()
    }
}
