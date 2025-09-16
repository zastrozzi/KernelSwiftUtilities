//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct UpdateEnduserCredentialRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var isValid: Bool
        
        public init(
            isValid: Bool
        ) {
            self.isValid = isValid
        }
    }
}
