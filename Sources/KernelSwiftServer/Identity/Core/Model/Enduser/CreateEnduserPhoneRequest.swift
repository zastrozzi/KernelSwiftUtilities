//
//  File.swift
//
//
//  Created by Jonathan Forbes on 31/05/2022.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct CreateEnduserPhoneRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var phoneNumberValue: String
        public var isWhatsapp: Bool
        public var isSMS: Bool
        public var isVoice: Bool
        public var isWhatsappVerified: Bool
        public var isSMSVerified: Bool
        public var isVoiceVerified: Bool
        public var preferredContactMethod: PhoneContactMethod
        
        public init(
            phoneNumberValue: String,
            isWhatsapp: Bool,
            isSMS: Bool,
            isVoice: Bool,
            isWhatsappVerified: Bool,
            isSMSVerified: Bool,
            isVoiceVerified: Bool,
            preferredContactMethod: PhoneContactMethod
        ) {
            self.phoneNumberValue = phoneNumberValue
            self.isWhatsapp = isWhatsapp
            self.isSMS = isSMS
            self.isVoice = isVoice
            self.isWhatsappVerified = isWhatsappVerified
            self.isSMSVerified = isSMSVerified
            self.isVoiceVerified = isVoiceVerified
            self.preferredContactMethod = preferredContactMethod
        }
    }
}

