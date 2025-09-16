//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import Fluent
import FluentPostgresDriver

public enum KernelFluentPostGIS: FeatureLoggable {
//    public static let logger = makeLogger()
}

extension KernelFluentPostGIS {
    public enum KnownCoordinateSystem: UInt, Codable, Equatable, CaseIterable, Sendable {
        case wgs84 = 4326
        case wgs84PsuedoMercator = 3857
        case osgb36BritishNationalGrid = 27700
        
        public func toCoordinateSystem() -> CoordinateSystem {
            switch self {
            case .wgs84: return .wgs84
            case .wgs84PsuedoMercator: return .wgs84PsuedoMercator
            case .osgb36BritishNationalGrid: return .osgb36BritishNationalGrid
            }
        }
    }
    
    public enum CoordinateSystem: Codable, Equatable, Sendable, RawRepresentable, RawOpenAPISchemaType, OpenAPIEncodableSampleable {
        public typealias RawValue = UInt
        
        case wgs84 // = 4326
        case wgs84PsuedoMercator // = 3857
        case osgb36BritishNationalGrid // = 27700
        
        case unknown(UInt)
        
        public var rawValue: RawValue {
            if case let .unknown(rawValue) = self { return rawValue }
            if let known = toKnownCoordinateSystem() { return known.rawValue }
            return 0
        }
        
        public init(rawValue: UInt) {
            if let known = KnownCoordinateSystem(rawValue: rawValue) {
                self = known.toCoordinateSystem()
            } else {
                self = .unknown(rawValue)
            }
        }
        
        public func toKnownCoordinateSystem() -> KnownCoordinateSystem? {
            switch self {
            case .wgs84: .wgs84
            case .wgs84PsuedoMercator: .wgs84PsuedoMercator
            case .osgb36BritishNationalGrid: .osgb36BritishNationalGrid
            default: nil
            }
        }
        
        public static func rawOpenAPISchema() throws -> JSONSchema {
            let allowedValues = KnownCoordinateSystem.allCases.map { AnyCodable(integerLiteral: Int($0.rawValue)) }
            return JSONSchema.integer(allowedValues: allowedValues)
        }
        
        public static var sample: KernelFluentPostGIS.CoordinateSystem {
            .wgs84
        }
        
        
    }
}

extension KernelFluentPostGIS {
    public struct EnablePostGISMigration: AsyncMigration {
        public init() {}

        public func prepare(on database: Database) async throws {
            let db = try database.asPostgres()
            try await db.sql().raw("CREATE EXTENSION IF NOT EXISTS \"postgis\"").run()
        }

        public func revert(on database: Database) async throws {
//            guard let db = database as? SQLDatabase else {
//                throw MigrationError.notSqlDatabase
//            }
//            try await db.raw("DROP EXTENSION IF EXISTS \"postgis\"").run()
        }
    }
}
