//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.Lifecycle
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct Lifecycle: OpenAPIContent {
        public var rule: [Rule]?
        
        public init(
            rule: [Rule]? = nil
        ) {
            self.rule = rule
        }
    }
}

extension Storage.Lifecycle {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.Lifecycle {
        .init(
            rule: self.rule?.map { $0.toKernelGoogleCloud() }
        )
    }
}
