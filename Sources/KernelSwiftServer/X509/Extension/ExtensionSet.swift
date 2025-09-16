//
//  File.swift
//
//
//  Created by Jonathan Forbes on 09/07/2023.
//

import Vapor

public protocol X509ExtensionTransformable: X509ExtensionBuildable, X509ExtensionDecodable {}

extension KernelX509 {
    public struct ExtensionSet: ASN1Decodable, Sendable {
        public static let extensionDecodingTypes: [KernelX509.Extension.ExtensionIdentifier: X509ExtensionTransformable.Type] = [
            .authorityInfoAccess: KernelX509.Extension.AuthorityInfoAccess.self,
            .authorityKeyIdentifier: KernelX509.Extension.AuthorityKeyIdentifier.self,
            .subjectAlternativeName: KernelX509.Extension.SubjectAlternativeName.self,
            .basicConstraints: KernelX509.Extension.BasicConstraints.self,
            .certificatePolicies: KernelX509.Extension.CertificatePolicies.self,
            .crlDistributionPoints: KernelX509.Extension.CRLDistributionPoints.self,
            .extKeyUsage: KernelX509.Extension.ExtendedKeyUsage.self,
            .keyUsage: KernelX509.Extension.KeyUsage.self,
            .subjectKeyIdentifier: KernelX509.Extension.SubjectKeyIdentifier.self,
            .nameConstraints: KernelX509.Extension.NameConstraints.self
        ]
        
        public var items: [Extension]
        
        public var extensionOrdinals: [Int: KernelX509.Extension.ExtensionIdentifier] {
            zip(items.indices, items).reduce(into: [:]) { partialResult, zipped in
                partialResult[zipped.0] = zipped.1.extId
            }
        }
        
        public var extensionOrdinalsReversed: [KernelX509.Extension.ExtensionIdentifier: Int] {
            extensionOrdinals.reduce(into: [:]) { $0[$1.value] = $1.key }
        }
        
        public init(items: [Extension]) {
            self.items = items
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            if 
                case let .tagged(3, .constructed(asn1ConstructedTypes)) = asn1Type,
                case let .sequence(extSequenceItems) = asn1ConstructedTypes[0] 
            {
                self = .init(items: try extSequenceItems.map { try .init(from: $0) })
            }
            else { throw Self.decodingError(.sequence, asn1Type) }
        }
        
        public func decodeExtension<E: X509ExtensionDecodable>(_ type: E.Type) throws -> E {
            let found = items.filter { $0.extId == type.extIdentifier }
            guard found.count == 1 else { throw E.extensionDecodingFailed() }
            return try type.init(from: found[0])
        }
        
        public func decodedExtensions() throws -> KernelASN1.ASN1Type {
            var seqItems: [KernelASN1.ASN1Type] = []
            try items.forEach {
                if let decodingType = Self.extensionDecodingTypes[$0.extId] {
                    let decoded = try decodingType.init(from: $0)
                    let decodedData = try decoded.buildNonSerialisedExtension()
                    seqItems.append(decodedData)
                }
                else {
                    seqItems.append($0.buildASN1Type())
                }
            }
            return .tagged(3, .explicit(.sequence(seqItems)))
        }
    }
}

extension KernelX509.ExtensionSet: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        return .tagged(3, .explicit(.sequence(items.map { $0.buildASN1Type() })))
    }
}
