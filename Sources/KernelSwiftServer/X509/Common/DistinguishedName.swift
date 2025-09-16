//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/06/2023.
//

extension KernelX509.Common {
    public struct DistinguishedName: ASN1Decodable, Equatable, Sendable {
        public var rdns: [KernelX509.Common.RelativeDistinguishedName]
        
        public init(rdns: [KernelX509.Common.RelativeDistinguishedName]) {
            self.rdns = rdns
        }
        
        public init(from dbType: KernelX509.Fluent.Model.DistinguishedName) {
            if let asn1 = dbType.asn1 {
                self = asn1
                return
            } else {
                var newRDNS: [KernelX509.Common.RelativeDistinguishedName] = []
                if let commonName = dbType.commonName { newRDNS.append(.init(attributeType: .commonName, attributeValueType: .utf8String, stringValue: commonName)) }
                if let countryName = dbType.countryName { newRDNS.append(.init(attributeType: .countryName, attributeValueType: .utf8String, stringValue: countryName)) }
                if let localityName = dbType.localityName { newRDNS.append(.init(attributeType: .localityName, attributeValueType: .utf8String, stringValue: localityName)) }
                if let stateOrProvinceName = dbType.stateOrProvinceName { newRDNS.append(.init(attributeType: .stateOrProvinceName, attributeValueType: .utf8String, stringValue: stateOrProvinceName)) }
                if let organizationIdentifier = dbType.organizationIdentifier { newRDNS.append(.init(attributeType: .organizationIdentifier, attributeValueType: .utf8String, stringValue: organizationIdentifier)) }
                if let organizationName = dbType.organizationName { newRDNS.append(.init(attributeType: .organizationName, attributeValueType: .utf8String, stringValue: organizationName)) }
                if let organizationalUnitName = dbType.organizationalUnitName { newRDNS.append(.init(attributeType: .organizationalUnitName, attributeValueType: .utf8String, stringValue: organizationalUnitName)) }
                if let streetAddress = dbType.streetAddress { newRDNS.append(.init(attributeType: .streetAddress, attributeValueType: .utf8String, stringValue: streetAddress)) }
                if let emailAddress = dbType.emailAddress { newRDNS.append(.init(attributeType: .emailAddress, attributeValueType: .ia5String, stringValue: emailAddress)) }
                self.rdns = newRDNS
            }
        }
        
        //        public static var asn1DecodingSchema: DecodingSchema {[]}
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            if case let .any(asn1) = asn1Type {
                //            print(asn1.underlyingData?.toHexString() ?? "", "UNDERLYING")
                var bytes = asn1.underlyingData ?? [0]
                bytes[0] = .asn1.typeTag.sequence
//                let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(bytes)
//                KernelASN1.ASN1Printer.printObjectVerbose(parsed)
                guard case let .sequence(sequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
                self.rdns = try sequenceItems.map { try .init(from: $0) }
                return
            }
            guard case let .sequence(sequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
            self.rdns = try sequenceItems.map { try .init(from: $0) }
        }
        
        public init(from decoder: KernelASN1.ASN1Decoder) throws {
            try self.init(from: decoder.asn1Type)
        }
        
        public func getAttributeString(for attributeType: RelativeDistinguishedName.AttributeType) -> String? {
            rdns.first { $0.attributeType == attributeType }?.stringValue
        }
    }
}

extension KernelX509.Common.DistinguishedName: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        .sequence(rdns.map { $0.buildASN1Type() })
    }
}
