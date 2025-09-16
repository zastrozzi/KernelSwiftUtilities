//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.Versioning
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct Versioning: OpenAPIContent {
        public var enabled: Bool?
        
        public init(
            enabled: Bool? = nil
        ) {
            self.enabled = enabled
        }
    }
}

extension Storage.Versioning {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.Versioning {
        .init(
            enabled: self.enabled
        )
    }
}
