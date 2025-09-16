//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/12/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.Common {
    public enum KeyType: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable {
        public static let fluentEnumName: String = "k_crypto-key_type"
        
        case rsa
        case ec
    }
}
