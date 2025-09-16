//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/09/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelLocation.Fluent.Migrations {
    public struct GeoLocation_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.geoLocation)
                .id()
                .timestamps()
                .field("point", .geometricPoint2D(), .required)
                .field("name", .string, .required)
                .field("enduser_id", .uuid, .references(KernelIdentity.Fluent.SchemaName.enduser, .id, onDelete: .setNull, onUpdate: .cascade))
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.geoLocation).delete()
        }
    }
}
