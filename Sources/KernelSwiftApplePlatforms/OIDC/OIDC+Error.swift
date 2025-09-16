//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelAppUtils.OIDC: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case pkceCodeGeneratorFailure
        case scopesNotSupported
        case responseTypeNotSupported
        case clientAlreadyExists
        case badClientStatus
        case configurationMissing
        case discoveryDocumentMissing
        case urlGenerationFailed
        case tokenRequestGenerationFailed
        case tokenRequestExecutionFailed
    }
}
