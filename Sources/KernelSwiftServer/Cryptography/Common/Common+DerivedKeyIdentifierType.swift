//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/12/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.Common {
    public enum DerivedKeyIdentifierType: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable {
        public static let fluentEnumName: String = "k_crypto-derived_kid_type"
        case jwks
        case skid
        // case rfc3280_160
        // case rfc3280_64
        case x509t
    }
}
