//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/07/2023.
//

import Vapor
import Fluent

extension KernelX509.Fluent {
    public enum Migrations: KernelServerPlatform.FluentMigrations {}
}

extension KernelX509.Fluent.Migrations {
    public typealias SchemaName = KernelX509.Fluent.SchemaName
}

extension KernelX509.Fluent.Migrations {
    public static func prepare(on app: Application, for databaseId: DatabaseID) {
        app.migrations.add(SchemaName.Migration(), to: databaseId)
        app.migrations.add(KernelASN1.ASN1AlgorithmIdentifier.Migration(), to: databaseId)
        app.migrations.add(KernelX509.Common.RelativeDistinguishedName.AttributeType.Migration(), to: databaseId)
        app.migrations.add(KernelX509.Common.RelativeDistinguishedName.AttributeValueType.Migration(), to: databaseId)
        app.migrations.add(KernelX509.Extension.ExtensionIdentifier.Migration(), to: databaseId)
        app.migrations.add(CSRInfo_Create_v1_0(), to: databaseId)
        app.migrations.add(RDNItem_Create_v1_0(), to: databaseId)
        app.migrations.add(V3Extension_Create_v1_0(), to: databaseId)
        app.migrations.add(Certificate_Create_v1_0(), to: databaseId)
    }
}
