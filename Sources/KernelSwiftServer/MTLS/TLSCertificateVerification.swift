//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/10/2022.
//

import Foundation
import NIOSSL

public enum TLSCertificateVerification: String, Codable, Equatable, CaseIterable {
    case none = "none"
    case noHostnameVerification = "noHostnameVerification"
    case fullVerification = "fullVerification"
    
    public var normalized: CertificateVerification {
        switch self {
        case .none: return .none
        case .noHostnameVerification: return .noHostnameVerification
        case .fullVerification: return .fullVerification
        }
    }
}

extension TLSCertificateVerification: OpenAPIStringEnumSampleable {}
