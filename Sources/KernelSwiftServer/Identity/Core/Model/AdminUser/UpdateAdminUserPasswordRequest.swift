//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct UpdateAdminUserPasswordRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var password: String
        
        public init(
            password: String
        ) {
            self.password = password
        }
    }
}
