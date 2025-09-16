//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/05/2023.
//

import Foundation
import PostgresKit
import FluentKit
import SQLKit

extension KernelFluentModel {
    
    public struct CreateForeignKeyIndexes: AsyncMigration {
        public func prepare(on database: FluentKit.Database) async throws {
            let indexes = try await (database as! SQLDatabase)
                .select()
                .columns("tablename", "indexname", "indexdef")
                .from("pg_indexes")
                .where("schemaname", .equal, "public")
                .all(decoding: ForeignKeyIndex.self)
            
            indexes.forEach {
                KernelFluentModel.logger.trace("TABLENAME: \($0.tablename) INDEXED_COLS: \($0.indexDefColumnNames)")
            }
        }
        
        public func revert(on database: FluentKit.Database) async throws {
            
        }
        
        public init() {}
    }
}

public struct ForeignKeyIndex: Codable {
    public var tablename: String
    public var indexname: String
    public var indexdef: String
    
    public init(
        tablename: String,
        indexname: String,
        indexdef: String
    ) {
        self.tablename = tablename
        self.indexname = indexname
        self.indexdef = indexdef
    }
    
    public var indexDefColumnNames: [String] {
        guard let lastOpenedParenthesisIndex = self.indexdef.lastIndex(of: "(") else { return [] }
        guard let lastClosedParenthesisIndex = self.indexdef.lastIndex(of: ")") else { return [] }
        let columnNameStrings = self.indexdef[lastOpenedParenthesisIndex...lastClosedParenthesisIndex]
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: " ", with: "")
            .split(separator: ",")
            .map { String($0) }
        return columnNameStrings
    }
}
