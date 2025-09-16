//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/07/2023.
//

import Vapor

extension KernelX509.Common {
    public struct AuthorityInfoAccessDescription: ASN1Decodable, ASN1Buildable {
        public var method: KernelX509.Common.AccessMethodIdentifier
        public var location: GeneralName
        
        public init(
            method: KernelX509.Common.AccessMethodIdentifier,
            location: GeneralName
        ) {
            self.method = method
            self.location = location
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            guard case let .sequence(sequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
            
            self.method = try .init(from: sequenceItems[0])
            self.location = try .init(from: sequenceItems[1])
//            fatalError()
        }
        
        public func buildASN1Type() -> KernelASN1.ASN1Type {
            .sequence([
                method.buildASN1Type(),
                location.buildASN1Type()
            ])
//            fatalError()
        }
    }
}
