//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/06/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelFluentModel.Audit {
    public struct EventIdentifier: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public let schema: String?
        public let table: String?
        public let id: UUID?
        
        public init?(
            schema: String? = nil,
            table: String? = nil,
            id: UUID? = nil
        ) {
            guard table != nil || id != nil else { return nil }
            self.schema = schema
            self.table = table
            self.id = id
        }
        
        public init<Model: AuditableModel>(
            auditableModel: Model.Type = Model.self,
            id: UUID? = nil
        ) {
            self.schema = auditableModel.namespacedSchema.namespace
            self.table = auditableModel.namespacedSchema.table
            self.id = id
        }
    }
}
