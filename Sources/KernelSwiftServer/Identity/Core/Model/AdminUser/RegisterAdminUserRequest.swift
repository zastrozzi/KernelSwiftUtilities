//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct RegisterAdminUserRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public init(
            username: String,
            firstName: String,
            lastName: String,
            role: String,
            password: String
        ) {
            self.username = username
            self.firstName = firstName
            self.lastName = lastName
            self.role = role
            self.password = password
        }
        
        public let username: String
        public let firstName: String
        public let lastName: String
        public let role: String
        public let password: String
    }
}
