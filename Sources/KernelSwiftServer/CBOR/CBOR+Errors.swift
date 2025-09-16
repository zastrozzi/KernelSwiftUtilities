//
//  File.swift
//
//
//  Created by Jonathan Forbes on 18/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCBOR: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case missingTerminator
        case invalidType
        case badSequenceLength
        case invalidUTF8
        case notEnoughBytes
        case noRootType
        case missingTreeObjectMetadata
        case halfNotImplemented
        case decodingFailed
        case encodingFailed
        // etc.
    }
}

extension KernelSwiftCommon.TypedError<KernelCBOR.ErrorTypes> {
    public static func decodingFailed<D: KernelCBOR.CBORDecodable>(
        _ decoding: D.Type,
        expected: KernelCBOR.CBORRawType? = nil,
        received: KernelCBOR.CBORType? = nil
    ) -> KernelCBOR.TypedError {
        .init(
            .decodingFailed,
            httpStatus: .unprocessableEntity,
            reason: "Failed to decode \(decoding). \(expected != nil ? "Expected to receive " + String(describing: expected!) : "")",
            arguments: received != nil ? [received!] : []
        )
    }
}
