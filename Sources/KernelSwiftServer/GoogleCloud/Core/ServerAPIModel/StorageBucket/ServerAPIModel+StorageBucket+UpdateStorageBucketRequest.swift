//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelGoogleCloud.Core.ServerAPIModel.StorageBucket {
    public struct UpdateStorageBucketRequest: OpenAPIContent {
        public var defaultEventBasedHold: Bool?
        
        public init(
            defaultEventBasedHold: Bool? = nil
        ) {
            self.defaultEventBasedHold = defaultEventBasedHold
        }
    }
}
