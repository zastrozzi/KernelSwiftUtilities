//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//
import KernelSwiftCommon

extension KernelX509.Extension {
    public enum ExtensionIdentifier: ASN1Decodable, Codable, Equatable, Hashable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable {
        public static let fluentEnumName: String = "k_x509-eid"
        case keyAttributes
        case keyUsageRestriction
        case policyMapping
        case subtreesConstraint
        case subjectAltName
        case issuerAltName
        case subjectDirectoryAttributes
        case subjectKeyIdentifier
        case keyUsage
        case privateKeyUsagePeriod
        case subjectAlternativeName
        case issuerAlternativeName
        case basicConstraints
        case crlNumber
        case crlReason
        case expirationDate
        case instructionCode
        case invalidityDate
        case deltaCRLIndicator
        case issuingDistributionPoint
        case certificateIssuer
        case nameConstraints
        case crlDistributionPoints
        case certificatePolicies
        case policyMappings
        case authorityKeyIdentifier
        case policyConstraints
        case extKeyUsage
        case authorityInfoAccess
        case qcStatements
        case unknownExtension(rawIdentifier: [Int])
        
        public var rawValue: String {
            switch self {
            case .keyAttributes: "keyAttributes"
            case .keyUsageRestriction: "keyUsageRestriction"
            case .policyMapping: "policyMapping"
            case .subtreesConstraint: "subtreesConstraint"
            case .subjectAltName: "subjectAltName"
            case .issuerAltName: "issuerAltName"
            case .subjectDirectoryAttributes: "subjectDirectoryAttributes"
            case .subjectKeyIdentifier: "subjectKeyIdentifier"
            case .keyUsage: "keyUsage"
            case .privateKeyUsagePeriod: "privateKeyUsagePeriod"
            case .subjectAlternativeName: "subjectAlternativeName"
            case .issuerAlternativeName: "issuerAlternativeName"
            case .basicConstraints: "basicConstraints"
            case .crlNumber: "crlNumber"
            case .crlReason: "crlReason"
            case .expirationDate: "expirationDate"
            case .instructionCode: "instructionCode"
            case .invalidityDate: "invalidityDate"
            case .deltaCRLIndicator: "deltaCRLIndicator"
            case .issuingDistributionPoint: "issuingDistributionPoint"
            case .certificateIssuer: "certificateIssuer"
            case .nameConstraints: "nameConstraints"
            case .crlDistributionPoints: "crlDistributionPoints"
            case .certificatePolicies: "certificatePolicies"
            case .policyMappings: "policyMappings"
            case .authorityKeyIdentifier: "authorityKeyIdentifier"
            case .policyConstraints: "policyConstraints"
            case .extKeyUsage: "extKeyUsage"
            case .authorityInfoAccess: "authorityInfoAccess"
            case .qcStatements: "qcStatements"
            case let .unknownExtension(rawIdentifier): "unknown(\(rawIdentifier.map { String($0) }.joined(separator: ".")))"
            }
        }
        
        var asn1ObjectID: KernelSwiftCommon.ObjectID {
            switch self {
            case .keyAttributes: return .x501CertExtKeyAttributes
            case .keyUsageRestriction: return .x501CertExtKeyUsageRestriction
            case .policyMapping: return .x501CertExtPolicyMapping
            case .subtreesConstraint: return .x501CertExtSubtreesConstraint
            case .subjectAltName: return .x501CertExtSubjectAltName
            case .issuerAltName: return .x501CertExtIssuerAltName
            case .subjectDirectoryAttributes: return .x501CertExtSubjectDirectoryAttributes
            case .subjectKeyIdentifier: return .x501CertExtSubjectKeyIdentifier
            case .keyUsage: return .x501CertExtKeyUsage
            case .privateKeyUsagePeriod: return .x501CertExtPrivateKeyUsagePeriod
            case .subjectAlternativeName: return .x501CertExtSubjectAlternativeName
            case .issuerAlternativeName: return .x501CertExtIssuerAlternativeName
            case .basicConstraints: return .x501CertExtBasicConstraints
            case .crlNumber: return .x501CertExtCrlNumber
            case .crlReason: return .x501CertExtCrlReason
            case .expirationDate: return .x501CertExtExpirationDate
            case .instructionCode: return .x501CertExtInstructionCode
            case .invalidityDate: return .x501CertExtInvalidityDate
            case .deltaCRLIndicator: return .x501CertExtDeltaCRLIndicator
            case .issuingDistributionPoint: return .x501CertExtIssuingDistributionPoint
            case .certificateIssuer: return .x501CertExtCertificateIssuer
            case .nameConstraints: return .x501CertExtNameConstraints
            case .crlDistributionPoints: return .x501CertExtCrlDistributionPoints
            case .certificatePolicies: return .x501CertExtCertificatePolicies
            case .policyMappings: return .x501CertExtPolicyMappings
            case .authorityKeyIdentifier: return .x501CertExtAuthorityKeyIdentifier
            case .policyConstraints: return .x501CertExtPolicyConstraints
            case .extKeyUsage: return .x501CertExtExtKeyUsage
            case .authorityInfoAccess: return .pkixAuthorityInfoAccess
            case .qcStatements: return .pkixQcStatements
            case let .unknownExtension(rawIdentifier): return .unknownOID(rawIdentifier.map { String($0) }.joined(separator: "."))
            }
        }
    }
}

extension KernelX509.Extension.ExtensionIdentifier: CaseIterable {
    public static var allCases: [KernelX509.Extension.ExtensionIdentifier] {[
        .keyAttributes,
        .keyUsageRestriction,
        .policyMapping,
        .subtreesConstraint,
        .subjectAltName,
        .issuerAltName,
        .subjectDirectoryAttributes,
        .subjectKeyIdentifier,
        .keyUsage,
        .privateKeyUsagePeriod,
        .subjectAlternativeName,
        .issuerAlternativeName,
        .basicConstraints,
        .crlNumber,
        .crlReason,
        .expirationDate,
        .instructionCode,
        .invalidityDate,
        .deltaCRLIndicator,
        .issuingDistributionPoint,
        .certificateIssuer,
        .nameConstraints,
        .crlDistributionPoints,
        .certificatePolicies,
        .policyMappings,
        .authorityKeyIdentifier,
        .policyConstraints,
        .extKeyUsage,
        .authorityInfoAccess,
        .qcStatements
    ]}
}

extension KernelX509.Extension.ExtensionIdentifier: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        return .objectIdentifier(.init(oid: asn1ObjectID))
    }
}

extension KernelX509.Extension.ExtensionIdentifier {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
//        print("TRYING EXTENSION IDENTIFIER", asn1Type)
        guard case let .objectIdentifier(objectId) = asn1Type else { throw Self.decodingError(.objectIdentifier, asn1Type) }
        let found: Self = switch objectId.oid {
        case .x501CertExtKeyAttributes: .keyAttributes
        case .x501CertExtKeyUsageRestriction: .keyUsageRestriction
        case .x501CertExtPolicyMapping: .policyMapping
        case .x501CertExtSubtreesConstraint: .subtreesConstraint
        case .x501CertExtSubjectAltName: .subjectAltName
        case .x501CertExtIssuerAltName: .issuerAltName
        case .x501CertExtSubjectDirectoryAttributes: .subjectDirectoryAttributes
        case .x501CertExtSubjectKeyIdentifier: .subjectKeyIdentifier
        case .x501CertExtKeyUsage: .keyUsage
        case .x501CertExtPrivateKeyUsagePeriod: .privateKeyUsagePeriod
        case .x501CertExtSubjectAlternativeName: .subjectAlternativeName
        case .x501CertExtIssuerAlternativeName: .issuerAlternativeName
        case .x501CertExtBasicConstraints: .basicConstraints
        case .x501CertExtCrlNumber: .crlNumber
        case .x501CertExtCrlReason: .crlReason
        case .x501CertExtExpirationDate: .expirationDate
        case .x501CertExtInstructionCode: .instructionCode
        case .x501CertExtInvalidityDate: .invalidityDate
        case .x501CertExtDeltaCRLIndicator: .deltaCRLIndicator
        case .x501CertExtIssuingDistributionPoint: .issuingDistributionPoint
        case .x501CertExtCertificateIssuer: .certificateIssuer
        case .x501CertExtNameConstraints: .nameConstraints
        case .x501CertExtCrlDistributionPoints: .crlDistributionPoints
        case .x501CertExtCertificatePolicies: .certificatePolicies
        case .x501CertExtPolicyMappings: .policyMappings
        case .x501CertExtAuthorityKeyIdentifier: .authorityKeyIdentifier
        case .x501CertExtPolicyConstraints: .policyConstraints
        case .x501CertExtExtKeyUsage: .extKeyUsage
        case .pkixAuthorityInfoAccess: .authorityInfoAccess
        case .pkixQcStatements: .qcStatements
        default: .unknownExtension(rawIdentifier: objectId.oid?.identifier ?? [])
        }
//        guard let found else { throw Self.decodingError(nil, asn1Type) }
        self = found
    }
}
