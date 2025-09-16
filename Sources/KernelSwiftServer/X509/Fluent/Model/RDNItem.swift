//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//

import Vapor
import Fluent

extension KernelX509.Fluent.Model {
    public final class RDNItem: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.rdnItem
        //        public var auditDate: Date? = nil
        //        public var auditCreatedAt: Date? { self.dbCreatedAt }
        
        @ID(key: .id) public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @KernelEnum(key: "attribute_type") public var attributeType: KernelX509.Common.RelativeDistinguishedName.AttributeType
        @KernelEnum(key: "attribute_value_type") public var attributeValueType: KernelX509.Common.RelativeDistinguishedName.AttributeValueType
        @Field(key: "string_value") public var stringValue: String
        
        @OptionalParent(key: "csr_info_id") public var csrInfo: CSRInfo?
        
        public init() {}
        
        public enum CodingKeys: CodingKey, CaseIterable, Hashable {
            case id
            case dbCreatedAt
            case dbUpdatedAt
            case dbDeletedAt
            case attributeType
            case attributeValueType
            case stringValue
        }
    }
}
