//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/12/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelX509.Fluent.Model {
    public final class DistinguishedName: Fields, @unchecked Sendable {
        @OptionalASN1Field(key: "asn1") public var asn1: KernelX509.Common.DistinguishedName?
        @OptionalField(key: "cn") public var commonName: String?
        @OptionalField(key: "c") public var countryName: String?
        @OptionalField(key: "l") public var localityName: String?
        @OptionalField(key: "st") public var stateOrProvinceName: String?
        @OptionalField(key: "oi") public var organizationIdentifier: String?
        @OptionalField(key: "o") public var organizationName: String?
        @OptionalField(key: "ou") public var organizationalUnitName: String?
        @OptionalField(key: "street") public var streetAddress: String?
        @OptionalField(key: "e") public var emailAddress: String?
        
        public init() {}
        
        public static func createFields(from dto: KernelX509.Common.DistinguishedName) -> Self {
            let fields: Self = .init()
            fields.asn1 = dto
            fields.commonName = dto.getAttributeString(for: .commonName)
            fields.countryName = dto.getAttributeString(for: .countryName)
            fields.localityName = dto.getAttributeString(for: .localityName)
            fields.stateOrProvinceName = dto.getAttributeString(for: .stateOrProvinceName)
            fields.organizationIdentifier = dto.getAttributeString(for: .organizationIdentifier)
            fields.organizationName = dto.getAttributeString(for: .organizationName)
            fields.organizationalUnitName = dto.getAttributeString(for: .organizationalUnitName)
            fields.streetAddress = dto.getAttributeString(for: .streetAddress)
            fields.emailAddress = dto.getAttributeString(for: .emailAddress)
            return fields
        }
    }
}
