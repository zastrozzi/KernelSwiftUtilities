//
//  File.swift
//
//
//  Created by Jonathan Forbes on 31/05/2022.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct UpdateEnduserEmailRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var emailAddressValue: String? = nil
        public var isVerified: Bool? = nil
        public var enduserId: UUID? = nil
        
        
        public init(
            emailAddressValue: String? = nil,
            isVerified: Bool? = nil,
            enduserId: UUID? = nil
        ) {
            self.emailAddressValue = emailAddressValue
            self.isVerified = isVerified
            self.enduserId = enduserId
        }
        
    }
}
