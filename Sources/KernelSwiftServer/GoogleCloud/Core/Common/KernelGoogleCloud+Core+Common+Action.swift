//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.Action
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct Action: OpenAPIContent {
        public var type: String?
        public var storageClass: String?
        
        public init(
            type: String? = nil,
            storageClass: String? = nil
        ) {
            self.type = type
            self.storageClass = storageClass
        }
    }
}

extension Storage.Action {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.Action {
        .init(
            type: type,
            storageClass: storageClass
        )
    }
}
