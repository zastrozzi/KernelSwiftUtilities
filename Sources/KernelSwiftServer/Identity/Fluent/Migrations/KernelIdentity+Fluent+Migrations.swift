//
//  File.swift
//
//
//  Created by Jonathan Forbes on 30/4/24.
//

import Vapor
import Fluent

extension KernelIdentity.Fluent {
    public enum Migrations: KernelServerPlatform.FluentMigrations {}
}

extension KernelIdentity.Fluent.Migrations {
    public typealias SchemaName = KernelIdentity.Fluent.SchemaName
}

extension KernelIdentity.Fluent.Migrations {
    public static func prepare(on app: Application, for databaseId: DatabaseID) {
        app.migrations.add(SchemaName.Migration(), to: databaseId)
        app.migrations.add(KernelIdentity.Core.Model.LoggableAdminUserActionType.Migration(), to: databaseId)
        app.migrations.add(KernelIdentity.Core.Model.LoggableEnduserActionType.Migration(), to: databaseId)
        app.migrations.add(KernelIdentity.Core.Model.PhoneContactMethod.Migration(), to: databaseId)
        app.migrations.add(KernelIdentity.Core.Model.DeviceSystem.Migration(), to: databaseId)
        app.migrations.add(KernelIdentity.Core.Model.CredentialType.Migration(), to: databaseId)
        app.migrations.add(KernelIdentity.Core.Model.GenderPronoun.Migration(), to: databaseId)
        
        app.migrations.add(AdminUser_Create_v1_0(), to: databaseId)
        app.migrations.add(AdminUserCredential_Create_v1_0(), to: databaseId)
        app.migrations.add(AdminUserCredential_Update_v1_1(), to: databaseId)
        app.migrations.add(AdminUserEmail_Create_v1_0(), to: databaseId)
        app.migrations.add(AdminUserPhone_Create_v1_0(), to: databaseId)
        app.migrations.add(AdminUserDevice_Create_v1_0(), to: databaseId)
        app.migrations.add(AdminUserSession_Create_v1_0(), to: databaseId)
        app.migrations.add(AdminUserAction_Create_v1_0(), to: databaseId)
        
        app.migrations.add(Enduser_Create_v1_0(), to: databaseId)
        app.migrations.add(Enduser_Update_v1_1(), to: databaseId)
        app.migrations.add(Enduser_Update_v1_2(), to: databaseId)
        app.migrations.add(Enduser_Update_v1_3(), to: databaseId)
        app.migrations.add(Enduser_Update_v1_4(), to: databaseId)
        app.migrations.add(EnduserAddress_Create_v1_0(), to: databaseId)
        app.migrations.add(EnduserCredential_Create_v1_0(), to: databaseId)
        app.migrations.add(EnduserCredential_Update_v1_1(), to: databaseId)
        app.migrations.add(EnduserEmail_Create_v1_0(), to: databaseId)
        app.migrations.add(EnduserPhone_Create_v1_0(), to: databaseId)
        app.migrations.add(EnduserDevice_Create_v1_0(), to: databaseId)
        app.migrations.add(EnduserSession_Create_v1_0(), to: databaseId)
        app.migrations.add(EnduserAction_Create_v1_0(), to: databaseId)
        
    }
}
