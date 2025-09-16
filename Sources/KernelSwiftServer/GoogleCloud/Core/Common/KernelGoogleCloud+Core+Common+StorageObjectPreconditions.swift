//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import struct Storage.StorageObjectPreconditions
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct StorageObjectPreconditions: OpenAPIContent {
        public var ifGenerationMatch: String?
        
        public init(
            ifGenerationMatch: String? = nil
        ) {
            self.ifGenerationMatch = ifGenerationMatch
        }
    }
}

extension Storage.StorageObjectPreconditions {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.StorageObjectPreconditions {
        .init(
            ifGenerationMatch: ifGenerationMatch
        )
    }
}
