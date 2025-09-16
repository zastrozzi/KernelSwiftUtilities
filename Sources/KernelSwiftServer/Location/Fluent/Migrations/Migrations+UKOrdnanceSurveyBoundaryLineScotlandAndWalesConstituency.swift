//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/10/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent
import FluentPostgresDriver

extension KernelLocation.Fluent.Migrations {
    public struct UKOrdnanceSurveyBoundaryLineScotlandAndWalesConstituency_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.ukOrdnanceSurveyBoundaryLineScotlandAndWalesConstituency)
                .field(.id, .uuid, .required, .identifier(auto: false), .sql(.default(SQLFunction("gen_random_uuid"))))
                .timestampsWithDefaults()
                .field("geometry", .geometricMultiPolygon2D(.osgb36BritishNationalGrid), .required)
                .field("geometry_wgs84", .geometricMultiPolygon2D(.wgs84), .required)
                .field("name", .string)
                .field("area_code", .string, .required)
                .field("area_description", .string, .required)
                .field("file_name", .string, .required)
                .field("feature_serial_number", .int32, .required)
                .field("collection_serial_number", .int32, .required)
                .field("global_polygon_id", .int32, .required)
                .field("admin_unit_id", .int32, .required)
                .field("census_code", .string)
                .field("hectares", .float, .required)
                .field("non_inland_area", .float, .required)
                .field("area_type_code", .string, .required)
                .field("area_type_description", .string, .required)
                .field("non_area_type_code", .string)
                .field("non_area_type_description", .string)
                .unique(on: "feature_serial_number")
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.ukOrdnanceSurveyBoundaryLineScotlandAndWalesConstituency).delete()
        }
    }
    
    public struct UKOrdnanceSurveyBoundaryLineScotlandAndWalesConstituency_AddGeometryConversionTrigger: AsyncMigration {
        let tableName: String = SchemaName.ukOrdnanceSurveyBoundaryLineScotlandAndWalesConstituency.namespaceResolvedTable
        let functionName: String = SchemaName.ukOrdnanceSurveyBoundaryLineScotlandAndWalesConstituency.namespaceResolvedTable + "_gc()"
        let triggerName: String = SchemaName.ukOrdnanceSurveyBoundaryLineScotlandAndWalesConstituency.table + "_gc"
        
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
