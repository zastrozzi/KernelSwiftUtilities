//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/08/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct RefreshEnduserTokenRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public let refreshToken: String
        
        public init(
            refreshToken: String
        ) {
            self.refreshToken = refreshToken
        }
    }
}
