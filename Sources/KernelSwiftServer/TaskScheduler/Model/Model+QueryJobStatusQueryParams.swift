//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/10/2023.
//

import Foundation
import Vapor

extension KernelTaskScheduler.Model {
    public struct QueryJobStatusQueryParams: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        
        public let name: String
        public let id: String?
        
        public init(name: String, id: String? = nil) {
            self.name = name
            self.id = id
        }
    }
}
