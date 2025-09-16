//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case databaseIdNotConfigured
        case structuredQueryNotFound
        case filterGroupNotFound
        case dateFilterNotFound
        case numericFilterNotFound
        case stringFilterNotFound
        case booleanFilterNotFound
        case uuidFilterNotFound
        case enumFilterNotFound
        
        case missingRequiredCreateOptions
        case missingRequiredUpdateOptions
        case missingRequiredResponseOptions
        case noParentOrQueryId
        
        case invalidFilterOperator
        case missingFilterValue
        case filterValueMismatch
        case multipleFilterValues
        
        
        public var httpStatus: KernelSwiftCommon.Networking.HTTP.ResponseStatus {
            switch self {
            case .databaseIdNotConfigured: .internalServerError
                
            case    .structuredQueryNotFound,
                    .filterGroupNotFound,
                    .dateFilterNotFound,
                    .numericFilterNotFound,
                    .stringFilterNotFound,
                    .booleanFilterNotFound,
                    .uuidFilterNotFound,
                    .enumFilterNotFound
                : .notFound
                
            case    .missingRequiredCreateOptions,
                    .missingRequiredUpdateOptions,
                    .missingRequiredResponseOptions,
                    .noParentOrQueryId,
                    .invalidFilterOperator,
                    .missingFilterValue,
                    .filterValueMismatch,
                    .multipleFilterValues
                : .badRequest
            }
        }
        
        public var httpReason: String {
            switch self {
            case .databaseIdNotConfigured: "Database ID not configured"
            case .structuredQueryNotFound: "Structured Query not found"
            case .filterGroupNotFound: "Filter Group not found"
            case .dateFilterNotFound: "Date Filter not found"
            case .numericFilterNotFound: "Numeric Filter not found"
            case .stringFilterNotFound: "String Filter not found"
            case .booleanFilterNotFound: "Boolean Filter not found"
            case .uuidFilterNotFound: "Uuid Filter not found"
            case .enumFilterNotFound: "Enum Filter not found"
            case .missingRequiredCreateOptions: "Missing Required Create Options"
            case .missingRequiredUpdateOptions: "Missing Required Update Options"
            case .missingRequiredResponseOptions: "Missing Required Response Options"
            case .noParentOrQueryId: "No Parent Or Query Id"
            case .invalidFilterOperator: "Invalid Filter Operator"
            case .missingFilterValue: "Missing Filter Value"
            case .filterValueMismatch: "Filter Value Mismatch"
            case .multipleFilterValues: "Multiple Filter Values"
            }
        }
    }
}
