//
//  File.swift
//
//
//  Created by Jonathan Forbes on 31/05/2022.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct UpdateAdminUserEmailRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var emailAddressValue: String? = nil
        public var isVerified: Bool? = nil
        public var adminUserId: UUID? = nil
        
        
        public init(
            emailAddressValue: String? = nil,
            isVerified: Bool? = nil,
            adminUserId: UUID? = nil
        ) {
            self.emailAddressValue = emailAddressValue
            self.isVerified = isVerified
            self.adminUserId = adminUserId
        }
        
    }
}
