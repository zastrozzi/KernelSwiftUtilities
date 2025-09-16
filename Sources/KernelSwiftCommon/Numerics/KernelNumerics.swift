//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

import Logging

public enum KernelNumerics: FeatureLoggable, ErrorTypeable {
//    public static let logger = makeLogger()
    
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case primeGenerationFailed
        case arithmeticOverflow
        case attemptedZeroDivision
        case unknownECDomain
        
        public var httpStatus: KernelNetworking.HTTP.ResponseStatus {
            switch self {
            case .arithmeticOverflow: .badRequest
            case .attemptedZeroDivision: .badRequest
            case .primeGenerationFailed: .internalServerError
            case .unknownECDomain: .unprocessableEntity
            }
        }
        
        public var httpReason: String {
            switch self {
            case .unknownECDomain: "Unknown EC Domain"
            default: ""
            }
        }
    }
}
