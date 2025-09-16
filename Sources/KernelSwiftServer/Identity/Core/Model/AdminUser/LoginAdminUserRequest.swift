//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct LoginAdminUserRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public let username: String
        public let password: String
        public let deviceIdentifier: String
        
        public init(
            username: String,
            password: String,
            deviceIdentifier: String
        ) {
            self.username = username
            self.password = password
            self.deviceIdentifier = deviceIdentifier
        }
    }
}
