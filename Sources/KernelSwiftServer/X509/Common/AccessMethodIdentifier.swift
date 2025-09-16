//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/07/2023.
//
import Vapor
import KernelSwiftCommon

extension KernelX509.Common {
    public enum AccessMethodIdentifier: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable {
        public static let fluentEnumName: String = "k_x509-amid"
        
        case ocspServer
        case issuingCA
        case unknown
    }
}

extension KernelX509.Common.AccessMethodIdentifier: KernelASN1.ASN1ObjectIDTransformable {
    public static var asn1ObjectIdTransformations: [(KernelX509.Common.AccessMethodIdentifier, KernelSwiftCommon.ObjectID)] {[
        (.ocspServer, .pkixOCSP),
        (.issuingCA, .pkixAccessMethodIssuingCA)
    ]}
}
