//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.Condition
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct Condition: OpenAPIContent {
        public var age: Int?
        public var createdBefore: String?
        public var isLive: Bool?
        public var matchesStorageClass: [String]?
        public var numNewerVersions: Int?
        
        public init(
            age: Int? = nil,
            createdBefore: String? = nil,
            isLive: Bool? = nil,
            matchesStorageClass: [String]? = nil,
            numNewerVersions: Int? = nil
        ) {
            self.age = age
            self.createdBefore = createdBefore
            self.isLive = isLive
            self.matchesStorageClass = matchesStorageClass
            self.numNewerVersions = numNewerVersions
        }
    }
}

extension Storage.Condition {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.Condition {
        .init(
            age: age,
            createdBefore: createdBefore,
            isLive: isLive,
            matchesStorageClass: matchesStorageClass,
            numNewerVersions: numNewerVersions
        )
    }
}
