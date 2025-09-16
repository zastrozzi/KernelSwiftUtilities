//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct AuthedUserResponse<UserData>: Codable, Equatable, Content, OpenAPIEncodableSampleable
        where UserData: Codable & Equatable & Content & OpenAPIEncodableSampleable
    {
        public var accessToken: String
        public var refreshToken: String
        public var userData: UserData
        
        public init(
            accessToken: String,
            refreshToken: String,
            userData: UserData
        ) {
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            self.userData = userData
        }
    }
}
