//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation
import HTTPTypes

extension KernelNetworking {
    public struct Converter: Sendable {
        public typealias HTTPBody = KernelNetworking.HTTPBody
        
        public let configuration: Configuration
        
        internal var encoder: JSONEncoder
        internal var decoder: JSONDecoder
        internal var headerFieldEncoder: JSONEncoder
        
        public init(configuration: Configuration) {
            self.configuration = configuration
            
            self.encoder = JSONEncoder()
            self.encoder.outputFormatting = .init(configuration.jsonEncodingOptions)
            self.encoder.dateEncodingStrategy = .from(dateTranscoder: configuration.dateTranscoder)
            
            self.headerFieldEncoder = JSONEncoder()
            self.headerFieldEncoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
            self.headerFieldEncoder.dateEncodingStrategy = .from(dateTranscoder: configuration.dateTranscoder)
            
            self.decoder = JSONDecoder()
            self.decoder.dateDecodingStrategy = .from(dateTranscoder: configuration.dateTranscoder)
        }
    }
}

extension KernelNetworking.Converter {
    public func setAcceptHeader(
        in headerFields: inout HTTPFields,
        contentTypes: [KernelNetworking.HTTP.MediaType]
    ) { headerFields[.accept] = contentTypes.map(\.description).joined(separator: ", ") }
    
    public func extractContentTypeIfPresent(from headerFields: HTTPFields) -> KernelNetworking.HTTP.MediaType? {
        guard let rawValue = headerFields[.contentType] else { return nil }
        return .init(rawValue)
    }
    
    public func renderedPath(template: String, parameters: [any Encodable]) throws -> String {
        var renderedString = template
        let encoder = KernelNetworking.URIEncoder(
            configuration: .init(
                style: .simple,
                explode: false,
                spaceEscapingCharacter: .percentEncoded,
                dateTranscoder: configuration.dateTranscoder
            )
        )
        for parameter in parameters {
            let value = try encoder.encode(parameter, forKey: "")
            if let range = renderedString.range(of: "{}") {
                renderedString = renderedString.replacingOccurrences(of: "{}", with: value, range: range)
            }
        }
        return renderedString
    }
    
    public func setQueryItemAsURI<T: Encodable>(
        in request: inout HTTPRequest,
        style: KernelNetworking.Configuration.ParameterStyle?,
        explode: Bool?,
        name: String,
        value: T?
    ) throws {
        try setEscapedQueryItem(
            in: &request,
            style: style,
            explode: explode,
            name: name,
            value: value,
            convert: { value, style, explode in
                try convertToURI(style: style, explode: explode, inBody: false, key: name, value: value)
            }
        )
    }
    
    public func setOptionalRequestBodyAsJSON<T: Encodable>(
        _ value: T?,
        headerFields: inout HTTPFields,
        contentType: String
    ) throws -> KernelNetworking.HTTPBody? {
        try setOptionalRequestBody(
            value,
            headerFields: &headerFields,
            contentType: contentType,
            convert: convertBodyCodableToJSON
        )
    }
    
    public func setRequiredRequestBodyAsJSON<T: Encodable>(
        _ value: T,
        headerFields: inout HTTPFields,
        contentType: String
    ) throws -> HTTPBody {
        try setRequiredRequestBody(
            value,
            headerFields: &headerFields,
            contentType: contentType,
            convert: convertBodyCodableToJSON
        )
    }
    
    public func setOptionalRequestBodyAsURLEncodedForm<T: Encodable>(
        _ value: T,
        headerFields: inout HTTPFields,
        contentType: String
    ) throws -> HTTPBody? {
        try setOptionalRequestBody(
            value,
            headerFields: &headerFields,
            contentType: contentType,
            convert: convertBodyCodableToURLFormData
        )
    }
    
    public func setRequiredRequestBodyAsURLEncodedForm<T: Encodable>(
        _ value: T,
        headerFields: inout HTTPFields,
        contentType: String
    ) throws -> HTTPBody {
        try setRequiredRequestBody(
            value,
            headerFields: &headerFields,
            contentType: contentType,
            convert: convertBodyCodableToURLFormData
        )
    }
    
    public func getResponseBodyAsJSON<T: Decodable, C>(
        _ type: T.Type,
        from data: HTTPBody?,
        transforming transform: (T) -> C
    ) async throws -> C {
        guard let data else { throw KernelNetworking.RuntimeError.missingRequiredResponseBody }
        return try await getBufferingResponseBody(
            type,
            from: data,
            transforming: transform,
            convert: convertJSONToBodyCodable
        )
    }
    
    public func setHeaderFieldAsURI<T: Encodable>(
        in headerFields: inout HTTPFields,
        name: String,
        value: T?
    ) throws {
        guard let value else { return }
        try setHeaderField(
            in: &headerFields,
            name: name,
            value: value,
            convert: { value in try convertToURI(style: .simple, explode: false, inBody: false, key: "", value: value) }
        )
    }
    
    public func setHeaderFieldAsJSON<T: Encodable>(
        in headerFields: inout HTTPFields,
        name: String,
        value: T?
    ) throws {
        try setHeaderField(in: &headerFields, name: name, value: value, convert: convertHeaderFieldCodableToJSON)
    }
}

extension KernelNetworking.Converter {
    func uriCoderConfiguration(
        style: KernelNetworking.Configuration.ParameterStyle,
        explode: Bool,
        inBody: Bool
    ) -> KernelNetworking.Configuration.URICoderConfiguration {
        .init(
            style: .init(style),
            explode: explode,
            spaceEscapingCharacter: inBody ? .plus : .percentEncoded,
            dateTranscoder: configuration.dateTranscoder
        )
    }
    
    func convertToURI<T: Encodable>(
        style: KernelNetworking.Configuration.ParameterStyle,
        explode: Bool,
        inBody: Bool,
        key: String,
        value: T
    ) throws
    -> String
    {
        let encoder = KernelNetworking.URIEncoder(
            configuration: uriCoderConfiguration(style: style, explode: explode, inBody: inBody)
        )
        let encodedString = try encoder.encode(value, forKey: key)
        return encodedString
    }
    
//    func convertFromURI<T: Decodable>(
//        style: KernelNetworking.Configuration.ParameterStyle,
//        explode: Bool,
//        inBody: Bool,
//        key: String,
//        encodedValue: Substring
//    ) throws -> T {
//        let decoder = KernelNetworking.URIDecoder(
//            configuration: uriCoderConfiguration(style: style, explode: explode, inBody: inBody)
//        )
//        let value = try decoder.decode(T.self, forKey: key, from: encodedValue)
//        return value
//    }
    
    func convertJSONToBodyCodable<T: Decodable>(_ body: HTTPBody) async throws -> T {
        let data = try await Data(collecting: body, upTo: .max)
        return try decoder.decode(T.self, from: data)
    }
    
    func convertBodyCodableToJSON<T: Encodable>(_ value: T) throws -> HTTPBody {
        let data = try encoder.encode(value)
        return HTTPBody(data)
    }
    
    func convertXMLToBodyCodable<T: Decodable>(_ body: HTTPBody) async throws -> T {
        guard let coder = configuration.xmlCoder else {
            throw KernelNetworking.RuntimeError.missingCoderForCustomContentType(contentType: "application/xml")
        }
        let data = try await Data(collecting: body, upTo: .max)
        return try coder.customDecode(T.self, from: data)
    }
    
    func convertBodyCodableToXML<T: Encodable>(_ value: T) throws -> HTTPBody {
        guard let coder = configuration.xmlCoder else {
            throw KernelNetworking.RuntimeError.missingCoderForCustomContentType(contentType: "application/xml")
        }
        let data = try coder.customEncode(value)
        return HTTPBody(data)
    }
    
    func convertBodyCodableToURLFormData<T: Encodable>(_ value: T) throws -> HTTPBody {
        let encoder = KernelNetworking.URIEncoder(
            configuration: .init(
                style: .form,
                explode: true,
                spaceEscapingCharacter: .plus,
                dateTranscoder: configuration.dateTranscoder
            )
        )
        let encodedString = try encoder.encode(value, forKey: "")
        return HTTPBody(encodedString)
    }
    
    func convertHeaderFieldCodableToJSON<T: Encodable>(_ value: T) throws -> String {
        let data = try headerFieldEncoder.encode(value)
        let stringValue = String(decoding: data, as: UTF8.self)
        return stringValue
    }
    
    func convertJSONToHeaderFieldCodable<T: Decodable>(_ stringValue: Substring) throws -> T {
        let data = Data(stringValue.utf8)
        return try decoder.decode(T.self, from: data)
    }
    
    func setHeaderField<T>(in headerFields: inout HTTPFields, name: String, value: T?, convert: (T) throws -> String) throws {
        guard let value else { return }
        try headerFields.append(.init(name: .init(validated: name), value: convert(value)))
    }
    
    func getHeaderFieldValuesString(in headerFields: HTTPFields, name: String) throws -> String? {
        try headerFields[.init(validated: name)]
    }
    
    func getOptionalHeaderField<T>(
        in headerFields: HTTPFields,
        name: String,
        as type: T.Type,
        convert: (Substring) throws -> T
    ) throws -> T? {
        guard let stringValue = try getHeaderFieldValuesString(in: headerFields, name: name) else { return nil }
        return try convert(stringValue[...])
    }
    
    func getRequiredHeaderField<T>(
        in headerFields: HTTPFields,
        name: String,
        as type: T.Type,
        convert: (Substring) throws -> T
    ) throws -> T {
        guard let stringValue = try getHeaderFieldValuesString(in: headerFields, name: name) else {
            throw KernelNetworking.RuntimeError.missingRequiredHeaderField(name)
        }
        return try convert(stringValue[...])
    }
    
    func setEscapedQueryItem<T>(
        in request: inout HTTPRequest,
        style: KernelNetworking.Configuration.ParameterStyle?,
        explode: Bool?,
        name: String,
        value: T?,
        convert: (T, KernelNetworking.Configuration.ParameterStyle, Bool) throws -> String
    ) throws {
        guard let value else { return }
        let (resolvedStyle, resolvedExplode) = try KernelNetworking.Configuration.ParameterStyle.resolvedQueryStyleAndExplode(
            name: name,
            style: style,
            explode: explode
        )
        let escapedUriSnippet = try convert(value, resolvedStyle, resolvedExplode)
        
        let pathAndAll = try request.requiredPath
        let fragmentStart = pathAndAll.firstIndex(of: "#") ?? pathAndAll.endIndex
        let fragment = pathAndAll[fragmentStart..<pathAndAll.endIndex]
        
        let queryStart = pathAndAll.firstIndex(of: "?")
        
        let pathEnd = queryStart ?? fragmentStart
        let path = pathAndAll[pathAndAll.startIndex..<pathEnd]
        
        guard let queryStart else {
            request.path = path.appending("?\(escapedUriSnippet)\(fragment)")
            return
        }
        
        let query = pathAndAll[pathAndAll.index(after: queryStart)..<fragmentStart]
        request.path = path.appending("?\(query)&\(escapedUriSnippet)\(fragment)")
    }
    
    func getOptionalQueryItem<T>(
        in query: Substring?,
        style: KernelNetworking.Configuration.ParameterStyle?,
        explode: Bool?,
        name: String,
        as type: T.Type,
        convert: (Substring, KernelNetworking.Configuration.ParameterStyle, Bool) throws -> T?
    ) throws -> T? {
        guard let query, !query.isEmpty else { return nil }
        let (resolvedStyle, resolvedExplode) = try KernelNetworking.Configuration.ParameterStyle.resolvedQueryStyleAndExplode(
            name: name,
            style: style,
            explode: explode
        )
        return try convert(query, resolvedStyle, resolvedExplode)
    }
    
    func getRequiredQueryItem<T>(
        in query: Substring?,
        style: KernelNetworking.Configuration.ParameterStyle?,
        explode: Bool?,
        name: String,
        as type: T.Type,
        convert: (Substring, KernelNetworking.Configuration.ParameterStyle, Bool) throws -> T
    ) throws -> T {
        guard
            let value = try getOptionalQueryItem(
                in: query,
                style: style,
                explode: explode,
                name: name,
                as: type,
                convert: convert
            )
        else { throw KernelNetworking.RuntimeError.missingRequiredQueryParameter(name) }
        return value
    }
    
    func setRequiredRequestBody<T>(
        _ value: T,
        headerFields: inout HTTPFields,
        contentType: String,
        convert: (T) throws -> HTTPBody
    ) rethrows -> HTTPBody {
        let body = try convert(value)
        headerFields[.contentType] = contentType
        if case let .known(length) = body.length { headerFields[.contentLength] = String(length) }
        return body
    }
    
    func setOptionalRequestBody<T>(
        _ value: T?,
        headerFields: inout HTTPFields,
        contentType: String,
        convert: (T) throws -> KernelNetworking.HTTPBody
    ) rethrows -> KernelNetworking.HTTPBody? {
        guard let value else { return nil }
        return try setRequiredRequestBody(
            value,
            headerFields: &headerFields,
            contentType: contentType,
            convert: convert
        )
    }
    
    func getOptionalBufferingRequestBody<T, C>(
        _ type: T.Type,
        from body: HTTPBody?,
        transforming transform: (T) -> C,
        convert: (HTTPBody) async throws -> T
    ) async throws -> C? {
        guard let body else { return nil }
        let decoded = try await convert(body)
        return transform(decoded)
    }
    
    func getRequiredBufferingRequestBody<T, C>(
        _ type: T.Type,
        from body: HTTPBody?,
        transforming transform: (T) -> C,
        convert: (HTTPBody) async throws -> T
    ) async throws -> C {
        guard
            let body = try await getOptionalBufferingRequestBody(
                type,
                from: body,
                transforming: transform,
                convert: convert
            )
        else { throw KernelNetworking.RuntimeError.missingRequiredRequestBody }
        return body
    }
    
    func getOptionalRequestBody<T, C>(
        _ type: T.Type,
        from body: HTTPBody?,
        transforming transform: (T) -> C,
        convert: (HTTPBody) throws -> T
    ) throws -> C? {
        guard let body else { return nil }
        let decoded = try convert(body)
        return transform(decoded)
    }
    
    func getRequiredRequestBody<T, C>(
        _ type: T.Type,
        from body: HTTPBody?,
        transforming transform: (T) -> C,
        convert: (HTTPBody) throws -> T
    ) throws -> C {
        guard let body = try getOptionalRequestBody(type, from: body, transforming: transform, convert: convert) else {
            throw KernelNetworking.RuntimeError.missingRequiredRequestBody
        }
        return body
    }
    
    func getBufferingResponseBody<T, C>(
        _ type: T.Type,
        from body: HTTPBody,
        transforming transform: (T) -> C,
        convert: (HTTPBody) async throws -> T
    ) async throws -> C {
        let parsedValue = try await convert(body)
        let transformedValue = transform(parsedValue)
        return transformedValue
    }
    
    func getResponseBody<T, C>(
        _ type: T.Type,
        from body: HTTPBody,
        transforming transform: (T) -> C,
        convert: (HTTPBody) throws -> T
    ) throws -> C {
        let parsedValue = try convert(body)
        let transformedValue = transform(parsedValue)
        return transformedValue
    }
    
    func setResponseBody<T>(
        _ value: T,
        headerFields: inout HTTPFields,
        contentType: String,
        convert: (T) throws -> HTTPBody
    ) rethrows -> HTTPBody {
        let body = try convert(value)
        headerFields[.contentType] = contentType
        if case let .known(length) = body.length { headerFields[.contentLength] = String(length) }
        return body
    }
    
    func getRequiredRequestPath<T>(
        in pathParameters: [String: Substring],
        name: String,
        as type: T.Type,
        convert: (Substring) throws -> T
    ) throws -> T {
        guard let untypedValue = pathParameters[name] else { throw KernelNetworking.RuntimeError.missingRequiredPathParameter(name) }
        return try convert(untypedValue)
    }
}
