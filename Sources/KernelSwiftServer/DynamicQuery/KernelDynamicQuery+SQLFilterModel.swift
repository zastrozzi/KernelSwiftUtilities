//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/02/2025.
//

import Vapor
import Fluent
import SQLKit

public protocol DynamicQueryFilterModel: KernelFluentNamespacedModel {
    var column: KernelDynamicQuery.Fluent.Model.ColumnIdentifiers { get set }
    func getSQLBinaryExpression() throws -> SQLBinaryExpression
    func getSQLOperatorExpression() throws -> SQLExpression
    func getSQLOperandExpression() throws -> SQLExpression
    func getSQLColumn() -> SQLColumn
}

extension DynamicQueryFilterModel {
    public func getSQLColumn() -> SQLColumn {
        column.sqlColumn()
    }
    
    public func getSQLTable() -> SQLNamespacedTable {
        column.sqlTable()
    }
}

public struct SQLNamespacedTable: SQLExpression, Equatable, Hashable {
    public var tableName: String
    public var spaceName: String

    public init(_ table: String, space: String) {
        self.tableName = table
        self.spaceName = space
    }
    
    public var table: SQLIdentifier { .init(tableName) }
    public var space: SQLIdentifier { .init(spaceName) }
    
    public static func == (lhs: SQLNamespacedTable, rhs: SQLNamespacedTable) -> Bool {
        lhs.spaceName == rhs.spaceName &&
        lhs.tableName == rhs.tableName
    }
    
    public func hash(into hasher: inout Hasher) {
        spaceName.hash(into: &hasher)
        tableName.hash(into: &hasher)
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        space.serialize(to: &serializer)
        serializer.write(".")
        table.serialize(to: &serializer)
    }
}
