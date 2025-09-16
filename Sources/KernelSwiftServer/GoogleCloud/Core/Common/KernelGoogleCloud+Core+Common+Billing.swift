//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.Billing
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct Billing: OpenAPIContent {
        public var requesterPays: Bool?
        
        public init(
            requesterPays: Bool? = nil
        ) {
            self.requesterPays = requesterPays
        }
    }
}

extension Storage.Billing {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.Billing {
        .init(
            requesterPays: requesterPays
        )
    }
}
