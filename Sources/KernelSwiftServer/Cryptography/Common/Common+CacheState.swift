//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.Common {
    public enum CacheState: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, OpenAPIStringEnumSampleable, Sendable {
        case disabled
        case paused
        case active
    }
}
