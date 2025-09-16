//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.RetentionPolicy
import KernelSwiftCommon
import Foundation

extension KernelGoogleCloud.Core.Common {
    public struct RetentionPolicy: OpenAPIContent {
        public var effectiveTime: Date?
        public var isLocked: Bool?
        public var retentionPeriod: Int?
        
        public init(
            effectiveTime: Date? = nil,
            isLocked: Bool? = nil,
            retentionPeriod: Int? = nil
        ) {
            self.effectiveTime = effectiveTime
            self.isLocked = isLocked
            self.retentionPeriod = retentionPeriod
        }
    }
}

extension Storage.RetentionPolicy {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.RetentionPolicy {
        .init(
            effectiveTime: self.effectiveTime,
            isLocked: self.isLocked,
            retentionPeriod: self.retentionPeriod
        )
    }
}
