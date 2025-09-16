//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelGoogleCloud.Core.ServerAPIModel.StorageBucket {
    public struct CreateStorageBucketRequest: OpenAPIContent {
        public var name: String
        public var location: String?
        
        public init(
            name: String,
            location: String? = nil
        ) {
            self.name = name
            self.location = location
        }
    }
}
