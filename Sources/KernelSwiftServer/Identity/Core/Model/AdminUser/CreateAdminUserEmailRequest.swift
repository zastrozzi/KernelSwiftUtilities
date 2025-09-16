//
//  File.swift
//
//
//  Created by Jonathan Forbes on 31/05/2022.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct CreateAdminUserEmailRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var emailAddressValue: String
        public var isVerified: Bool
//        public var adminUserId: UUID
        
        public init(
            emailAddressValue: String,
            isVerified: Bool
//            adminUserId: UUID
        ) {
            self.emailAddressValue = emailAddressValue
            self.isVerified = isVerified
//            self.adminUserId = adminUserId
        }
        
    }
}
