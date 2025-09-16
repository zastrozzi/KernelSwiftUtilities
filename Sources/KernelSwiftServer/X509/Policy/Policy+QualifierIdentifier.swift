//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/07/2023.
//

import Vapor
import KernelSwiftCommon

extension KernelX509.Policy {
    public enum QualifierIdentifier: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable {
        public static let fluentEnumName: String = "k_x509-pkix_pqid"
        case cps
        case userNotice
        case unknown
    }
}

extension KernelX509.Policy.QualifierIdentifier: KernelASN1.ASN1ObjectIDTransformable {
    public static var asn1ObjectIdTransformations: [(KernelX509.Policy.QualifierIdentifier, KernelSwiftCommon.ObjectID)] {[
        (.cps, .pkixPolicyQualifierCPS),
        (.userNotice, .pkixPolicyQualifierUserNotice)
    ]}
}
