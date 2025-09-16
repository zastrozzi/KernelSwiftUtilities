//
//  File.swift
//
//
//  Created by Jonathan Forbes on 27/06/2023.
//

import Vapor
import KernelSwiftCommon

extension KernelNetworking: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case implementationMissing
        
        public var httpStatus: KernelSwiftCommon.Networking.HTTP.ResponseStatus {
            switch self {
            case .implementationMissing: .notImplemented
            }
        }
        
        public var httpReason: String {
            switch self {
            case .implementationMissing: "Not Implemented"
            }
        }
    }
}
