//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.Website
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct Website: OpenAPIContent {
        public var mainPageSuffix: String?
        public var notFoundPage: String?
        
        public init(
            mainPageSuffix: String? = nil,
            notFoundPage: String? = nil
        ) {
            self.mainPageSuffix = mainPageSuffix
            self.notFoundPage = notFoundPage
        }
    }
}

extension Storage.Website {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.Website {
        .init(
            mainPageSuffix: self.mainPageSuffix,
            notFoundPage: self.notFoundPage
        )
    }
}
