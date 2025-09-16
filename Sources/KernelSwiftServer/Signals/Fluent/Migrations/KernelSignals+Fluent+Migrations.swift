//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import Vapor
import Fluent

extension KernelSignals.Fluent {
    public enum Migrations: KernelServerPlatform.FluentMigrations {}
}

extension KernelSignals.Fluent.Migrations {
    public typealias SchemaName = KernelSignals.Fluent.SchemaName
}

extension KernelSignals.Fluent.Migrations {
    @_documentation(visibility: private)
    public typealias APIModel = KernelSignals.Core.APIModel
}

extension KernelSignals.Fluent.Migrations {
    public static func prepare(on app: Application, for databaseId: DatabaseID) {
        app.migrations.add(SchemaName.Migration(), to: databaseId)
        
        app.migrations.add(EventType_Create_v1_0(), to: databaseId)
        app.migrations.add(Event_Create_v1_0(), to: databaseId)
    }
}
