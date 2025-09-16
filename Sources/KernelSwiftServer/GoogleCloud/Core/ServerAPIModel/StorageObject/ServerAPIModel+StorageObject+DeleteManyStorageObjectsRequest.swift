//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/04/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelGoogleCloud.Core.ServerAPIModel.StorageObject {
    public struct DeleteManyStorageObjectsRequest: OpenAPIContent {
        public var objectIds: [UUID]
        
        public init(
            objectIds: [UUID]
        ) {
            self.objectIds = objectIds
        }
    }
}
