//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 25/03/2025.
//

import Logging

public enum KernelValidation: FeatureLoggable, ErrorTypeable {
    //    public static let logger = makeLogger()
    
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case validationFailed
        
        public var httpStatus: KernelNetworking.HTTP.ResponseStatus {
            switch self {
            case .validationFailed: .notAcceptable
            }
        }
        
        public var httpReason: String {
            switch self {
            case .validationFailed: "Validation Failed"
//            default: ""
            }
        }
    }
}

extension KernelSwiftCommon.TypedError<KernelValidation.ErrorTypes> {
    public static func validationFailed(
        failures: [KernelValidation.ValidationResult]
    ) -> KernelValidation.TypedError {
        .init(
            .validationFailed,
            httpStatus: .notAcceptable,
            reason: "Failed to validate",
            arguments: failures
        )
    }
}
