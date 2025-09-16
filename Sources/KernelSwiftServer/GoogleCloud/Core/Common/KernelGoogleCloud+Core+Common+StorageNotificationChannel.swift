//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import struct Storage.StorageNotificationChannel
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct StorageNotificationChannel: OpenAPIContent {
        public var kind: String?
        public var id: String?
        public var resourceId: String?
        public var resourceUri: String?
        public var token: String?
        public var expiration: String?
        public var type: String?
        public var address: String?
        public var params: [String: String]?
        public var payload: Bool?
        
        public init(
            kind: String? = nil,
            id: String? = nil,
            resourceId: String? = nil,
            resourceUri: String? = nil,
            token: String? = nil,
            expiration: String? = nil,
            type: String? = nil,
            address: String? = nil,
            params: [String: String]? = nil,
            payload: Bool? = nil
        ) {
            self.kind = kind
            self.id = id
            self.resourceId = resourceId
            self.resourceUri = resourceUri
            self.token = token
            self.expiration = expiration
            self.type = type
            self.address = address
            self.params = params
            self.payload = payload
        }
    }
}

extension Storage.StorageNotificationChannel {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.StorageNotificationChannel {
        .init(
            kind: kind,
            id: id,
            resourceId: resourceId,
            resourceUri: resourceUri,
            token: token,
            expiration: expiration,
            type: type,
            address: address,
            params: params,
            payload: payload
        )
    }
}
