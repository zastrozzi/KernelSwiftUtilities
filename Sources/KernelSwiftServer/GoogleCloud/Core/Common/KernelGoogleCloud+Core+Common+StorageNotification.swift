//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.StorageNotification
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct StorageNotification: OpenAPIContent {
        public var kind: String?
        public var id: String?
        public var selfLink: String?
        public var topic: String?
        public var eventTypes: [String]?
        public var customAttributes: [String: String]?
        public var payloadFormat: String?
        public var objectNamePrefix: String?
        public var etag: String?
        
        public init(
            kind: String? = nil,
            id: String? = nil,
            selfLink: String? = nil,
            topic: String? = nil,
            eventTypes: [String]? = nil,
            customAttributes: [String: String]? = nil,
            payloadFormat: String? = nil,
            objectNamePrefix: String? = nil,
            etag: String? = nil
        ) {
            self.kind = kind
            self.id = id
            self.selfLink = selfLink
            self.topic = topic
            self.eventTypes = eventTypes
            self.customAttributes = customAttributes
            self.payloadFormat = payloadFormat
            self.objectNamePrefix = objectNamePrefix
            self.etag = etag
        }
        
        public enum CodingKeys: String, CodingKey {
            case kind
            case id
            case selfLink
            case topic
            case eventTypes// = "event_types"
            case customAttributes// = "custom_attributes"
            case payloadFormat// = "payload_format"
            case objectNamePrefix// = "object_name_prefix"
            case etag
        }
    }
}

extension Storage.StorageNotification {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.StorageNotification {
        .init(
            kind: self.kind,
            id: self.id,
            selfLink: self.selfLink,
            topic: self.topic,
            eventTypes: self.eventTypes,
            customAttributes: self.customAttributes,
            payloadFormat: self.payloadFormat,
            objectNamePrefix: self.objectNamePrefix,
            etag: self.etag
        )
    }
}
