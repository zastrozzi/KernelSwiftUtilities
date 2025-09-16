//
//  File.swift
//
//
//  Created by Jonathan Forbes on 25/05/2022.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelIdentity.Fluent.Model {
    public final class EnduserAction: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.enduserAction
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        @KernelEnum(key: "type") public var type: KernelIdentity.Core.Model.LoggableEnduserActionType
        @Field(key: "props") public var props: [String: String]?
        
        @Parent(key: "session_id") public var session: EnduserSession
        
        public init() {}
    }
    
}
