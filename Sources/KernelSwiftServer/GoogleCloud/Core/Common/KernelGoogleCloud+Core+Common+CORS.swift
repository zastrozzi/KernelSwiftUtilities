//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.Cors
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct CORS: OpenAPIContent {
        public var origin: [String]?
        public var method: [String]?
        public var responseHeader: [String]?
        public var maxAgeSeconds: Int?
        
        public init(
            origin: [String]? = nil,
            method: [String]? = nil,
            responseHeader: [String]? = nil,
            maxAgeSeconds: Int? = nil
        ) {
            self.origin = origin
            self.method = method
            self.responseHeader = responseHeader
            self.maxAgeSeconds = maxAgeSeconds
        }
    }
}

extension Storage.Cors {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.CORS {
        .init(
            origin: self.origin,
            method: self.method,
            responseHeader: self.responseHeader,
            maxAgeSeconds: self.maxAgeSeconds
        )
    }
}
