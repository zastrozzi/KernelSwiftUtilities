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
    public final class StructuredQuery: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.structuredQuery
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Field(key: "name") public var name: String
        
        @Children(for: \.$structuredQuery) public var filterGroups: [FilterGroup]
        @Children(for: \.$structuredQuery) public var dateFilters: [DateFilter]
        @Children(for: \.$structuredQuery) public var numericFilters: [NumericFilter]
        @Children(for: \.$structuredQuery) public var stringFilters: [StringFilter]
        @Children(for: \.$structuredQuery) public var booleanFilters: [BooleanFilter]
        @Children(for: \.$structuredQuery) public var uuidFilters: [UUIDFilter]
        @Children(for: \.$structuredQuery) public var enumFilters: [EnumFilter]
        @Children(for: \.$structuredQuery) public var fieldFilters: [FieldFilter]
        
        public init() {}
    }
}

extension KernelDynamicQuery.Fluent.Model.StructuredQuery {
    public func getSQLSelectExpression(onDB db: @escaping DBAccessor) async throws -> SQLSelect {
        try await $filterGroups.load(on: db())
        try await $dateFilters.load(on: db())
        try await $numericFilters.load(on: db())
        try await $stringFilters.load(on: db())
        try await $booleanFilters.load(on: db())
        try await $uuidFilters.load(on: db())
        try await $enumFilters.load(on: db())
        
        var sqlColumns: [SQLColumn] = []
        var sqlTables: [SQLNamespacedTable] = []
        
        let filterGroupExpressions = try await filterGroups
            .filter { $0.$parentGroup.id == nil }
            .asyncMap { group in
                try await group.getSQLListExpression(onDB: db)
            }
        let dateFilterExpressions = try dateFilters
            .filter { $0.$parentGroup.id == nil }
            .map { try $0.getSQLBinaryExpression() }
        let numericFilterExpressions = try numericFilters
            .filter { $0.$parentGroup.id == nil }
            .map { try $0.getSQLBinaryExpression() }
        let stringFilterExpressions = try stringFilters
            .filter { $0.$parentGroup.id == nil }
            .map { try $0.getSQLBinaryExpression() }
        let booleanFilterExpressions = try booleanFilters
            .filter { $0.$parentGroup.id == nil }
            .map { try $0.getSQLBinaryExpression() }
        let uuidFilterExpressions = try uuidFilters
            .filter { $0.$parentGroup.id == nil }
            .map { try $0.getSQLBinaryExpression() }
        let enumFilterExpressions = try enumFilters
            .filter { $0.$parentGroup.id == nil }
            .map { try $0.getSQLBinaryExpression() }
        
        dateFilters.forEach { sqlColumns.append($0.getSQLColumn()) }
        numericFilters.forEach { sqlColumns.append($0.getSQLColumn()) }
        stringFilters.forEach { sqlColumns.append($0.getSQLColumn()) }
        booleanFilters.forEach { sqlColumns.append($0.getSQLColumn()) }
        uuidFilters.forEach { sqlColumns.append($0.getSQLColumn()) }
        enumFilters.forEach { sqlColumns.append($0.getSQLColumn()) }
        
        dateFilters.forEach { sqlTables.append($0.getSQLTable()) }
        numericFilters.forEach { sqlColumns.append($0.getSQLColumn()) }
        stringFilters.forEach { sqlTables.append($0.getSQLTable()) }
        booleanFilters.forEach { sqlTables.append($0.getSQLTable()) }
        uuidFilters.forEach { sqlTables.append($0.getSQLTable()) }
        enumFilters.forEach { sqlTables.append($0.getSQLTable()) }
        
        var expressions: [any SQLExpression] = []
        expressions.append(contentsOf: filterGroupExpressions)
        expressions.append(contentsOf: dateFilterExpressions)
        expressions.append(contentsOf: numericFilterExpressions)
        expressions.append(contentsOf: stringFilterExpressions)
        expressions.append(contentsOf: booleanFilterExpressions)
        expressions.append(contentsOf: uuidFilterExpressions)
        expressions.append(contentsOf: enumFilterExpressions)
        
        let predicateExpression = SQLList(
            expressions,
            separator: SQLRaw(" AND ")
        )
        
        var selectExpression: SQLSelect = .init()
        selectExpression.tables = Array(Set(sqlTables))
        selectExpression.columns = sqlColumns
        selectExpression.predicate = predicateExpression
        
        
        return selectExpression
    }
}

extension KernelDynamicQuery.Fluent.Model.StructuredQuery: CRUDModel {
    public typealias CreateDTO = KernelDynamicQuery.Core.APIModel.StructuredQuery.CreateStructuredQueryRequest
    public typealias UpdateDTO = KernelDynamicQuery.Core.APIModel.StructuredQuery.UpdateStructuredQueryRequest
    public typealias ResponseDTO = KernelDynamicQuery.Core.APIModel.StructuredQuery.StructuredQueryResponse
    
    public static func createFields(
        from dto: CreateDTO,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        let model = self.init()
        model.name = dto.name
        
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.name, from: dto.name)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            name: name
        )
    }
}
    
