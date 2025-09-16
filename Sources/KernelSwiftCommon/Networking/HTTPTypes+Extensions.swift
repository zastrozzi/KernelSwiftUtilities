//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation
import HTTPTypes

extension HTTPRequest {
    public init(path: String, method: Method, headerFields: HTTPFields = .init()) {
        self.init(method: method, scheme: nil, authority: nil, path: path, headerFields: headerFields)
    }
    
    public var query: Substring? {
        guard let path else { return nil }
        guard let queryStart = path.firstIndex(of: "?") else { return nil }
        let queryEnd = path.firstIndex(of: "#") ?? path.endIndex
        let query = path[path.index(after: queryStart)..<queryEnd]
        return query
    }
    
    public var pathOnly: Substring {
        guard let path else { return ""[...] }
        let pathEndIndex = path.firstIndex(of: "?") ?? path.firstIndex(of: "#") ?? path.endIndex
        return path[path.startIndex..<pathEndIndex]
    }
}

extension HTTPResponse {
    public init(statusCode: Int) { self.init(status: .init(code: statusCode)) }
}

//
//public struct ServerRequestMetadata: Hashable, Sendable {
//    public var pathParameters: [String: Substring]
//
//    public init(pathParameters: [String: Substring] = [:]) { self.pathParameters = pathParameters }
//}
//
//extension ServerRequestMetadata: CustomStringConvertible {
//    public var description: String { "Path parameters: \(pathParameters.description)" }
//}

extension HTTPFields: PrettyStringConvertible {
    var prettyDescription: String {
        sorted(by: { $0.name.canonicalName.localizedCompare($1.name.canonicalName) == .orderedAscending })
            .map { "\($0.name.canonicalName): \($0.value)" }.joined(separator: "; ")
    }
}

extension HTTPRequest: PrettyStringConvertible {
    var prettyDescription: String { "\(method.rawValue) \(path ?? "<nil>") [\(headerFields.prettyDescription)]" }
}

extension HTTPResponse: PrettyStringConvertible {
    var prettyDescription: String { "\(status.code) [\(headerFields.prettyDescription)]" }
}

extension KernelNetworking.HTTPBody: PrettyStringConvertible {
    var prettyDescription: String { String(describing: self) }
}


extension HTTPField.Name {
    init(validated name: String) throws {
        guard let fieldName = Self(name) else { throw KernelNetworking.RuntimeError.invalidHeaderFieldName(name) }
        self = fieldName
    }
}

extension HTTPRequest {
    var requiredPath: Substring {
        get throws {
            guard let path else { throw KernelNetworking.RuntimeError.pathUnset }
            return path[...]
        }
    }
}
