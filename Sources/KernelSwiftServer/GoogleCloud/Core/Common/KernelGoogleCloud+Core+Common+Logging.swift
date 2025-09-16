//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.Logging
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct Logging: OpenAPIContent {
        public var logBucket: String?
        public var logObjectPrefix: String?
        
        public init(
            logBucket: String? = nil,
            logObjectPrefix: String? = nil
        ) {
            self.logBucket = logBucket
            self.logObjectPrefix = logObjectPrefix
        }
    }
}

extension Storage.Logging {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.Logging {
        .init(
            logBucket: self.logBucket,
            logObjectPrefix: self.logObjectPrefix
        )
    }
}
