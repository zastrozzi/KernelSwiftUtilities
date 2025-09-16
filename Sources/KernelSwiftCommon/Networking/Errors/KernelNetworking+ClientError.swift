//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation
import HTTPTypes

extension KernelNetworking {
    public struct ClientError: Error {
        public var operationID: String
        public var operationInput: any Sendable
        public var request: HTTPRequest?
        public var requestBody: HTTPBody?
        public var baseURL: URL?
        public var response: HTTPResponse?
        public var responseBody: HTTPBody?
        public var causeDescription: String
        public var underlyingError: any Error
        
        public init(
            operationID: String,
            operationInput: any Sendable,
            request: HTTPRequest? = nil,
            requestBody: HTTPBody? = nil,
            baseURL: URL? = nil,
            response: HTTPResponse? = nil,
            responseBody: HTTPBody? = nil,
            causeDescription: String,
            underlyingError: any Error
        ) {
            self.operationID = operationID
            self.operationInput = operationInput
            self.request = request
            self.requestBody = requestBody
            self.baseURL = baseURL
            self.response = response
            self.responseBody = responseBody
            self.causeDescription = causeDescription
            self.underlyingError = underlyingError
        }
        
        fileprivate var underlyingErrorDescription: String {
            guard let prettyError = underlyingError as? (any PrettyStringConvertible) else { return "\(underlyingError)" }
            return prettyError.prettyDescription
        }
    }
}

extension KernelNetworking.ClientError: CustomStringConvertible {
    public var description: String {
        "Client error - cause description: '\(causeDescription)', underlying error: \(underlyingErrorDescription), operationID: \(operationID), operationInput: \(String(describing: operationInput)), request: \(request?.prettyDescription ?? "<nil>"), requestBody: \(requestBody?.prettyDescription ?? "<nil>"), baseURL: \(baseURL?.absoluteString ?? "<nil>"), response: \(response?.prettyDescription ?? "<nil>"), responseBody: \(responseBody?.prettyDescription ?? "<nil>")"
    }
}

extension KernelNetworking.ClientError: LocalizedError {
    public var errorDescription: String? {
        "Client encountered an error invoking the operation \"\(operationID)\", caused by \"\(causeDescription)\", underlying error: \(underlyingError.localizedDescription)."
    }
}

internal protocol PrettyStringConvertible {
    var prettyDescription: String { get }
}
