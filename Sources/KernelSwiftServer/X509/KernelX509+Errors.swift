//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/07/2023.
//

import Vapor
import KernelSwiftCommon

extension KernelX509: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case privateKeyNotIncluded
        case extensionDecodingFailed
        case invalidSignatureForKeyType
    }
}

extension KernelSwiftCommon.TypedError<KernelX509.ErrorTypes> {
    public static func extensionDecodingFailed<X: X509ExtensionDecodable>(_ decoding: X.Type) -> KernelX509.TypedError {
        .init(.extensionDecodingFailed, httpStatus: .unprocessableEntity, reason: "Failed to decode X509 Extension \(decoding)")
    }
}
