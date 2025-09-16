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
    public final class StringFilter: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.stringFilter
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Group(key: "col") public var column: ColumnIdentifiers
        @Boolean(key: "field_array") public var fieldIsArray: Bool
        @KernelEnum(key: "method") public var filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod
        @OptionalField(key: "value") public var filterValue: String?
        @OptionalField(key: "array_value") public var filterArrayValue: [String]?
        
        @Parent(key: "query_id") public var structuredQuery: StructuredQuery
        @OptionalParent(key: "group_id") public var parentGroup: FilterGroup?
        
        public init() {}
    }
}

extension KernelDynamicQuery.Fluent.Model.StringFilter: DynamicQueryFilterModel {
    public func filterValueIsArray() throws -> Bool {
        guard !(filterValue == nil && filterArrayValue == nil) else { throw KernelDynamicQuery.TypedError(.missingFilterValue) }
        guard !(filterValue != nil && filterArrayValue != nil) else { throw KernelDynamicQuery.TypedError(.multipleFilterValues) }
        return filterArrayValue != nil
    }
    
    public func getSQLBinaryExpression() throws -> SQLBinaryExpression {
        .init(
            left: column.sqlColumn(),
            op: try getSQLOperatorExpression(),
            right: try getSQLOperandExpression()
        )
    }
    
    public func getSQLOperatorExpression() throws -> SQLExpression {
        try filterMethod.sqlOperator(
            lhsArray: fieldIsArray,
            rhsArray: try filterValueIsArray()
        )
    }
    
    public func getSQLOperandExpression() throws -> SQLExpression {
        if let filterValue { return SQLBind(filterValue) }
        if let filterArrayValue { return SQLBind(filterArrayValue) }
        throw KernelDynamicQuery.TypedError(.missingFilterValue)
    }
}

extension KernelDynamicQuery.Fluent.Model.StringFilter: CRUDModel {
    public typealias CreateDTO = KernelDynamicQuery.Core.APIModel.StringFilter.CreateStringFilterRequest
    public typealias UpdateDTO = KernelDynamicQuery.Core.APIModel.StringFilter.UpdateStringFilterRequest
    public typealias ResponseDTO = KernelDynamicQuery.Core.APIModel.StringFilter.StringFilterResponse
    
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
        model.fieldIsArray = dto.fieldIsArray
        model.filterMethod = dto.filterMethod
        model.filterValue = dto.filterValue
        model.filterArrayValue = dto.filterArrayValue
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
        try model.updateIfChanged(\.fieldIsArray, from: dto.fieldIsArray)
        try model.updateIfChanged(\.filterMethod, from: dto.filterMethod)
        try model.updateIfChanged(\.filterValue, from: dto.filterValue)
        try model.updateIfChanged(\.filterArrayValue, from: dto.filterArrayValue)
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
            fieldIsArray: fieldIsArray,
            filterMethod: filterMethod,
            filterValue: filterValue,
            filterArrayValue: filterArrayValue,
            structuredQueryId: $structuredQuery.id,
            parentGroupId: $parentGroup.id
        )
    }
}
    
