//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import struct Storage.StorageRewriteObject
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct StorageRewriteObject: OpenAPIContent {
        public var kind: String?
        public var totalBytesRewritten: String?
        public var objectSize: String?
        public var done: Bool?
        public var rewriteToken: String?
//        public var resource: GoogleCloudStorageObject?
        
        public init(
            kind: String? = nil,
            totalBytesRewritten: String? = nil,
            objectSize: String? = nil,
            done: Bool? = nil,
            rewriteToken: String? = nil
//            resource: GoogleCloudStorageObject? = nil
        ) {
            self.kind = kind
            self.totalBytesRewritten = totalBytesRewritten
            self.objectSize = objectSize
            self.done = done
            self.rewriteToken = rewriteToken
//            self.resource = resource
        }
    }
}

extension Storage.StorageRewriteObject {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.StorageRewriteObject {
        .init(
            kind: kind,
            totalBytesRewritten: totalBytesRewritten,
            objectSize: objectSize,
            done: done,
            rewriteToken: rewriteToken
        )
    }
}
