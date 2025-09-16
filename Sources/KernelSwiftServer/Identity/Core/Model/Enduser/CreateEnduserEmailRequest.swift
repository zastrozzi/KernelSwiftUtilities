//
//  File.swift
//
//
//  Created by Jonathan Forbes on 31/05/2022.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct CreateEnduserEmailRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var emailAddressValue: String
        public var isVerified: Bool
        
        public init(
            emailAddressValue: String,
            isVerified: Bool
        ) {
            self.emailAddressValue = emailAddressValue
            self.isVerified = isVerified
        }
        
    }
}
