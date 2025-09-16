//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/07/2023.
//

import Vapor
import Fluent

extension KernelCryptography.Fluent {
    public enum Migrations: KernelServerPlatform.FluentMigrations {}
}

extension KernelCryptography.Fluent.Migrations {
    public typealias SchemaName = KernelCryptography.Fluent.SchemaName
}

extension KernelCryptography.Fluent.Migrations {
    public static func prepare(on app: Application, for databaseId: DatabaseID) {
        // Namespace
        app.migrations.add(SchemaName.Migration(), to: databaseId)
        // Enums
        app.migrations.add(KernelCryptography.Common.DerivedKeyIdentifierType.Migration(), to: databaseId)
        app.migrations.add(KernelCryptography.Common.KeyType.Migration(), to: databaseId)
        app.migrations.add(KernelCryptography.RSA.KeySize.Migration(), to: databaseId)
        
        
        app.migrations.add(RSASet_Create_v1_0(), to: databaseId)
        app.migrations.add(RSASet_Update_v1_1(), to: databaseId)
        app.migrations.add(ECSet_Create_v1_0(), to: databaseId)
        app.migrations.add(PublicKey_Create_v1_0(), to: databaseId)
        app.migrations.add(PrivateKey_Create_v1_0(), to: databaseId)

    }
}
