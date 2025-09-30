//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation
import KernelSwiftCommon
import HTTPTypes

extension KernelNetworking {
    public struct URLSessionTransport: KernelNetworking.ClientTransport {
        
        public struct Configuration: Sendable {
            
            public var session: URLSession
            
            public init(session: URLSession = .shared) { self.init(session: session, implementation: .platformDefault) }
            
            enum Implementation {
                case buffering
                case streaming(requestBodyStreamBufferSize: Int, responseBodyStreamWatermarks: (low: Int, high: Int))
            }
            
            var implementation: Implementation
            
            init(session: URLSession = .shared, implementation: Implementation = .platformDefault) {
                self.session = session
                if case .streaming = implementation {
                    precondition(Implementation.platformSupportsStreaming, "Streaming not supported on platform")
                }
                self.implementation = implementation
            }
        }
        
        public var configuration: Configuration
        
        public init(configuration: Configuration = .init()) { self.configuration = configuration }
        
        public func send(
            _ request: HTTPRequest,
            body requestBody: HTTPBody?,
            baseURL: URL,
            operationID: String
        ) async throws -> (HTTPResponse, HTTPBody?) {
            switch configuration.implementation {
            case .streaming(let requestBodyStreamBufferSize, let responseBodyStreamWatermarks):
#if canImport(Darwin)
                guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else {
                    throw URLSessionTransportError.streamingNotSupported
                }
                return try await configuration.session.bidirectionalStreamingRequest(
                    for: request,
                    baseURL: baseURL,
                    requestBody: requestBody,
                    requestStreamBufferSize: requestBodyStreamBufferSize,
                    responseStreamWatermarks: responseBodyStreamWatermarks
                )
#else
                throw URLSessionTransportError.streamingNotSupported
#endif
            case .buffering:
                return try await configuration.session.bufferedRequest(
                    for: request,
                    baseURL: baseURL,
                    requestBody: requestBody
                )
            }
        }
    }
}

extension KernelNetworking.HTTPBody.Length {
    init(from urlResponse: URLResponse) {
        if urlResponse.expectedContentLength == -1 {
            self = .unknown
        } else {
            self = .known(urlResponse.expectedContentLength)
        }
    }
}

extension KernelNetworking {
    internal enum URLSessionTransportError: Error {
        case invalidRequestURL(path: String, method: HTTPRequest.Method, baseURL: URL)
        case notHTTPResponse(URLResponse)
        case invalidResponseStatusCode(HTTPURLResponse)
        case noResponse(url: URL?)
        case streamingNotSupported
    }
}

extension HTTPResponse {
    init(_ urlResponse: URLResponse) throws {
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw KernelNetworking.URLSessionTransportError.notHTTPResponse(urlResponse)
        }
        guard (0...999).contains(httpResponse.statusCode) else {
            throw KernelNetworking.URLSessionTransportError.invalidResponseStatusCode(httpResponse)
        }
        self.init(status: .init(code: httpResponse.statusCode))
        if let fields = httpResponse.allHeaderFields as? [String: String] {
            self.headerFields.reserveCapacity(fields.count)
            for (name, value) in fields {
                if let name = HTTPField.Name(name) {
                    self.headerFields.append(HTTPField(name: name, isoLatin1Value: value))
                }
            }
        }
    }
}

extension URLRequest {
    init(_ request: HTTPRequest, baseURL: URL) throws {
        guard var baseUrlComponents = URLComponents(string: baseURL.absoluteString),
              let requestUrlComponents = URLComponents(string: request.path ?? "")
        else {
            throw KernelNetworking.URLSessionTransportError.invalidRequestURL(
                path: request.path ?? "<nil>",
                method: request.method,
                baseURL: baseURL
            )
        }
        
        let path = requestUrlComponents.percentEncodedPath
        baseUrlComponents.percentEncodedPath += path
        baseUrlComponents.percentEncodedQuery = requestUrlComponents.percentEncodedQuery
        guard let url = baseUrlComponents.url else {
            throw KernelNetworking.URLSessionTransportError.invalidRequestURL(path: path, method: request.method, baseURL: baseURL)
        }
        self.init(url: url)
        self.httpMethod = request.method.rawValue
        var combinedFields = [HTTPField.Name: String](minimumCapacity: request.headerFields.count)
        for field in request.headerFields {
            if let existingValue = combinedFields[field.name] {
                let separator = field.name == .cookie ? "; " : ", "
                combinedFields[field.name] = "\(existingValue)\(separator)\(field.isoLatin1Value)"
            } else {
                combinedFields[field.name] = field.isoLatin1Value
            }
        }
        var headerFields = [String: String](minimumCapacity: combinedFields.count)
        for (name, value) in combinedFields { headerFields[name.rawName] = value }
        self.allHTTPHeaderFields = headerFields
    }
}

extension String { fileprivate var isASCII: Bool { self.utf8.allSatisfy { $0 & 0x80 == .zero } } }

extension HTTPField {
    fileprivate init(name: Name, isoLatin1Value: String) {
        if isoLatin1Value.isASCII {
            self.init(name: name, value: isoLatin1Value)
        } else {
            self = withUnsafeTemporaryAllocation(of: UInt8.self, capacity: isoLatin1Value.unicodeScalars.count) {
                buffer in
                for (index, scalar) in isoLatin1Value.unicodeScalars.enumerated() {
                    if scalar.value > UInt8.max {
                        buffer[index] = 0x20
                    } else {
                        buffer[index] = UInt8(truncatingIfNeeded: scalar.value)
                    }
                }
                return HTTPField(name: name, value: buffer)
            }
        }
    }
    
    fileprivate var isoLatin1Value: String {
        if self.value.isASCII { return self.value }
        return self.withUnsafeBytesOfValue { buffer in
            let scalars = buffer.lazy.map { UnicodeScalar(UInt32($0))! }
            var string = ""
            string.unicodeScalars.append(contentsOf: scalars)
            return string
        }
    }
}

extension KernelNetworking.URLSessionTransportError: LocalizedError {
    var errorDescription: String? { description }
}

extension KernelNetworking.URLSessionTransportError: CustomStringConvertible {
    var description: String {
        switch self {
        case let .invalidRequestURL(path: path, method: method, baseURL: baseURL):
            return "Invalid request URL from request path: \(path), method: \(method), relative to base URL: \(baseURL.absoluteString)"
        case .notHTTPResponse(let response):
            return "Received a non-HTTP response, of type: \(String(describing: type(of: response)))"
        case .invalidResponseStatusCode(let response):
            return "Received an HTTP response with invalid status code: \(response.statusCode))"
        case .noResponse(let url): return "Received a nil response for \(url?.absoluteString ?? "<nil URL>")"
        case .streamingNotSupported: return "Streaming is not supported on this platform"
        }
    }
}

nonisolated(unsafe) private let _debugLoggingEnabled = KernelSwiftCommon.Concurrency.Core.StreamLock.Storage.create(value: false)
var debugLoggingEnabled: Bool {
    get { _debugLoggingEnabled.withLockedValue { $0 } }
    set { _debugLoggingEnabled.withLockedValue { $0 = newValue } }
}
nonisolated(unsafe) private let _standardErrorLock = KernelSwiftCommon.Concurrency.Core.StreamLock.Storage.create(value: FileHandle.standardError)

extension KernelNetworking {
    static func logDebug(_ message: @autoclosure () -> String, function: String = #function, file: String = #file, line: UInt = #line) {
        assert(
            {
                if debugLoggingEnabled {
                    _standardErrorLock.withLockedValue {
                        let logLine = "[\(function) \(file.split(separator: "/").last!):\(line)] \(message())\n"
                        $0.write(Data((logLine).utf8))
                    }
                }
                return true
            }()
        )
    }
}

extension URLSession {
    func bufferedRequest(for request: HTTPRequest, baseURL: URL, requestBody: KernelNetworking.HTTPBody?) async throws -> (
        HTTPResponse, KernelNetworking.HTTPBody?
    ) {
        try Task.checkCancellation()
        var urlRequest = try URLRequest(request, baseURL: baseURL)
        if let requestBody { urlRequest.httpBody = try await Data(collecting: requestBody, upTo: .max) }
        try Task.checkCancellation()
        
        let taskBox: KernelSwiftCommon.Concurrency.Core.StreamLock.LockedValueBox<URLSessionTask?> = .init(nil)
        return try await withTaskCancellationHandler {
            let (response, maybeResponseBodyData): (URLResponse, Data?) = try await withCheckedThrowingContinuation {
                continuation in
                let task = self.dataTask(with: urlRequest) { [urlRequest] data, response, error in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let response else {
                        continuation.resume(throwing: KernelNetworking.URLSessionTransportError.noResponse(url: urlRequest.url))
                        return
                    }
                    continuation.resume(with: .success((response, data)))
                }
                
                taskBox.withLockedValue { boxedTask in
                    guard task.state == .suspended else {
                        KernelNetworking.logger.debug("URLSession task cannot be resumed, probably because it was cancelled by onCancel.")
                        return
                    }
                    task.resume()
                    boxedTask = task
                }
            }
            
            let maybeResponseBody = maybeResponseBodyData.map { data in
                KernelNetworking.HTTPBody(data, length: KernelNetworking.HTTPBody.Length(from: response), iterationBehaviour: .multiple)
            }
            return (try HTTPResponse(response), maybeResponseBody)
        } onCancel: {
            taskBox.withLockedValue { boxedTask in
                KernelNetworking.logger.debug("Concurrency task cancelled, cancelling URLSession task.")
                boxedTask?.cancel()
                boxedTask = nil
            }
        }
    }
}

extension KernelNetworking.URLSessionTransport.Configuration.Implementation {
    static var platformSupportsStreaming: Bool {
#if canImport(Darwin)
        guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else { return false }
        _ = URLSession.bidirectionalStreamingRequest
        return true
#else
        return false
#endif
    }
    
    static var platformDefault: Self {
        guard platformSupportsStreaming else { return .buffering }
        return .streaming(
            requestBodyStreamBufferSize: 16 * 1024,
            responseBodyStreamWatermarks: (low: 16 * 1024, high: 32 * 1024)
        )
    }
}
