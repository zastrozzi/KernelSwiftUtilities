//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct RefreshAdminUserTokenRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public let refreshToken: String
        
        public init(
            refreshToken: String
        ) {
            self.refreshToken = refreshToken
        }
    }
}
