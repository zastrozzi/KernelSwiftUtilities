//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/05/2023.
//

import Foundation
import Vapor
import Collections
import KernelSwiftCommon

extension KernelCSV.CSVCodingConfiguration {
    public enum StringCodingStrategy: String, Codable, Equatable, CaseIterable, OpenAPIStringEnumSampleable, Sendable {
        case utf8 = "utf8"
        case base32 = "base32"
        case base64 = "base64"
        case base64Url = "base64Url"
        
        public static let defaultStrategy: StringCodingStrategy = .utf8
        
        public func bytes(from value: String) -> [UInt8] {
            switch self {
            case .utf8: return value.utf8Bytes
            case .base32: return value.base32Bytes()
            case .base64: return value.base64Bytes()
            case .base64Url: return value.utf8Bytes.base64URLEncodedBytes()
            }
        }
        
        public func decodeString(from bytes: Deque<UInt8>) throws -> String {
//            guard primitive.self is String.Type else { throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode String from CSV bytes '\(bytes)'")) }
            switch self {
            case .utf8: return String(utf8EncodedBytes: bytes)
            case .base32: return String(utf8EncodedBytes: try KernelSwiftCommon.Coding.Base32.decodeBase32(.init(bytes)))
            case .base64: return String(utf8EncodedBytes: KernelSwiftCommon.Coding.Base64.decode(.init(bytes), type: .default))
            case .base64Url: return String(utf8EncodedBytes: KernelSwiftCommon.Coding.Base64.decode(.init(bytes), type: .url))
//            default: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode String from CSV bytes '\(bytes)' using \(self.rawValue) strategy"))
            }
        }
    }
}
