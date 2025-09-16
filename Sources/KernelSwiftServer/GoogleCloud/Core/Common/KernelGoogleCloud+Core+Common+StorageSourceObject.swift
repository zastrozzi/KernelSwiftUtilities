//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import struct Storage.StorageSourcObject
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct StorageSourceObject: OpenAPIContent {
        public var name: String?
        public var generation: String?
        public var objectPreconditions: StorageObjectPreconditions?
        
        public init(
            name: String? = nil,
            generation: String? = nil,
            objectPreconditions: StorageObjectPreconditions? = nil
        ) {
            self.name = name
            self.generation = generation
            self.objectPreconditions = objectPreconditions
        }
    }
}

extension Storage.StorageSourcObject {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.StorageSourceObject {
        .init(
            name: name,
            generation: generation,
            objectPreconditions: objectPreconditions?.toKernelGoogleCloud()
        )
    }
}
