//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/05/2022.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct CreateAdminUserRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable, Sendable {
        public let firstName: String
        public let lastName: String
        public let role: String
        
        public init(
            firstName: String,
            lastName: String,
            role: String
        ) {
            self.firstName = firstName
            self.lastName = lastName
            self.role = role
        }
    }
}
