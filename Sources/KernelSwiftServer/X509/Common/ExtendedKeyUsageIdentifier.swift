//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/06/2023.
//
import KernelSwiftCommon

extension KernelX509.Common {
    public enum ExtendedKeyUsageIdentifier: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable {
        public static let fluentEnumName: String = "k_x509-ekuid"
        case any
        case serverAuth
        case clientAuth
        case codeSigning
        case emailProtection
        case timeStamping
        case ocspSigning
        case certificateTransparency
        case documentSigning
        
        case unknown
    }
}

extension KernelX509.Common.ExtendedKeyUsageIdentifier: KernelASN1.ASN1ObjectIDTransformable {
    public static var asn1ObjectIdTransformations: [(KernelX509.Common.ExtendedKeyUsageIdentifier, KernelSwiftCommon.ObjectID)] {[
        (.any, .x501CertExtExtKeyUsageAny),
        (.serverAuth, .pkixServerAuth),
        (.clientAuth, .pkixClientAuth),
        (.codeSigning, .pkixCodeSigning),
        (.emailProtection, .pkixEmailProtection),
        (.timeStamping, .pkixTimeStamping),
        (.ocspSigning, .pkixOCSPSigning),
        (.certificateTransparency, .extKeyUsageCertificateTransparency),
        (.documentSigning, .extKeyUsageDocumentSigning)
    ]}
}
