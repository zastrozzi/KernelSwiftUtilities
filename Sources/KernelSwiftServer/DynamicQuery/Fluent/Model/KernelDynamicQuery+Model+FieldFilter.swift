//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/02/2025.
//

import Vapor
import Fluent
import KernelSwiftCommon
import SQLKit

extension KernelDynamicQuery.Fluent.Model {
    public final class FieldFilter: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.fieldFilter
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Group(key: "left_col") public var leftColumn: ColumnIdentifiers
        @Group(key: "right_col") public var rightColumn: ColumnIdentifiers
        @KernelEnum(key: "method") public var filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod
        
        @Parent(key: "query_id") public var structuredQuery: StructuredQuery
        @OptionalParent(key: "group_id") public var parentGroup: FilterGroup?
        
        public init() {}
    }
}

extension KernelDynamicQuery.Fluent.Model.FieldFilter: DynamicQueryFilterModel {
    public var column: KernelDynamicQuery.Fluent.Model.ColumnIdentifiers {
        get { leftColumn }
        set { leftColumn = newValue }
    }
    
    public func getSQLOperandExpression() throws -> any SQLKit.SQLExpression {
        rightColumn.sqlColumn()
    }
    
    public func getSQLBinaryExpression() throws -> SQLBinaryExpression {
        .init(
            left: leftColumn.sqlColumn(),
            op: try getSQLOperatorExpression(),
            right: rightColumn.sqlColumn()
        )
    }
    
    public func getSQLOperatorExpression() throws -> SQLExpression {
        try filterMethod.sqlOperator(
            lhsArray: false,
            rhsArray: false
        )
    }
}

extension KernelDynamicQuery.Fluent.Model.FieldFilter: CRUDModel {
    public typealias CreateDTO = KernelDynamicQuery.Core.APIModel.FieldFilter.CreateFieldFilterRequest
    public typealias UpdateDTO = KernelDynamicQuery.Core.APIModel.FieldFilter.UpdateFieldFilterRequest
    public typealias ResponseDTO = KernelDynamicQuery.Core.APIModel.FieldFilter.FieldFilterResponse
    
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
        withOptions options: CreateOptions?
    ) async throws -> Self {
        //        print("HELLO!")
        guard let options else { throw KernelDynamicQuery.TypedError(.missingRequiredCreateOptions) }
        guard !(options.parentId == nil && options.queryId == nil) else {
            //            print("NO PARENT OR QUERY ID")
            throw KernelDynamicQuery.TypedError(.noParentOrQueryId)
        }
        let model = self.init()
        model.leftColumn = try .createFields(from: dto.leftColumn)
        model.rightColumn = try .createFields(from: dto.rightColumn)
        model.filterMethod = dto.filterMethod
        if let queryId = options.queryId {
            model.$structuredQuery.id = queryId
        }
        if let parentId = options.parentId {
            let parent = try await KernelDynamicQuery.Fluent.Model.FilterGroup.findOrThrow(parentId, on: db()) {
                KernelDynamicQuery.TypedError(.filterGroupNotFound)
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
        try model.updateIfChanged(\.$leftColumn, from: dto.leftColumn)
        try model.updateIfChanged(\.$rightColumn, from: dto.rightColumn)
        try model.updateIfChanged(\.filterMethod, from: dto.filterMethod)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            leftColumn: try leftColumn.response(),
            rightColumn: try rightColumn.response(),
            filterMethod: filterMethod,
            structuredQueryId: $structuredQuery.id,
            parentGroupId: $parentGroup.id
        )
    }
}

