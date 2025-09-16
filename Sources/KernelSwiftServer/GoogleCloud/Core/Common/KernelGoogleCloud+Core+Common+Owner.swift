//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.Owner
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct Owner: OpenAPIContent {
        public var entity: String?
        public var entityId: String?
        
        public init(
            entity: String? = nil,
            entityId: String? = nil
        ) {
            self.entity = entity
            self.entityId = entityId
        }
    }
}

extension Storage.Owner {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.Owner {
        .init(
            entity: self.entity,
            entityId: self.entityId
        )
    }
}
