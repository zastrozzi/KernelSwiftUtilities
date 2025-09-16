//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import OpenAPIKit30
import Vapor
import KernelSwiftCommon
//import protocol KernelSwiftCommon.AbstractSampleable

public protocol _OptionalWrapper {
    static var optionalWrappedType: Any.Type { get }
}

extension Optional: _OptionalWrapper {
    public static var optionalWrappedType: Any.Type {
        return Wrapped.self
    }
}

func isOptionalType(_ type: Any.Type) -> Bool {
    return type is _OptionalWrapper.Type
}

func wrappedTypeFromOptionalType(_ type: Any.Type) -> Any.Type? {
    return (type as? _OptionalWrapper.Type)?.optionalWrappedType
}

extension AbstractRouteContext {
    public static func openAPIResponses(using encoder: JSONEncoder) throws -> OpenAPI.Response.Map {

        let responseTuples = try responseBodyTuples
            .compactMap { responseTuple -> (OpenAPI.Response.StatusCode, OpenAPI.Response)? in

                let statusCode = OpenAPI.Response.StatusCode.status(
                    code: responseTuple.statusCode
                )

                let responseReason = HTTPStatus(statusCode: responseTuple.statusCode)
                    .reasonPhrase

                if responseTuple.responseBodyType == KernelSwiftCommon.Networking.HTTP.EmptyResponse.self {
                    return (
                        statusCode,
                        OpenAPI.Response(
                            description: responseReason
                        )
                    )
                }

                let contentType = responseTuple.contentType?.openAPIContentType

                let example = reverseEngineeredExample(for: responseTuple.responseBodyType, using: encoder)

                // first handle things explicitly supporting OpenAPI
                if let schema = try (responseTuple.responseBodyType as? OpenAPIEncodedSchemaType.Type)?.openAPISchema(using: encoder) {
                    return (
                        statusCode,
                        OpenAPI.Response(
                            description: responseReason,
                            content: [
                                (contentType ?? .json): .init(schema: .init(schema), example: example)
                            ]
                        )
                    )
                }

                // then try for a generic guess if the content type is JSON
                if (contentType == .json || contentType == .jsonapi),
                   let sample = (responseTuple.responseBodyType as? KernelSwiftCommon.AbstractSampleable.Type)?.abstractSample,
                    let schema = try? genericOpenAPISchemaGuess(for: sample, using: encoder) {

                    return (
                        statusCode,
                        OpenAPI.Response(
                            description: responseReason,
                            content: [
                                (contentType ?? .json): .init(schema: .init(schema), example: example)
                            ]
                        )
                    )
                }

                // finally, handle binary files and give a wildly vague schema for anything else.
                let schema: JSONSchema
//                if let contentType {
                    switch contentType {
                    case .any, .anyText, .css, .csv, .form, .html, .javascript, .json, .jsonapi, .multipartForm, .rtf, .txt, .xml, .yaml:
                        schema = .string
                    case .anyApplication, .anyAudio, .anyImage, .anyVideo, .bmp, .jpg, .mov, .mp3, .mp4, .mpg, .pdf, .rar, .tar, .tif, .zip:
                        schema = .string(format: .other("binary"))
                    default:
                        schema = .string
                    }
//                }

                return contentType.map {
                    OpenAPI.Response(
                        description: responseReason,
                        content: [
                            $0: .init(schema: .init(schema))
                        ]
                    )
                }.map { (statusCode, $0) }
        }
        
        let grouped: OpenAPIOrderedDictionary<OpenAPI.Response.StatusCode, OpenAPI.Response> = responseTuples.reduce(into: [:]) { res, next in
            if !res.keys.contains(next.0) {
                res[next.0] = next.1
            } else {
                var newMap: OpenAPI.Content.Map = [:]
                res[next.0]!.content.forEach { pair in
                    newMap[pair.key] = pair.value
                }
                next.1.content.forEach { pair in
                    newMap[pair.key] = pair.value
                }
                res[next.0]!.content = newMap
            }
        }

        return grouped.mapValues { .init($0) }
    }
}

extension Vapor.Routes {
    public func copy() -> Self {
        let newRoutes: Self = .init()
        for route in self.all {
            newRoutes.add(route.copy())
        }
        return newRoutes
    }
}

extension Vapor.Route {
    public func copy() -> Self {
        let newRoute: Self = .init(
            method: self.method,
            path: self.path,
            responder: self.responder,
            requestType: self.requestType,
            responseType: self.responseType
        )
        for (key, value) in self.userInfo {
            newRoute.userInfo[key] = value
        }
        return newRoute
    }
    
    func openAPITags() -> [OpenAPI.Tag] {
        guard userInfo.keys.contains("openapi:tags") else { return [] }
        guard let foundTags = userInfo["openapi:tags"] as? [String] else { return [] }
        return foundTags.map { .init(name: $0) }
    }

    func openAPIPathOperationConstructor(using encoder: JSONEncoder) throws -> PathOperationConstructor {
//        try autoreleasepool {
            let pathComponents = try OpenAPI.Path(
                path.map { try $0.openAPIPathComponent() }
            )
            
            let verb = try method.openAPIVerb()
            
            let requestBody = try openAPIRequest(for: requestType, using: encoder)
            
            let responses = try openAPIResponses(from: responseType, using: encoder)
            
            let pathParameters = path.compactMap { $0.openAPIPathParameter(in: self) }
            let queryParameters = openAPIQueryParams(from: responseType)
            let headerParameters = openAPIHeaderParams()
            let securityRequirements = openAPISecurityRequirements()
            
            let parameters = pathParameters
            + queryParameters
            + headerParameters
            
            return { context in
                
                let operation = OpenAPI.Operation(
                    tags: context.tags,
                    summary: context.summary,
                    description: context.description,
                    externalDocs: nil,
                    operationId: nil,
                    parameters: parameters.map { .init($0) },
                    requestBody: requestBody,
                    responses: responses,
                    security: securityRequirements,
                    servers: nil
                )
                
                return (
                    path: pathComponents,
                    verb: verb,
                    operation: operation
                )
            }
//        }
    }

    func openAPIPathOperation(using encoder: JSONEncoder) throws -> (path: OpenAPI.Path, verb: OpenAPI.HttpMethod, operation: OpenAPI.Operation) {
        let operation = try openAPIPathOperationConstructor(using: encoder)

        let summary = userInfo["openapi:summary"] as? String
        let description = userInfo["description"] as? String
        let tags = userInfo["openapi:tags"] as? [String]

        return operation(
            (
                summary: summary,
                description: description,
                tags: tags
            )
        )
    }

    private func openAPIQueryParams(from responseType: Any.Type) -> [OpenAPI.Parameter] {
        if let responseBodyType = responseType as? AbstractRouteContext.Type {
            return responseBodyType
                .requestQueryParams
                .map { $0.openAPIQueryParam() }
        }

        return []
    }
    
    private func openAPIHeaderParams() -> [OpenAPI.Parameter] {
        guard let headers = userInfo["openapi:headers"] as? [HTTPHeaders.Name] else { return [] }
        return headers.map { $0.openAPIHeaderParam() }
    }
    
    private func openAPISecurityRequirements() -> [OpenAPI.SecurityRequirement] {
        guard let securitySchemes = userInfo["openapi:security"] as? [SecuritySchemeName] else { return [] }
        let requirements: [OpenAPI.SecurityRequirement] = securitySchemes.map {
            [.component(named: $0.rawValue): []]
        }
        //let requirements: [OpenAPI.SecurityRequirement] = (security != nil) ? [[ .component(named: security!.rawValue): []]] : []
        return requirements
    }

    private func openAPIRequest(for requestType: Any.Type, using encoder: JSONEncoder) throws -> OpenAPI.Request? {
//        try autoreleasepool {
            guard !(requestType is KernelSwiftCommon.Networking.HTTP.EmptyRequest.Type) else {
                return nil
            }
            
            let contentTypes = userInfo["openapi:contentTypes"] as? [OpenAPI.ContentType] ?? [.json]
            
            let example = reverseEngineeredExample(for: requestType, using: encoder)
            let namedExamples = reverseEngineeredExamples(for: requestType, using: encoder)
            
            let customRequestBodyType = (requestType as? OpenAPIEncodedSchemaType.Type)
            ?? ((requestType as? _OptionalWrapper.Type)?.optionalWrappedType as? OpenAPIEncodedSchemaType.Type)
            
            guard let requestBodyType = customRequestBodyType else {
                return nil
            }
            
            let schema = try requestBodyType.openAPISchema(using: encoder)
            if let namedExamples {
                return OpenAPI.Request(
                    content: contentTypes.reduce(into: [:]) { res, next in
                        res[next] = .init(
                            schema: .init(schema),
                            examples: namedExamples
                        )
                    }
                )
            } else {
                return OpenAPI.Request(
                    content: contentTypes.reduce(into: [:]) { res, next in
                        res[next] = .init(
                            schema: .init(schema),
                            example: example
                        )
                    }
                )
            }
//        }
        
    }

    private func openAPIResponses(from responseType: Any.Type, using encoder: JSONEncoder) throws -> OpenAPI.Response.Map {
//        try autoreleasepool {
            if let responseBodyType = responseType as? AbstractRouteContext.Type {
                return try responseBodyType.openAPIResponses(using: encoder)
            }
            
            let responseBodyType = (responseType as? OpenAPIEncodedSchemaType.Type)
            ?? ((responseType as? _OptionalWrapper.Type)?.optionalWrappedType as? OpenAPIEncodedSchemaType.Type)
            
            let successResponse = try responseBodyType
                .map { responseType -> OpenAPI.Response in
                    let schema = try responseType.openAPISchema(using: encoder)
                    
                    return .init(
                        description: "Success",
                        content: [
                            .json: .init(schema: .init(schema))
                        ]
                    )
                }
            
            let responseTuples = [
                successResponse.map{ (OpenAPI.Response.StatusCode(200), $0) }
            ].compactMap { $0 }
            
            return OpenAPIOrderedDictionary(
                responseTuples,
                uniquingKeysWith: { $1 }
            ).mapValues { .init($0) }
        }
//    }
}

private func reverseEngineeredExample(for typeToSample: Any.Type, using encoder: JSONEncoder) -> AnyCodable? {
    guard let exampleType = (typeToSample as? OpenAPIExampleProvider.Type) else {
        return nil
    }
    

    return try? exampleType.openAPIExample(using: encoder)
}

private func reverseEngineeredExamples(for typeToSample: Any.Type, using encoder: JSONEncoder) -> OpenAPI.Example.Map? {
    guard let exampleType = typeToSample as? OpenAPINamedExampleProvider.Type else {
        return nil
    }

    return exampleType.openAPIExamples
}

typealias PartialPathOperationContext = (
    summary: String?,
    description: String?,
    tags: [String]?
)

typealias PathOperationConstructor = (PartialPathOperationContext) -> (path: OpenAPI.Path, verb: OpenAPI.HttpMethod, operation: OpenAPI.Operation)

extension HTTPHeaders.Name: @unchecked Sendable {}
