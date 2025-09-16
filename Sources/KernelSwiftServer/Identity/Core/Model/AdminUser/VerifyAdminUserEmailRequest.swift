//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 01/06/2022.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct VerifyAdminUserEmailRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var emailAddressId: UUID
        
        public init(
            emailAddressId: UUID
        ) {
            self.emailAddressId = emailAddressId
        }
    }
}
