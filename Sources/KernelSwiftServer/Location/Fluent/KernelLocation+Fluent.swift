//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2024.
//

extension KernelLocation {
    public enum Fluent: KernelServerPlatform.FluentContainer {}
}

extension KernelLocation.Fluent {
    public enum SchemaName: String, KernelFluentNamespacedSchemaName {
        public static let namespace: String = "k_loc"
        
        case geoLocation = "geo_location"
        case address = "address"
        case ukPostcode = "uk_postcode"
        case ukOrdnanceSurveyCodePoint = "uk_os_code_point"
        case ukOrdnanceSurveyBoundaryLineCeremonialCounty = "uk_os_bdline_cc"
        case ukOrdnanceSurveyBoundaryLineCommunityWard = "uk_os_bdline_cw"
        case ukOrdnanceSurveyBoundaryLineCountryRegion = "uk_os_bdline_cr"
        case ukOrdnanceSurveyBoundaryLineCounty = "uk_os_bdline_c"
        case ukOrdnanceSurveyBoundaryLineCountyElectoralDivision = "uk_os_bdline_ced"
        case ukOrdnanceSurveyBoundaryLineDistrictBoroughUnitary = "uk_os_bdline_dbu"
        case ukOrdnanceSurveyBoundaryLineDistrictBoroughUnitaryWard = "uk_os_bdline_dbuw"
        case ukOrdnanceSurveyBoundaryLineEnglishRegion = "uk_os_bdline_er"
        case ukOrdnanceSurveyBoundaryLineGreaterLondonConstituency = "uk_os_bdline_glc"
        case ukOrdnanceSurveyBoundaryLineHighWater = "uk_os_bdline_hw"
        case ukOrdnanceSurveyBoundaryLineHistoricCounty = "uk_os_bdline_hc"
        case ukOrdnanceSurveyBoundaryLineHistoricEuropeanRegion = "uk_os_bdline_her"
        case ukOrdnanceSurveyBoundaryLineParish = "uk_os_bdline_p"
        case ukOrdnanceSurveyBoundaryLinePollingDistrictsEngland = "uk_os_bdline_pde"
        case ukOrdnanceSurveyBoundaryLineScotlandAndWalesConstituency = "uk_os_bdline_swc"
        case ukOrdnanceSurveyBoundaryLineScotlandAndWalesRegion = "uk_os_bdline_swr"
        case ukOrdnanceSurveyBoundaryLineUnitaryElectoralDivision = "uk_os_bdline_ued"
        case ukOrdnanceSurveyBoundaryLineWestminsterConstituency = "uk_os_bdline_wc"
    }
}
