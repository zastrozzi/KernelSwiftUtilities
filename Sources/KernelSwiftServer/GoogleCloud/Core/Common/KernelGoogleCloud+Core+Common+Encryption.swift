//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.Encryption
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct Encryption: OpenAPIContent {
        public var defaultKmsKeyName: String?
        
        public init(
            defaultKmsKeyName: String? = nil
        ) {
            self.defaultKmsKeyName = defaultKmsKeyName
        }
    }
}

extension Storage.Encryption {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.Encryption {
        .init(
            defaultKmsKeyName: self.defaultKmsKeyName
        )
    }
}
