//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 01/05/2023.
//

//import Foundation
import Vapor
import Fluent
import FluentPostgresDriver
import PostgresKit
import PostgresNIO

public protocol FluentEnumConvertible: CaseIterable, RawRepresentable, PostgresArrayDecodable, Codable, OpenAPIStringEnumSampleable where Self.RawValue == String {
    typealias Migration = KernelFluentModel.ConvertibleEnumMigration<Self>
    static var fluentEnumName: String { get }
}

public protocol FluentStringEnum: Codable, Equatable, CaseIterable, FluentEnumConvertible {}

extension FluentEnumConvertible {
    public init<JSONDecoder: PostgresJSONDecoder>(
        from buffer: inout ByteBuffer,
        type: PostgresDataType,
        format: PostgresFormat,
        context: PostgresDecodingContext<JSONDecoder>
    ) throws {

        let rawString = String(buffer: buffer)
        guard let selfValue = Self.init(rawValue: rawString) else {
            throw PostgresDecodingError.Code.failure
        }
        self = selfValue
    }
}

extension FluentEnumConvertible {
    public static func toFluentEnum() -> DatabaseSchema.DataType.Enum {
        return .init(name: Self.fluentEnumName, cases: allCases.map { $0.rawValue })
    }
}

extension KernelFluentModel {
    public struct ConvertibleEnumMigration<ConvertibleEnum: FluentEnumConvertible>: AsyncMigration {
        public func prepare(on database: Database) async throws {
            do {
                var newEnum = database.enum(ConvertibleEnum.fluentEnumName)
                for enumCase in ConvertibleEnum.allCases {
                    newEnum = newEnum.case(enumCase.rawValue)
                }
                let _ = try await newEnum.create()
                return
            }
            catch {
                for enumCase in ConvertibleEnum.allCases {
                    do {
                        //                try await database.enum(ConvertibleEnum.fluentEnumName).delete()
                        var newEnum = database.enum(ConvertibleEnum.fluentEnumName)
                        newEnum = newEnum.case(enumCase.rawValue)
                        
                        let _ = try await newEnum.update()
                        continue
                        
                    } catch {
                        continue
                    }
                }
            }
            return
        }
        
        public func revert(on database: FluentKit.Database) async throws {
            try await database.enum(ConvertibleEnum.fluentEnumName).delete()
        }
        
        public init() {}
    }
}

extension DatabaseSchema.DataType {
    public static func `enum`<Enum: FluentEnumConvertible>(
        _ enum: Enum.Type
    ) -> DatabaseSchema.DataType {
        .enum(Enum.toFluentEnum())
    }
    
    public static func enumArray<Enum: FluentEnumConvertible>(
        _ enum: Enum.Type
    ) -> DatabaseSchema.DataType {
        .array(of: .enum(Enum.toFluentEnum()))
    }
}
