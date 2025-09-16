//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/05/2023.
//

import Foundation
import KernelSwiftCommon
import Vapor
import Fluent

public struct KernelFluentModel: FeatureLoggable {
//    public static let logger = makeLogger()
}

extension KernelFluentModel {
    public enum SchemaName: String, KernelFluentNamespacedSchemaName {
        public static let namespace: String = "ksc"
        
        case auditEvent = "audit_event"
    }
}

extension KernelFluentModel {
    public enum Migrations {
        public typealias SchemaName = KernelFluentModel.SchemaName
    }
}

extension KernelFluentModel.Migrations {
    public static func prepare(on app: Application, for databaseId: DatabaseID) {
        app.migrations.add(SchemaName.Migration(), to: databaseId)
        app.migrations.add(KernelSwiftCommon.ObjectID.Migration(), to: databaseId)
        app.migrations.add(KernelSwiftCommon.Barcode.CodeType.Migration(), to: databaseId)
        app.migrations.add(KernelSwiftCommon.Media.FileExtension.Migration(), to: databaseId)
        app.migrations.add(ISO3166CountryAlpha2Code.Migration(), to: databaseId)
        app.migrations.add(ISO3166CountryAlpha3Code.Migration(), to: databaseId)
        app.migrations.add(ISO3166CountryPhoneCode.Migration(), to: databaseId)
        app.migrations.add(KernelCurrency.Core.ISO4217.CurrencyCode.Migration(), to: databaseId)
        app.migrations.add(KernelFluentModel.Audit.EventActionType.Migration(), to: databaseId)
        app.migrations.add(KernelFluentModel.Audit.Event_Create_v1_0(), to: databaseId)
        
        app.migrations.add(KernelFluentPostGIS.EnablePostGISMigration(), to: databaseId)
    }
    
    public static func prepareAndMigrate(on app: Application, for databaseId: DatabaseID) async throws {
        prepare(on: app, for: databaseId)
        try await app.autoMigrate()
    }
}

extension KernelFluentModel: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case databaseIdNotConfigured
        
        public var httpStatus: KernelSwiftCommon.Networking.HTTP.ResponseStatus {
            switch self {
            case .databaseIdNotConfigured: .internalServerError
            }
        }
        
        public var httpReason: String {
            switch self {
            case .databaseIdNotConfigured: "Database ID not configured"
            }
        }
    }
}
