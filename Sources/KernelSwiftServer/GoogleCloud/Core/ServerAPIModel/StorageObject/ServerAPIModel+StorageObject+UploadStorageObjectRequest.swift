//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/04/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelGoogleCloud.Core.ServerAPIModel.StorageObject {
    public struct UploadStorageObjectRequest: OpenAPIContent {
        public var name: String
        public var predefinedAcl: String?
        public var file: File
        
        public init(
            name: String,
            predefinedAcl: String? = nil,
            file: File
        ) {
            self.name = name
            self.predefinedAcl = predefinedAcl
            self.file = file
        }
    }
}
