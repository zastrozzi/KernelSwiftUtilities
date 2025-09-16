//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import Vapor
import Fluent
import Storage

extension KernelGoogleCloud.Fluent {
    public enum Migrations: KernelServerPlatform.FluentMigrations {}
}

extension KernelGoogleCloud.Fluent.Migrations {
    public typealias SchemaName = KernelGoogleCloud.Fluent.SchemaName
}

extension KernelGoogleCloud.Fluent.Migrations {
    public static func prepare(on app: Application, for databaseId: DatabaseID) {
        app.migrations.add(SchemaName.Migration(), to: databaseId)
        
        // Enums
//        app.migrations.add(GoogleCloudStorageClass.Migration(), to: databaseId)
        
        app.migrations.add(CloudStorageBucket_Create_v1_0(), to: databaseId)
        app.migrations.add(CloudStorageObject_Create_v1_0(), to: databaseId)
    }
}
