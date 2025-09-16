//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/12/2023.
//

import KernelSwiftCommon
import Vapor
import Fluent
import FluentPostgresDriver

// If we need retroactive attributes...
//extension KernelLocalisation.ISO3166.Alpha2: @retroactive _KernelSampleable {}
//extension KernelLocalisation.ISO3166.Alpha2: @retroactive _KernelAbstractSampleable {}
//extension KernelLocalisation.ISO3166.Alpha2: @retroactive PostgresArrayDecodable {}
//extension KernelLocalisation.ISO3166.Alpha2: @retroactive PostgresDecodable {}
//extension KernelLocalisation.ISO3166.Alpha2: @retroactive AsyncResponseEncodable {}
//extension KernelLocalisation.ISO3166.Alpha2: @retroactive AsyncRequestDecodable {}
//extension KernelLocalisation.ISO3166.Alpha2: @retroactive ResponseEncodable {}
//extension KernelLocalisation.ISO3166.Alpha2: @retroactive RequestDecodable {}
//extension KernelLocalisation.ISO3166.Alpha2: FluentStringEnum, @retroactive Content, OpenAPIStringEnumSampleable {
//    public static let fluentEnumName: String = "k_l10n-iso3166_a2"
//}
//
//extension KernelLocalisation.ISO639_1: @retroactive _KernelSampleable {}
//extension KernelLocalisation.ISO639_1: @retroactive _KernelAbstractSampleable {}
//extension KernelLocalisation.ISO639_1: @retroactive PostgresArrayDecodable {}
//extension KernelLocalisation.ISO639_1: @retroactive PostgresDecodable {}
//extension KernelLocalisation.ISO639_1: @retroactive AsyncResponseEncodable {}
//extension KernelLocalisation.ISO639_1: @retroactive AsyncRequestDecodable {}
//extension KernelLocalisation.ISO639_1: @retroactive ResponseEncodable {}
//extension KernelLocalisation.ISO639_1: @retroactive RequestDecodable {}
//extension KernelLocalisation.ISO639_1: FluentStringEnum, @retroactive Content, OpenAPIStringEnumSampleable {
//    public static let fluentEnumName: String = "k_l10n-iso639_1"
//}
//
//extension KernelLocalisation.ISO639_1.CountrySpecific: @retroactive _KernelSampleable {}
//extension KernelLocalisation.ISO639_1.CountrySpecific: @retroactive _KernelAbstractSampleable {}
//extension KernelLocalisation.ISO639_1.CountrySpecific: @retroactive PostgresArrayDecodable {}
//extension KernelLocalisation.ISO639_1.CountrySpecific: @retroactive PostgresDecodable {}
//extension KernelLocalisation.ISO639_1.CountrySpecific: @retroactive AsyncResponseEncodable {}
//extension KernelLocalisation.ISO639_1.CountrySpecific: @retroactive AsyncRequestDecodable {}
//extension KernelLocalisation.ISO639_1.CountrySpecific: @retroactive ResponseEncodable {}
//extension KernelLocalisation.ISO639_1.CountrySpecific: @retroactive RequestDecodable {}
//extension KernelLocalisation.ISO639_1.CountrySpecific: FluentStringEnum, @retroactive Content, OpenAPIStringEnumSampleable {
//    public static let fluentEnumName: String = "k_l10n-iso639_1-cty_spcfc"
//}

extension KernelLocalisation.ISO3166.Alpha2: _KernelSampleable {}
extension KernelLocalisation.ISO3166.Alpha2: _KernelAbstractSampleable {}
extension KernelLocalisation.ISO3166.Alpha2: PostgresArrayDecodable {}
extension KernelLocalisation.ISO3166.Alpha2: PostgresDecodable {}
extension KernelLocalisation.ISO3166.Alpha2: AsyncResponseEncodable {}
extension KernelLocalisation.ISO3166.Alpha2: AsyncRequestDecodable {}
extension KernelLocalisation.ISO3166.Alpha2: ResponseEncodable {}
extension KernelLocalisation.ISO3166.Alpha2: RequestDecodable {}
extension KernelLocalisation.ISO3166.Alpha2: FluentStringEnum, Content, OpenAPIStringEnumSampleable {
    public static let fluentEnumName: String = "k_l10n-iso3166_a2"
}

extension KernelLocalisation.ISO639_1: _KernelSampleable {}
extension KernelLocalisation.ISO639_1: _KernelAbstractSampleable {}
extension KernelLocalisation.ISO639_1: PostgresArrayDecodable {}
extension KernelLocalisation.ISO639_1: PostgresDecodable {}
extension KernelLocalisation.ISO639_1: AsyncResponseEncodable {}
extension KernelLocalisation.ISO639_1: AsyncRequestDecodable {}
extension KernelLocalisation.ISO639_1: ResponseEncodable {}
extension KernelLocalisation.ISO639_1: RequestDecodable {}
extension KernelLocalisation.ISO639_1: FluentStringEnum, Content, OpenAPIStringEnumSampleable {
    public static let fluentEnumName: String = "k_l10n-iso639_1"
}

extension KernelLocalisation.ISO639_1.CountrySpecific: _KernelSampleable {}
extension KernelLocalisation.ISO639_1.CountrySpecific: _KernelAbstractSampleable {}
extension KernelLocalisation.ISO639_1.CountrySpecific: PostgresArrayDecodable {}
extension KernelLocalisation.ISO639_1.CountrySpecific: PostgresDecodable {}
extension KernelLocalisation.ISO639_1.CountrySpecific: AsyncResponseEncodable {}
extension KernelLocalisation.ISO639_1.CountrySpecific: AsyncRequestDecodable {}
extension KernelLocalisation.ISO639_1.CountrySpecific: ResponseEncodable {}
extension KernelLocalisation.ISO639_1.CountrySpecific: RequestDecodable {}
extension KernelLocalisation.ISO639_1.CountrySpecific: FluentStringEnum, Content, OpenAPIStringEnumSampleable {
    public static let fluentEnumName: String = "k_l10n-iso639_1-cty_spcfc"
}

extension KernelLocalisation {
    public enum Fluent: KernelServerPlatform.FluentContainer {}
}

extension KernelLocalisation.Fluent {
    public enum SchemaName: String, KernelFluentNamespacedSchemaName {
        public static let namespace: String = "k_l10n"
        
        case translation = "translation"
    }
}

extension KernelLocalisation.Fluent {
    public enum Migrations: KernelServerPlatform.FluentMigrations {
        public typealias SchemaName = KernelLocalisation.Fluent.SchemaName
    }
    
    public enum Model: KernelServerPlatform.FluentModel {
        public typealias SchemaName = KernelLocalisation.Fluent.SchemaName
    }
}

extension KernelLocalisation.Fluent.Migrations {
    public static func prepare(on app: Application, for databaseId: DatabaseID) {
        app.migrations.add(SchemaName.Migration(), to: databaseId)
        app.migrations.add(KernelLocalisation.ISO3166.Alpha2.Migration(), to: databaseId)
        app.migrations.add(KernelLocalisation.ISO639_1.Migration(), to: databaseId)
        app.migrations.add(KernelLocalisation.ISO639_1.CountrySpecific.Migration(), to: databaseId)
    }
}
