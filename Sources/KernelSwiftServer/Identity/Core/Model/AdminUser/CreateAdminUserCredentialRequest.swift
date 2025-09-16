//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct CreateAdminUserCredentialRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var credentialType: CredentialType
        public var oidcUserIdentifier: String?
        public var password: String?
        
        public init(
            credentialType: CredentialType,
            oidcUserIdentifier: String? = nil,
            password: String? = nil
        ) {
            self.credentialType = credentialType
            self.oidcUserIdentifier = oidcUserIdentifier
            self.password = password
        }
    }
}
