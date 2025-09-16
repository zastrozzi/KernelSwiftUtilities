//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 25/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.Common {
    public enum KeyGenStatus: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, OpenAPIStringEnumSampleable, Sendable {
        case busy
        case ready
        case error
    }
}
