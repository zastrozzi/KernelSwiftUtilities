//
//  File.swift
//
//
//  Created by Jonathan Forbes on 01/06/2022.
//

import Foundation
import OpenAPIKit30
import Vapor

extension HTTPHeaders.Name {
    public func openAPIHeaderParam() -> OpenAPI.Parameter {
        return .init(name: self.capitalized(), context: .header(required: true), schema: JSONSchema.string, description: description)
    }
    
    func capitalized() -> String {
        return self.description.capitalized
    }
}
