//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/4/24.
//

import Vapor
import Fluent

extension KernelWebFront.Fluent {
    public enum Migrations: KernelServerPlatform.FluentMigrations {}
}

extension KernelWebFront.Fluent.Migrations {
    public typealias SchemaName = KernelWebFront.Fluent.SchemaName
}

extension KernelWebFront.Fluent.Migrations {
    public static func prepare(on app: Application, for databaseId: DatabaseID) {
        app.migrations.add(SchemaName.Migration(), to: databaseId)
        app.migrations.add(FlowContainer_Create_v1_0(), to: databaseId)
        app.migrations.add(FlowNode_Create_v1_0(), to: databaseId)
        app.migrations.add(FlowContainer_AddEntryNode_v1_0(), to: databaseId)
        app.migrations.add(FlowContinuation_Create_v1_0(), to: databaseId)
    }
}
