//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/09/2023.
//

import Foundation

public enum KernelNetworking: FeatureLoggable, ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case invalidServerURL
        case transportFailed
        
        public var httpStatus: KernelNetworking.HTTP.ResponseStatus {
            switch self {
            case .invalidServerURL: .notAcceptable
            case .transportFailed: .badGateway
            }
        }
        
        public var httpReason: String {
            switch self {
            case .invalidServerURL: "Invalid Server URL"
            case .transportFailed: "Transport Failed"
            @unknown default: ""
            }
        }
    }
}

extension KernelSwiftCommon.TypedError<KernelNetworking.ErrorTypes> {
    public static func invalidServerURL(
        _ urlString: String
    ) -> KernelSwiftCommon.TypedError<KernelNetworking.ErrorTypes> {
        .init(
            .invalidServerURL,
            httpStatus: .notAcceptable,
            reason: "Invalid Server URL: \(urlString)"
        )
    }
}
