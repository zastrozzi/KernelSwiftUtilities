//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import Fluent

extension KernelDynamicQuery.Fluent {
    public enum Migrations: KernelServerPlatform.FluentMigrations {}
}

extension KernelDynamicQuery.Fluent.Migrations {
    public typealias SchemaName = KernelDynamicQuery.Fluent.SchemaName
}

extension KernelDynamicQuery.Fluent.Migrations {
    public static func prepare(on app: Application, for databaseId: DatabaseID) {
        app.migrations.add(SchemaName.Migration(), to: databaseId)
        
        // Enums
        app.migrations.add(KernelDynamicQuery.Core.APIModel.JoinMethod.Migration(), to: databaseId)
        app.migrations.add(KernelDynamicQuery.Core.APIModel.FilterMethod.Migration(), to: databaseId)
        app.migrations.add(KernelDynamicQuery.Core.APIModel.FilterRelation.Migration(), to: databaseId)
        app.migrations.add(KernelDynamicQuery.Core.APIModel.NumericDataType.Migration(), to: databaseId)
        
        app.migrations.add(StructuredQuery_Create_v1_0(), to: databaseId)
        app.migrations.add(FilterGroup_Create_v1_0(), to: databaseId)
        app.migrations.add(DateFilter_Create_v1_0(), to: databaseId)
        app.migrations.add(NumericFilter_Create_v1_0(), to: databaseId)
        app.migrations.add(StringFilter_Create_v1_0(), to: databaseId)
        app.migrations.add(BooleanFilter_Create_v1_0(), to: databaseId)
        app.migrations.add(UUIDFilter_Create_v1_0(), to: databaseId)
        app.migrations.add(EnumFilter_Create_v1_0(), to: databaseId)
        app.migrations.add(FieldFilter_Create_v1_0(), to: databaseId)
        app.migrations.add(JoinClause_Create_v1_0(), to: databaseId)
    }
}
