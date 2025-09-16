//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct UpdateAdminUserRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable, Sendable {
        public let firstName: String?
        public let lastName: String?
        public let role: String?
        
        public init(
            firstName: String? = nil,
            lastName: String? = nil,
            role: String? = nil
        ) {
            self.firstName = firstName
            self.lastName = lastName
            self.role = role
        }
        
    }
}
