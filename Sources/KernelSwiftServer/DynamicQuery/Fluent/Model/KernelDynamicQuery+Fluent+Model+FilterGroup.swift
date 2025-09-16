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
    public final class FilterGroup: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.filterGroup
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @KernelEnum(key: "relation") public var relation: KernelDynamicQuery.Core.APIModel.FilterRelation
        @Field(key: "nest_level") public var nestLevel: Int
        
        @Parent(key: "query_id") public var structuredQuery: StructuredQuery
        @OptionalParent(key: "parent_id") public var parentGroup: FilterGroup?
        
        @Children(for: \.$parentGroup) public var childGroups: [FilterGroup]
        @Children(for: \.$parentGroup) public var dateFilters: [DateFilter]
        @Children(for: \.$parentGroup) public var numericFilters: [NumericFilter]
        @Children(for: \.$parentGroup) public var stringFilters: [StringFilter]
        @Children(for: \.$parentGroup) public var booleanFilters: [BooleanFilter]
        @Children(for: \.$parentGroup) public var uuidFilters: [UUIDFilter]
        @Children(for: \.$parentGroup) public var enumFilters: [EnumFilter]
        
        public init() {}
    }
}

extension KernelDynamicQuery.Fluent.Model.FilterGroup {
    public func getSQLListExpression(onDB db: @escaping DBAccessor) async throws -> SQLGroupExpression {
        try await $childGroups.load(on: db())
        try await $dateFilters.load(on: db())
        try await $numericFilters.load(on: db())
        try await $stringFilters.load(on: db())
        try await $booleanFilters.load(on: db())
        try await $uuidFilters.load(on: db())
        try await $enumFilters.load(on: db())
        
        let childGroupExpressions = try await childGroups.asyncMap { group in
            try await group.getSQLListExpression(onDB: db)
        }
        let dateFilterExpressions = try dateFilters.map { try $0.getSQLBinaryExpression() }
//        let numericFilterExpressions = try numericFilters.map { try $0.getSQLBinaryExpression() }
        let stringFilterExpressions = try stringFilters.map { try $0.getSQLBinaryExpression() }
        let booleanFilterExpressions = try booleanFilters.map { try $0.getSQLBinaryExpression() }
        let uuidFilterExpressions = try uuidFilters.map { try $0.getSQLBinaryExpression() }
        let enumFilterExpressions = try enumFilters.map { try $0.getSQLBinaryExpression() }
        
        var expressions: [any SQLExpression] = []
        expressions.append(contentsOf: childGroupExpressions)
        expressions.append(contentsOf: dateFilterExpressions)
//        expressions.append(contentsOf: numericFilterExpressions)
        expressions.append(contentsOf: stringFilterExpressions)
        expressions.append(contentsOf: booleanFilterExpressions)
        expressions.append(contentsOf: uuidFilterExpressions)
        expressions.append(contentsOf: enumFilterExpressions)
        
        return .init(SQLList(expressions, separator: relation.toSQL()))
    }
}

extension KernelDynamicQuery.Fluent.Model.FilterGroup: CRUDModel {
    public typealias CreateDTO = KernelDynamicQuery.Core.APIModel.FilterGroup.CreateFilterGroupRequest
    public typealias UpdateDTO = KernelDynamicQuery.Core.APIModel.FilterGroup.UpdateFilterGroupRequest
    public typealias ResponseDTO = KernelDynamicQuery.Core.APIModel.FilterGroup.FilterGroupResponse
    
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
        model.relation = dto.relation
        if let queryId = options.queryId {
            model.$structuredQuery.id = queryId
        }
        if let parentId = options.parentId {
            let parent = try await SelfModel.findOrThrow(parentId, on: db()) {
                Abort(.notFound, reason: "Parent not found")
            }
            model.nestLevel = parent.nestLevel + 1
            model.$parentGroup.id = parentId
            model.$structuredQuery.id = parent.$structuredQuery.id
        } else {
            model.nestLevel = 0
        }
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.relation, from: dto.relation)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            relation: relation,
            nestLevel: nestLevel,
            structuredQueryId: $structuredQuery.id,
            parentGroupId: $parentGroup.id
        )
    }
}
    
