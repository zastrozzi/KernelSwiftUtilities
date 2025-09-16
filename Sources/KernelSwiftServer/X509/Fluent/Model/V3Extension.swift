//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//

import Vapor
import Fluent

extension KernelX509.Fluent.Model {
    public final class V3Extension: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.v3Extension
        //        public var auditDate: Date? = nil
        //        public var auditCreatedAt: Date? { self.dbCreatedAt }
        
        @ID(key: .id) public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @KernelEnum(key: "eid") public var extensionIdentifier: KernelX509.Extension.ExtensionIdentifier
        @Field(key: "critical") public var critical: Bool
// DEPRECATED COMPOSITE EXTENSION SYSTEM AS IT WAS ONLY CREATED DUE TO A MISTAKE IN THE PARSER
//        @Field(key: "is_composite") public var isComposite: Bool
        @Field(key: "ext_value") public var extValue: Data
        
        @OptionalParent(key: "csr_info_id") public var csrInfo: CSRInfo?
        
        public init() {}
        
        public enum CodingKeys: CodingKey, CaseIterable, Hashable {
            case id
            case dbCreatedAt
            case dbUpdatedAt
            case dbDeletedAt
            case extensionIdentifier
            case critical
//            case isComposite
            case extValue
        }
    }
}
