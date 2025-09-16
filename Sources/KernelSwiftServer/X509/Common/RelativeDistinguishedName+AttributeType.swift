//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2023.
//
import KernelSwiftCommon

extension KernelX509.Common.RelativeDistinguishedName {
    public enum AttributeType: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable {
        public static let fluentEnumName: String = "k_x509-rdna_type"
        case commonName = "CN"
        case countryName = "C"
        case localityName = "L"
        case stateOrProvinceName = "ST"
        case organizationIdentifier = "OI"
        case organizationName = "O"
        case organizationalUnitName = "OU"
        case streetAddress = "STREET"
        case emailAddress = "E"
    }
    
    public enum AttributeValueType: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable {
        public static let fluentEnumName: String = "k_x509-rdnav_type"
        case utf8String
        case printableString
        case ia5String
    }
}

extension KernelX509.Common.RelativeDistinguishedName.AttributeType: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        switch self {
        case .commonName: return .objectIdentifier(.init(oid: .x501AttributeTypeCommonName))
        case .countryName: return .objectIdentifier(.init(oid: .x501AttributeTypeCountryName))
        case .localityName: return .objectIdentifier(.init(oid: .x501AttributeTypeLocalityName))
        case .stateOrProvinceName: return .objectIdentifier(.init(oid: .x501AttributeTypeStateOrProvinceName))
        case .organizationIdentifier: return .objectIdentifier(.init(oid: .x501AttributeTypeOrganizationIdentifier))
        case .organizationName: return .objectIdentifier(.init(oid: .x501AttributeTypeOrganizationName))
        case .organizationalUnitName: return .objectIdentifier(.init(oid: .x501AttributeTypeOrganizationalUnitName))
        case .streetAddress: return .objectIdentifier(.init(oid: .x501AttributeTypeStreetAddress))
        case .emailAddress: return .objectIdentifier(.init(oid: .pkcs9EmailAddress))
        }
    }
}

extension KernelX509.Common.RelativeDistinguishedName.AttributeType: ASN1Decodable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .objectIdentifier(objectId) = asn1Type else { throw Self.decodingError(.objectIdentifier, asn1Type) }
        let found: Self? = switch objectId.oid {
        case .x501AttributeTypeCommonName: .commonName
        case .x501AttributeTypeCountryName: .countryName
        case .x501AttributeTypeLocalityName: .localityName
        case .x501AttributeTypeStateOrProvinceName: .stateOrProvinceName
        case .x501AttributeTypeOrganizationIdentifier: .organizationIdentifier
        case .x501AttributeTypeOrganizationName: .organizationName
        case .x501AttributeTypeOrganizationalUnitName: .organizationalUnitName
        case .x501AttributeTypeStreetAddress: .streetAddress
        case .pkcs9EmailAddress: .emailAddress
        default: nil
        }
        guard let found else { throw Self.decodingError(nil, asn1Type) }
        self = found
    }
}
