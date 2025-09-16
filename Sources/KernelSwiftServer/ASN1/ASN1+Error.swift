//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/07/2023.
//

import Vapor
import KernelSwiftCommon

extension KernelASN1: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case decodingFailed
        case parsingFailed
        case pemReadFailed
        case writingFailed
        case parserRanOutOfBytes
        
        case notImplemented
//        case rsaSetNotFound
    }
}
extension KernelSwiftCommon.TypedError<KernelASN1.ErrorTypes> {
    public static func decodingFailed<D: ASN1Decodable>(
        _ decoding: D.Type,
        expected: KernelASN1.ASN1Type.RawType? = nil,
        context: KernelASN1.ASN1Type? = nil
    ) -> KernelASN1.TypedError {
        .init(
            .decodingFailed,
            httpStatus: .unprocessableEntity,
            reason: "Failed to decode \(decoding). \(expected != nil ? "Expected to receive " + String(describing: expected!) : "")",
            arguments: [context ?? nil]
        )
    }
}
