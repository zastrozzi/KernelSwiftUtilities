//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct EnduserPhoneResponse: OpenAPIContent {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var phoneNumberValue: String
        public var isWhatsapp: Bool
        public var isSMS: Bool
        public var isVoice: Bool
        public var isWhatsappVerified: Bool
        public var isSMSVerified: Bool
        public var isVoiceVerified: Bool
        public var preferredContactMethod: PhoneContactMethod
        public var enduserId: UUID
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            phoneNumberValue: String,
            isWhatsapp: Bool,
            isSMS: Bool,
            isVoice: Bool,
            isWhatsappVerified: Bool,
            isSMSVerified: Bool,
            isVoiceVerified: Bool,
            preferredContactMethod: PhoneContactMethod,
            enduserId: UUID
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.phoneNumberValue = phoneNumberValue
            self.isWhatsapp = isWhatsapp
            self.isSMS = isSMS
            self.isVoice = isVoice
            self.isWhatsappVerified = isWhatsappVerified
            self.isSMSVerified = isSMSVerified
            self.isVoiceVerified = isVoiceVerified
            self.preferredContactMethod = preferredContactMethod
            self.enduserId = enduserId
        }
    }
}
