//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.Rule
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct Rule: OpenAPIContent {
        public var action: Action?
        public var condition: Condition?
        
        public init(
            action: Action? = nil,
            condition: Condition? = nil
        ) {
            self.action = action
            self.condition = condition
        }
    }
}

extension Storage.Rule {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.Rule {
        .init(
            action: action?.toKernelGoogleCloud(),
            condition: condition?.toKernelGoogleCloud()
        )
    }
}
