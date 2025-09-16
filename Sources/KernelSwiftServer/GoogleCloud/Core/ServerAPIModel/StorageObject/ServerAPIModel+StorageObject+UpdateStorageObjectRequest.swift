//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/04/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelGoogleCloud.Core.ServerAPIModel.StorageObject {
    public struct UpdateStorageObjectRequest: OpenAPIContent {
        public var name: String?
        public var predefinedAcl: String?
        
        public init(
            name: String? = nil,
            predefinedAcl: String? = nil
        ) {
            self.name = name
            self.predefinedAcl = predefinedAcl
        }
    }
}
