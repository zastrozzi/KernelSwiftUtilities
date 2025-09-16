//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation
import HTTPTypes

extension DecodingError: PrettyStringConvertible {
    var prettyDescription: String {
        let output: String
        switch self {
        case .dataCorrupted(let context): output = "dataCorrupted - \(context.prettyDescription)"
        case .keyNotFound(let key, let context): output = "keyNotFound \(key) - \(context.prettyDescription)"
        case .typeMismatch(let type, let context): output = "typeMismatch \(type) - \(context.prettyDescription)"
        case .valueNotFound(let type, let context): output = "valueNotFound \(type) - \(context.prettyDescription)"
        @unknown default: output = "unknown: \(self)"
        }
        return "DecodingError: \(output)"
    }
}

extension DecodingError.Context: PrettyStringConvertible {
    var prettyDescription: String {
        let path = codingPath.map(\.description).joined(separator: "/")
        return "at \(path): \(debugDescription) (underlying error: \(underlyingError.map { "\($0)" } ?? "<nil>"))"
    }
}

extension EncodingError: PrettyStringConvertible {
    var prettyDescription: String {
        let output: String
        switch self {
        case .invalidValue(let value, let context): output = "invalidValue \(value) - \(context.prettyDescription)"
        @unknown default: output = "unknown: \(self)"
        }
        return "EncodingError: \(output)"
    }
}

extension EncodingError.Context: PrettyStringConvertible {
    var prettyDescription: String {
        let path = codingPath.map(\.description).joined(separator: "/")
        return "at \(path): \(debugDescription) (underlying error: \(underlyingError.map { "\($0)" } ?? "<nil>"))"
    }
}

public protocol HTTPResponseConvertible {
    var httpStatus: HTTPResponse.Status { get }
    var httpHeaderFields: HTTPFields { get }
    var httpBody: KernelNetworking.HTTPBody? { get }
}

extension HTTPResponseConvertible {
    public var httpHeaderFields: HTTPFields { [:] }
    
    public var httpBody: KernelNetworking.HTTPBody? { nil }
}
