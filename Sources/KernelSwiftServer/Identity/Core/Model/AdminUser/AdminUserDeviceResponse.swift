//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct AdminUserDeviceResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var userAgent: String
        public var system: DeviceSystem
        public var osVersion: String?
        public var apnsPushToken: String?
        public var fcmPushToken: String?
        public var channels: String?
        public var localDeviceIdentifier: String?
        public var lastSeenAt: Date
        public var adminUserId: UUID
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            userAgent: String,
            system: DeviceSystem,
            osVersion: String? = nil,
            apnsPushToken: String? = nil,
            fcmPushToken: String? = nil,
            channels: String? = nil,
            localDeviceIdentifier: String? = nil,
            lastSeenAt: Date,
            adminUserId: UUID
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.userAgent = userAgent
            self.system = system
            self.osVersion = osVersion
            self.apnsPushToken = apnsPushToken
            self.fcmPushToken = fcmPushToken
            self.channels = channels
            self.localDeviceIdentifier = localDeviceIdentifier
            self.lastSeenAt = lastSeenAt
            self.adminUserId = adminUserId
        }
    }
}
