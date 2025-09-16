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
    public final class NumericFilter: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.numericFilter
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Group(key: "col") public var column: ColumnIdentifiers
        @Boolean(key: "field_array") public var fieldIsArray: Bool
        @KernelEnum(key: "method") public var filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod
        @KernelEnum(key: "data_type") public var numericDataType: KernelDynamicQuery.Core.APIModel.NumericDataType
        
        @OptionalField(key: "int8_value") public var int8FilterValue: Int8?
        @OptionalField(key: "int8_array_value") public var int8ArrayFilterValue: [Int8]?
        @OptionalField(key: "int16_value") public var int16FilterValue: Int16?
        @OptionalField(key: "int16_array_value") public var int16ArrayFilterValue: [Int16]?
        @OptionalField(key: "int32_value") public var int32FilterValue: Int32?
        @OptionalField(key: "int32_array_value") public var int32ArrayFilterValue: [Int32]?
        @OptionalField(key: "int64_value") public var int64FilterValue: Int64?
        @OptionalField(key: "int64_array_value") public var int64ArrayFilterValue: [Int64]?
        
        @OptionalField(key: "uint8_value") public var uint8FilterValue: UInt8?
        @OptionalField(key: "uint8_array_value") public var uint8ArrayFilterValue: [UInt8]?
        @OptionalField(key: "uint16_value") public var uint16FilterValue: UInt16?
        @OptionalField(key: "uint16_array_value") public var uint16ArrayFilterValue: [UInt16]?
        @OptionalField(key: "uint32_value") public var uint32FilterValue: UInt32?
        @OptionalField(key: "uint32_array_value") public var uint32ArrayFilterValue: [UInt32]?
        @OptionalField(key: "uint64_value") public var uint64FilterValue: UInt64?
        @OptionalField(key: "uint64_array_value") public var uint64ArrayFilterValue: [UInt64]?
        
        @OptionalField(key: "double_value") public var doubleFilterValue: Double?
        @OptionalField(key: "double_array_value") public var doubleArrayFilterValue: [Double]?
        @OptionalField(key: "float_value") public var floatFilterValue: Float?
        @OptionalField(key: "float_array_value") public var floatArrayFilterValue: [Float]?
        
        @Parent(key: "query_id") public var structuredQuery: StructuredQuery
        @OptionalParent(key: "group_id") public var parentGroup: FilterGroup?
        
        public init() {}
    }
}

extension KernelDynamicQuery.Fluent.Model.NumericFilter: DynamicQueryFilterModel {
    public var filterValue: (any Numeric & Codable & Sendable)? {
        switch numericDataType {
        case .int8: int8FilterValue
        case .int16: int16FilterValue
        case .int32: int32FilterValue
        case .int64: int64FilterValue
        case .uint8: uint8FilterValue
        case .uint16: uint16FilterValue
        case .uint32: uint32FilterValue
        case .uint64: uint64FilterValue
        case .double: doubleFilterValue
        case .float: floatFilterValue
        }
    }
    
    public var filterArrayValue: Array<any Numeric & Codable & Sendable>? {
        switch numericDataType {
        case .int8: int8ArrayFilterValue
        case .int16: int16ArrayFilterValue
        case .int32: int32ArrayFilterValue
        case .int64: int64ArrayFilterValue
        case .uint8: uint8ArrayFilterValue
        case .uint16: uint16ArrayFilterValue
        case .uint32: uint32ArrayFilterValue
        case .uint64: uint64ArrayFilterValue
        case .double: doubleArrayFilterValue
        case .float: floatArrayFilterValue
        }
    }
    
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
//        if let filterArrayValue { return SQLBind(filterArrayValue) }
        throw KernelDynamicQuery.TypedError(.missingFilterValue)
    }
}

extension KernelDynamicQuery.Fluent.Model.NumericFilter: CRUDModel {
    public typealias CreateDTO = KernelDynamicQuery.Core.APIModel.NumericFilter.CreateNumericFilterRequest
    public typealias UpdateDTO = KernelDynamicQuery.Core.APIModel.NumericFilter.UpdateNumericFilterRequest
    public typealias ResponseDTO = KernelDynamicQuery.Core.APIModel.NumericFilter.NumericFilterResponse
    
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
        model.numericDataType = dto.numericDataType
        model.int8FilterValue = dto.int8FilterValue
        model.int8ArrayFilterValue = dto.int8ArrayFilterValue
        model.int16FilterValue = dto.int16FilterValue
        model.int16ArrayFilterValue = dto.int16ArrayFilterValue
        model.int32FilterValue = dto.int32FilterValue
        model.int32ArrayFilterValue = dto.int32ArrayFilterValue
        model.int64FilterValue = dto.int64FilterValue
        model.int64ArrayFilterValue = dto.int64ArrayFilterValue
        model.uint8FilterValue = dto.uint8FilterValue
        model.uint8ArrayFilterValue = dto.uint8ArrayFilterValue
        model.uint16FilterValue = dto.uint16FilterValue
        model.uint16ArrayFilterValue = dto.uint16ArrayFilterValue
        model.uint32FilterValue = dto.uint32FilterValue
        model.uint32ArrayFilterValue = dto.uint32ArrayFilterValue
        model.uint64FilterValue = dto.uint64FilterValue
        model.uint64ArrayFilterValue = dto.uint64ArrayFilterValue
        model.doubleFilterValue = dto.doubleFilterValue
        model.doubleArrayFilterValue = dto.doubleArrayFilterValue
        model.floatFilterValue = dto.floatFilterValue
        model.floatArrayFilterValue = dto.floatArrayFilterValue
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
        try model.updateIfChanged(\.numericDataType, from: dto.numericDataType)
        try model.updateIfChanged(\.int8FilterValue, from: dto.int8FilterValue)
        try model.updateIfChanged(\.int8ArrayFilterValue, from: dto.int8ArrayFilterValue)
        try model.updateIfChanged(\.int16FilterValue, from: dto.int16FilterValue)
        try model.updateIfChanged(\.int16ArrayFilterValue, from: dto.int16ArrayFilterValue)
        try model.updateIfChanged(\.int32FilterValue, from: dto.int32FilterValue)
        try model.updateIfChanged(\.int32ArrayFilterValue, from: dto.int32ArrayFilterValue)
        try model.updateIfChanged(\.int64FilterValue, from: dto.int64FilterValue)
        try model.updateIfChanged(\.int64ArrayFilterValue, from: dto.int64ArrayFilterValue)
        try model.updateIfChanged(\.uint8FilterValue, from: dto.uint8FilterValue)
        try model.updateIfChanged(\.uint8ArrayFilterValue, from: dto.uint8ArrayFilterValue)
        try model.updateIfChanged(\.uint16FilterValue, from: dto.uint16FilterValue)
        try model.updateIfChanged(\.uint16ArrayFilterValue, from: dto.uint16ArrayFilterValue)
        try model.updateIfChanged(\.uint32FilterValue, from: dto.uint32FilterValue)
        try model.updateIfChanged(\.uint32ArrayFilterValue, from: dto.uint32ArrayFilterValue)
        try model.updateIfChanged(\.uint64FilterValue, from: dto.uint64FilterValue)
        try model.updateIfChanged(\.uint64ArrayFilterValue, from: dto.uint64ArrayFilterValue)
        try model.updateIfChanged(\.doubleFilterValue, from: dto.doubleFilterValue)
        try model.updateIfChanged(\.doubleArrayFilterValue, from: dto.doubleArrayFilterValue)
        try model.updateIfChanged(\.floatFilterValue, from: dto.floatFilterValue)
        try model.updateIfChanged(\.floatArrayFilterValue, from: dto.floatArrayFilterValue)
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
            numericDataType: numericDataType,
            int8FilterValue: int8FilterValue,
            int8ArrayFilterValue: int8ArrayFilterValue,
            int16FilterValue: int16FilterValue,
            int16ArrayFilterValue: int16ArrayFilterValue,
            int32FilterValue: int32FilterValue,
            int32ArrayFilterValue: int32ArrayFilterValue,
            int64FilterValue: int64FilterValue,
            int64ArrayFilterValue: int64ArrayFilterValue,
            uint8FilterValue: uint8FilterValue,
            uint8ArrayFilterValue: uint8ArrayFilterValue,
            uint16FilterValue: uint16FilterValue,
            uint16ArrayFilterValue: uint16ArrayFilterValue,
            uint32FilterValue: uint32FilterValue,
            uint32ArrayFilterValue: uint32ArrayFilterValue,
            uint64FilterValue: uint64FilterValue,
            uint64ArrayFilterValue: uint64ArrayFilterValue,
            doubleFilterValue: doubleFilterValue,
            doubleArrayFilterValue: doubleArrayFilterValue,
            floatFilterValue: floatFilterValue,
            floatArrayFilterValue: floatArrayFilterValue,
            structuredQueryId: $structuredQuery.id,
            parentGroupId: $parentGroup.id
        )
    }
}
    
