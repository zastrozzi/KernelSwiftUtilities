//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/10/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent
import FluentPostgresDriver

extension KernelLocation.Fluent.Migrations {
    public struct UKOrdnanceSurveyCodePoint_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.ukOrdnanceSurveyCodePoint)
                .field(.id, .uuid, .required, .identifier(auto: false), .sql(.default(SQLFunction("gen_random_uuid"))))
                .timestampsWithDefaults()
                .field("geometry", .geometricPoint2D(.osgb36BritishNationalGrid), .required)
                .field("geometry_wgs84", .geometricPoint2D(.wgs84), .required)
                .field("postcode", .string, .required)
                .field("positional_quality_indicator", .int, .required)
                .field("country_code", .string)
                .field("nhs_regional_ha_code", .string)
                .field("nhs_ha_code", .string)
                .field("admin_county_code", .string)
                .field("admin_district_code", .string)
                .field("admin_ward_code", .string)
                .unique(on: "postcode")
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.ukOrdnanceSurveyCodePoint).delete()
        }
    }
    
    public struct UKOrdnanceSurveyCodePoint_AddGeometryConversionTrigger: AsyncMigration {
        let tableName: String = SchemaName.ukOrdnanceSurveyCodePoint.namespaceResolvedTable
        let functionName: String = SchemaName.ukOrdnanceSurveyCodePoint.namespaceResolvedTable + "_gc()"
        let triggerName: String = SchemaName.ukOrdnanceSurveyCodePoint.table + "_gc"
        
        public func prepare(on database: any Database) async throws {
            let db = try database.asPostgres()
            
            let functionStatement: SQLQueryString = """
                create or replace function \(unsafeRaw: functionName)
                returns trigger language plpgsql as $$
                begin
                    new.geometry_wgs84:= st_transform(new.geometry,4326);
                    return new;
                end $$;
            """
            let triggerStatement: SQLQueryString = """
            create or replace trigger \(unsafeRaw: triggerName)
            before insert or update on \(unsafeRaw: tableName)
            for each row execute procedure \(unsafeRaw: functionName);
            """
            try await db.sql().raw(functionStatement).run()
            try await db.sql().raw(triggerStatement).run()
        }
        
        public func revert(on database: any Database) async throws {
            let db = try database.asPostgres()
            let triggerStatement: SQLQueryString = """
                drop trigger if exists \(unsafeRaw: triggerName)
                on \(unsafeRaw: tableName)
            """
            let functionStatement: SQLQueryString = "drop function if exists \(unsafeRaw: functionName)"
            try await db.sql().raw(triggerStatement).run()
            try await db.sql().raw(functionStatement).run()
            
        }
    }
}
