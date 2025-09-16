//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import Fluent
import KernelSwiftCommon
import SQLKit

extension KernelDynamicQuery.Fluent.Model {
    public final class BooleanFilter: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.booleanFilter
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Group(key: "col") public var column: ColumnIdentifiers
        @Boolean(key: "value") public var filterValue: Bool
        
        @Parent(key: "query_id") public var structuredQuery: StructuredQuery
        @OptionalParent(key: "group_id") public var parentGroup: FilterGroup?
        
        public init() {}
    }
}

extension KernelDynamicQuery.Fluent.Model.BooleanFilter: DynamicQueryFilterModel {
    public func getSQLBinaryExpression() throws -> SQLBinaryExpression {
        .init(
            left: column.sqlColumn(),
            op: try getSQLOperatorExpression(),
            right: try getSQLOperandExpression()
        )
    }
    
    public func getSQLOperatorExpression() throws -> SQLExpression {
        SQLBinaryOperator.equal
    }
    
    public func getSQLOperandExpression() throws -> SQLExpression {
        SQLLiteral.boolean(filterValue)
    }
}

extension KernelDynamicQuery.Fluent.Model.BooleanFilter: CRUDModel {
    public typealias CreateDTO = KernelDynamicQuery.Core.APIModel.BooleanFilter.CreateBooleanFilterRequest
    public typealias UpdateDTO = KernelDynamicQuery.Core.APIModel.BooleanFilter.UpdateBooleanFilterRequest
    public typealias ResponseDTO = KernelDynamicQuery.Core.APIModel.BooleanFilter.BooleanFilterResponse
    
    public struct CreateOptions: Sendable {
        public var queryId: UUID?
        public var parentId: UUID?
        
        public init(queryId: UUID? = nil, parentId: UUID? = nil) {
            self.queryId = queryId
            self.parentId = parentId
        }
    }
    
    public static func createFields(
        onDB db: @escaping DBAccessor,
        from dto: CreateDTO,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor?,
        withOptions options: CreateOptions? = nil
    ) async throws -> Self {
        guard let options else { throw Abort(.badRequest, reason: "Missing required `options`") }
        guard !(options.parentId == nil && options.queryId == nil) else {
            throw Abort(.badRequest, reason: "Either `parentId` or `queryId` must be provided")
        }
        let model = self.init()
        model.column = try .createFields(from: dto.column)
        model.filterValue = dto.filterValue
        if let queryId = options.queryId {
            model.$structuredQuery.id = queryId
        }
        if let parentId = options.parentId {
            let parent = try await KernelDynamicQuery.Fluent.Model.FilterGroup.findOrThrow(parentId, on: db()) {
                Abort(.notFound, reason: "Parent not found")
            }
            model.$parentGroup.id = parentId
            model.$structuredQuery.id = parent.$structuredQuery.id
        }
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.$column, from: dto.column)
        try model.updateIfChanged(\.filterValue, from: dto.filterValue)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            column: try column.response(),
            filterValue: filterValue,
            structuredQueryId: $structuredQuery.id,
            parentGroupId: $parentGroup.id
        )
    }
}
    
