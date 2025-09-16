//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2024.
//

import Vapor
import Fluent

extension KernelLocation.Fluent {
    public enum Migrations: KernelServerPlatform.FluentMigrations {}
}

extension KernelLocation.Fluent.Migrations {
    public typealias SchemaName = KernelLocation.Fluent.SchemaName
}

extension KernelLocation.Fluent.Migrations {
    public static func prepare(on app: Application, for databaseId: DatabaseID) {
        app.migrations.add(SchemaName.Migration(), to: databaseId)
        
        app.migrations.add(GeoLocation_Create_v1_0(), to: databaseId)
        
        // UK Ordnance Survey Boundary Line
        app.migrations.add(UKOrdnanceSurveyBoundaryLineCeremonialCounty_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineCeremonialCounty_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineCommunityWard_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineCommunityWard_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineCountryRegion_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineCountryRegion_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineCounty_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineCounty_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineCountyElectoralDivision_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineCountyElectoralDivision_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineDistrictBoroughUnitary_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineDistrictBoroughUnitary_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineDistrictBoroughUnitaryWard_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineDistrictBoroughUnitaryWard_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineEnglishRegion_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineEnglishRegion_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineGreaterLondonConstituency_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineGreaterLondonConstituency_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineHighWater_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineHighWater_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineHistoricCounty_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineHistoricCounty_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineHistoricEuropeanRegion_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineHistoricEuropeanRegion_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineParish_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineParish_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLinePollingDistrictsEngland_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLinePollingDistrictsEngland_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineScotlandAndWalesConstituency_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineScotlandAndWalesConstituency_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineScotlandAndWalesRegion_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineScotlandAndWalesRegion_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineUnitaryElectoralDivision_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineUnitaryElectoralDivision_AddGeometryConversionTrigger(), to: databaseId)
        
        app.migrations.add(UKOrdnanceSurveyBoundaryLineWestminsterConstituency_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyBoundaryLineWestminsterConstituency_AddGeometryConversionTrigger(), to: databaseId)
        
        // UK Ordnance Survey Code Point
        app.migrations.add(UKOrdnanceSurveyCodePoint_Create_v1_0(), to: databaseId)
        app.migrations.add(UKOrdnanceSurveyCodePoint_AddGeometryConversionTrigger(), to: databaseId)
    }
}
