//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct LoginAdminUserEmailPasswordRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public let email: String
        public let password: String
        
        public init(
            email: String,
            password: String
        ) {
            self.email = email
            self.password = password
        }
    }
}

extension KernelIdentity.Core.Model.LoginAdminUserEmailPasswordRequest {
    public static var sample: KernelIdentity.Core.Model.LoginAdminUserEmailPasswordRequest {
        .init(email: "jono.forbes@uibuk.com", password: "ExamplePassword123!")
    }
}
