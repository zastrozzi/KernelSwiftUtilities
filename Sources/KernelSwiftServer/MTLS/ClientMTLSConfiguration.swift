//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/11/2022.
//

import Foundation
import KernelSwiftCommon

public struct ClientMTLSConfiguration: Codable, Equatable, Hashable {
    public var softwareStatementId: String
    public var tlsCertificateVerification: TLSCertificateVerification
    public var tlsRenegotiationSupport: TLSRenegotiationSupport
    
    public init(
        softwareStatementId: String,
        tlsCertificateVerification: TLSCertificateVerification = .fullVerification,
        tlsRenegotiationSupport: TLSRenegotiationSupport = .none
    ) {
        self.softwareStatementId = softwareStatementId
        self.tlsCertificateVerification = tlsCertificateVerification
        self.tlsRenegotiationSupport = tlsRenegotiationSupport
    }
    
    public init(softwareStatementId: String, overrides: ClientMTLSConfigurationOverrides?) {
        self.init(softwareStatementId: softwareStatementId)
        self.override(overrides)
    }
    
    public mutating func override(_ overrides: ClientMTLSConfigurationOverrides?) {
        if let overrides {
            self.tlsCertificateVerification = overrides.tlsCertificateVerification ?? self.tlsCertificateVerification
            self.tlsRenegotiationSupport = overrides.tlsRenegotiationSupport ?? self.tlsRenegotiationSupport
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case softwareStatementId = "software_statement_id"
        case tlsCertificateVerification = "tls_certificate_verification"
        case tlsRenegotiationSupport = "tls_renegotiation_support"
    }
}



public struct ClientMTLSConfigurationOverrides: Codable, Equatable {
    public var tlsCertificateVerification: TLSCertificateVerification?
    public var tlsRenegotiationSupport: TLSRenegotiationSupport?
    
    public init(
        tlsCertificateVerification: TLSCertificateVerification? = nil,
        tlsRenegotiationSupport: TLSRenegotiationSupport? = nil
    ) {
        self.tlsCertificateVerification = tlsCertificateVerification
        self.tlsRenegotiationSupport = tlsRenegotiationSupport
    }
    
    public mutating func update(with newOverrides: ClientMTLSConfigurationOverrides) {
        self.tlsCertificateVerification = newOverrides.tlsCertificateVerification ?? self.tlsCertificateVerification
        self.tlsRenegotiationSupport = newOverrides.tlsRenegotiationSupport ?? self.tlsRenegotiationSupport
    }
    
    enum CodingKeys: String, CodingKey {
        case tlsCertificateVerification = "tls_certificate_verification"
        case tlsRenegotiationSupport = "tls_renegotiation_support"
    }
}

extension ClientMTLSConfigurationOverrides: KernelSwiftCommon.Sampleable, OpenAPIEncodableSampleable {
    public static var sample: ClientMTLSConfigurationOverrides {
        return .init(
            tlsCertificateVerification: TLSCertificateVerification.none,
            tlsRenegotiationSupport: TLSRenegotiationSupport.none
        )
    }
}
