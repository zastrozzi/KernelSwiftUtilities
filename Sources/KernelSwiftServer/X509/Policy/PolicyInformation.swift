//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/07/2023.
//

extension KernelX509.Policy {
    public struct Information: ASN1Decodable {
        public var policyIdentifier: KernelASN1.ASN1ObjectIdentifier
        public var policyQualifiers: [QualifierInfo]?
        
        public init(
            policyIdentifier: KernelASN1.ASN1ObjectIdentifier,
            policyQualifiers: [QualifierInfo]? = nil
        ) {
            self.policyIdentifier = policyIdentifier
            self.policyQualifiers = policyQualifiers
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            guard case let .sequence(items) = asn1Type, !items.isEmpty else { throw Self.decodingError(.sequence, asn1Type) }
            self.policyIdentifier = try .init(from: items[0])
            guard items.count > 0 else { self.policyQualifiers = nil; return }
            guard case let .sequence(items1) = items[1] else { throw Self.decodingError(.sequence, items[1]) }
            self.policyQualifiers = try items1.map { try .init(from: $0) }
        }
    }
}

extension KernelX509.Policy.Information: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        if let policyQualifiers {
            .sequence([
                policyIdentifier.buildASN1Type(),
                .sequence(policyQualifiers.map { $0.buildASN1Type() })
            ])
        } else {
            .sequence([
                policyIdentifier.buildASN1Type()
            ])
        }
    }
}
