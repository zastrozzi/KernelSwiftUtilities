//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 03/10/2024.
//

import Fluent
import FluentPostgresDriver
import FluentMySQLDriver
import FluentSQLiteDriver
import SQLKit

public enum DatabaseVariantError: Error {
    case notSQLDatabase
    case notPostgresDatabase
    case notSQLiteDatabase
    case notMySQLDatabase
    
}

extension Database {
    public func asSQL() throws -> SQLDatabase {
        guard let sqlDatabase = self as? SQLDatabase else {
            throw DatabaseVariantError.notSQLDatabase
        }
        return sqlDatabase
    }
    
    public func asPostgres() throws -> PostgresDatabase {
        guard let postgresDatabase = self as? PostgresDatabase else {
            throw DatabaseVariantError.notPostgresDatabase
        }
        return postgresDatabase
    }
    
    public func asMySQL() throws -> MySQLDatabase {
        guard let mySQLDatabase = self as? MySQLDatabase else {
            throw DatabaseVariantError.notMySQLDatabase
        }
        return mySQLDatabase
    }
    
    public func asSQLite() throws -> SQLiteDatabase {
        guard let sqLiteDatabase = self as? SQLiteDatabase else {
            throw DatabaseVariantError.notSQLiteDatabase
        }
        return sqLiteDatabase
    }
}
