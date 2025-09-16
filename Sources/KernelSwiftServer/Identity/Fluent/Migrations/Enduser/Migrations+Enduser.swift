//
//  File.swift
//
//
//  Created by Jonathan Forbes on 30/4/24.
//

import Vapor
import Fluent
import FluentPostgresDriver
import KernelSwiftCommon

extension KernelIdentity.Fluent.Migrations {
    public struct Enduser_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.enduser)
                .id()
                .timestamps()
                .field("first_name", .string, .required)
                .field("last_name", .string, .required)
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.enduser)
                .delete()
        }
    }
    
    public struct Enduser_Update_v1_1: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.enduser)
                .field("gender_pronoun", .enum(KernelIdentity.Core.Model.GenderPronoun.self), .required)
                .update()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.enduser)
                .deleteField("gender_pronoun")
                .update()
        }
    }
    
    public struct Enduser_Update_v1_2: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.enduser)
                .field("dob", .date)
                .update()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.enduser)
                .deleteField("dob")
                .update()
        }
    }
    
    public struct Enduser_Update_v1_3: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.enduser)
                .field("onboarding_complete", .bool, .required)
                .update()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.enduser)
                .deleteField("onboarding_complete")
                .update()
        }
    }
    
    public struct Enduser_Update_v1_4: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.enduser)
                .field("allow_insurance_call", .bool)
                .field("allow_tracking", .bool)
                .update()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.enduser)
                .deleteField("allow_insurance_call")
                .deleteField("allow_tracking")
                .update()
        }
    }
}
