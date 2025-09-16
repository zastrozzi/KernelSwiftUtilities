//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/06/2025.
//

import KernelSwiftCommon
import Vapor
import OpenAPIKit30

extension OpenAPI.PathItem {
    public typealias PathItemMap = OpenAPIOrderedDictionary<OpenAPI.Path, OpenAPI.PathItem>
}

extension KernelDocumentation.Services {
    public struct OpenAPIService: DBAccessible, Sendable {
        @KernelDI.Injected(\.vapor) public var app
        public typealias FeatureContainer = KernelDocumentation
        private let tagsCache: KernelServerPlatform.SimpleMemoryCache<String, OpenAPI.Tag>
        private let operationCache: KernelServerPlatform.TaggedMemoryCache<OpenAPI.HttpMethod, String, OpenAPIPathOperation>
        private let documentCache: KernelServerPlatform.SimpleMemoryCache<String, OpenAPI.Document>
        let encoder: JSONEncoder = .custom(dates: .iso8601, format: .sortedKeys)
        
        public init() {
            Self.logInit()
            documentCache = .init()
            tagsCache = .init()
            operationCache = .init()
        }
        
        public func getGlobalDocument(
            title: String,
            pathComponents: [PathComponent] = [.constant("docs"), .constant("1.0")],
            openAPISubpath: [PathComponent] = [.constant("openapi")],
            openAPISpecDescriptor: String = "spec",
            excludedPaths: [[PathComponent]] = [],
            excludedTags: [String] = ["Documentation"],
            collections: [DocumentationCollection]
        ) throws -> OpenAPI.Document {
            let combinedExcludedPaths: [[PathComponent]] = excludedPaths + [pathComponents]
//            let startTime: Double = ProcessInfo.processInfo.systemUptime
            let serverUrl = try app.kernelDI(KernelNetworking.self).resolvedHost.getLatestRecordHostURL()
            let sublinks = collections.map { collection in
                "\n - [" + collection.title + "]" + "(/" + (pathComponents + openAPISubpath + collection.collectionPath).map { $0.description }.joined(separator: "/") + ")"
            }
            let joinedSublinks = sublinks.joined(separator: "")
            let info = OpenAPI.Document.Info(
                title: title,
                description:
            """
            # Introduction
            Welcome to \(title) Documentation.
            
            ## Further Links
            This documentation collection is also available in smaller collections relevant to use cases.
            Use the links below to view each subcollection.
            \(joinedSublinks)
            
            ---
            
            # Guides
            
            ## Authentication
            
            This platform uses two key factors for authentication and authorisation of requests.
            
            ### Authorization Header
              
            The first of these is a common `Authorization` HTTP Header which expects a valid JSON Web Token prefaced with `Bearer `.  
              
            Two separate tokens (an *Access Token* and a *Refresh Token*) are returned to the user during 
            [Login Enduser](#tag/identity-enduser-v10/POST/identity/1.0/endusers/auth/login), 
            [Register Enduser](#tag/identity-enduser-v10/POST/identity/1.0/endusers/auth/register), 
            [Refresh Enduser Token](#tag/identity-enduser-v10/POST/identity/1.0/endusers/auth/refresh-token), 
            [Login Admin User](#tag/identity-admin-user-v10/POST/identity/1.0/admin-users/auth/login) or 
            [Refresh Admin User Token](#tag/identity-admin-user-v10/POST/identity/1.0/admin-users/auth/refresh-token) requests. These contain a number of decodable properties (or *claims*) which make token management easier for API clients.  
            
            **Access Token Payload**
            | **Claim Key**     | **Description**     | **Format**     | **Example**     |
            |---    |---    |---    |---    |
            | u     | User ID     | UUID     | 87be56da-4dda-40a0-a955-8d5be63567cd     |
            | d     | Device ID     | UUID     | 4fd9981b-307a-46eb-b3ae-5b65ec43b609     |
            | s     | Session ID     | UUID     | 48a59d72-a58e-4f82-ad62-c401b5fa9e76     |
            | r     | User Roles     | Comma-separated list of values     | super-admin,customer-services     |
            | p     | Platform Role     | adminUser, enduser, thirdPartyAPI, etc.     | adminUser     |
            | st     | Token Status     | 0 = Active, 1 = Restricted     | 0     |
            | iat     | Issuance Timestamp     | [NumericDate](https://datatracker.ietf.org/doc/html/rfc7519#section-2) type, representing seconds     | 1749475971.5997791     |
            | exp     | Expiry Timestamp     | [NumericDate](https://datatracker.ietf.org/doc/html/rfc7519#section-2) type, representing seconds     | 1749477771.5997791     |
            
            **Refresh Token Payload**
            | **Claim Key**     | **Description**     | **Format**     | **Example**     |
            |---    |---    |---    |---    |
            | u     | User ID     | UUID     | 87be56da-4dda-40a0-a955-8d5be63567cd     |
            | d     | Device ID     | UUID     | 4fd9981b-307a-46eb-b3ae-5b65ec43b609     |
            | s     | Session ID     | UUID     | 48a59d72-a58e-4f82-ad62-c401b5fa9e76     |
            | iat     | Issuance Timestamp     | [NumericDate](https://datatracker.ietf.org/doc/html/rfc7519#section-2) type, representing seconds     | 1749475971.5997791     |
            | exp     | Expiry Timestamp     | [NumericDate](https://datatracker.ietf.org/doc/html/rfc7519#section-2) type, representing seconds     | 1749477771.5997791     |
            
            ### Device Identification Header
            
            The second factor used is a `Local Device Identifier`, provided by the client via a `X-Local-Device-Identifier` HTTP Header.  
              
            This identifier should be produced by the client themselves, and ideally stored by the client between sessions. For more information on how to produce and store your own local device identifiers, feel free to reach out to our development team. We suggest using a method already built-in to the platform from which you'll be making client calls, for example in iOS or macOS applications by using the [identifierForVendor](https://developer.apple.com/documentation/uikit/uidevice/identifierforvendor) API provided by Apple.  
              
            *Please note:* this identifier is *not the same* as the Device ID returned within Token Payloads and it is the client's responsibility to keep track of this securely. API requests made with a `Local Device Identifier` which does not match the device information used to grant the provided `Access Token` will not be authorised. 
            
            """,
                version: "1.0"
            )
            
            let servers: [OpenAPI.Server] = [
                OpenAPI.Server(url: serverUrl)
            ]
            
            let normalisedExcludedPaths = try combinedExcludedPaths.map {
                try $0.map { subComponent in
                    try subComponent.openAPIPathComponent()
                }
            }
            let document = OpenAPI.Document(
                info: info,
                servers: servers,
                paths: try getPaths(excluding: { path in
                    var matches: Bool = false
                    normalisedExcludedPaths.forEach { excludedPath in
                        if path.starts(with: excludedPath) { matches = true }
                    }
                    return matches
                }),
                components: .init(
                    securitySchemes: [
                        .init(stringLiteral: SecuritySchemeName.bearerJWT.rawValue):
                                .http(
                                    scheme: "bearer",
                                    bearerFormat: "JWT",
                                    description: "Authorization Header in JWT format with Bearer prefix"
                                ),
                        .init(stringLiteral: SecuritySchemeName.localDeviceIdentification.rawValue):
                                .apiKey(
                                    name: HTTPHeaders.Name.xLocalDeviceIdentifier.capitalized(),
                                    location: .header,
                                    description: "Local Device Identification Header"
                                )
                    ]
                ),
                security: [],
                tags: try getTags(excluding: excludedTags)
            )
            return document
        }
        
        public func getDocument(
            forCollection collection: DocumentationCollection,
            rootTitle: String,
            rootPathComponents: [PathComponent],
            rootOpenAPISubpath: [PathComponent],
            otherCollections: [DocumentationCollection]
        ) throws -> OpenAPI.Document {
//            let combinedExcludedPaths: [[PathComponent]] = excludedPaths + [pathComponents]
            //            let startTime: Double = ProcessInfo.processInfo.systemUptime
            let serverUrl = try app.kernelDI(KernelNetworking.self).resolvedHost.getLatestRecordHostURL()
            let sublinks = [
                "\n - [\(rootTitle)](/" + (rootPathComponents + rootOpenAPISubpath).map { $0.description }.joined(separator: "/") + ")"
            ] + otherCollections.map { collection in
                "\n - [" + collection.title + "]" + "(/" + (rootPathComponents + rootOpenAPISubpath + collection.collectionPath).map { $0.description }.joined(separator: "/") + ")"
            }
            let joinedSublinks = sublinks.joined(separator: "")
            let info = OpenAPI.Document.Info(
                title: collection.title,
                description:
            """
            ## Introduction
            Welcome to \(collection.title) Documentation.
            
            
            ### Futher Links
            This is a subcollection of API endpoints.
            Use the links below to navigate to other subcollections or to the home documentation page.
            \(joinedSublinks)
            """,
                version: "1.0"
            )
            
            let servers: [OpenAPI.Server] = [
                OpenAPI.Server(url: serverUrl)
            ]
            
//            let normalisedExcludedPaths = try combinedExcludedPaths.map {
//                try $0.map { subComponent in
//                    try subComponent.openAPIPathComponent()
//                }
//            }
            let document = OpenAPI.Document(
                info: info,
                servers: servers,
                paths: try getPaths(forTags: { tags in
                    var matches: Bool = false
                    tags.forEach { tag in
                        if collection.excludedTags.contains(tag) { matches = false }
                        else if collection.includedTags.contains(tag) { matches = true }
                    }
                    return matches
                }),
                components: .init(
                    securitySchemes: [
                        .init(stringLiteral: SecuritySchemeName.bearerJWT.rawValue):
                                .http(
                                    scheme: "bearer",
                                    bearerFormat: "JWT",
                                    description: "Authorization Header in JWT format with Bearer prefix"
                                ),
                        .init(stringLiteral: SecuritySchemeName.localDeviceIdentification.rawValue):
                                .apiKey(
                                    name: HTTPHeaders.Name.xLocalDeviceIdentifier.capitalized(),
                                    location: .header,
                                    description: "Local Device Identification Header"
                                )
                    ]
                ),
                security: [],
                tags: try getTags(including: collection.includedTags)
            )
            return document
        }
        
        public func initialiseCaches() throws {
            try initialiseOperationCache()
            try initialiseTagCache()
//            KernelDocumentation.logger.info("INITIALISED CACHES")
        }
        
        private func getTags(
            excluding excludedTags: [String]
        ) throws -> [OpenAPI.Tag] {
            let tags = try tagsCache.filter { tag in
                !excludedTags.contains(tag.name)
            }
            .sorted { $0.name < $1.name }
            return tags
        }
        
        private func getTags(
            including includedTags: [String]
        ) throws -> [OpenAPI.Tag] {
            let tags = try tagsCache.filter { tag in
                includedTags.contains(tag.name)
            }
                .sorted { $0.name < $1.name }
            return tags
        }
        
        public func getPaths(
            excluding predicate: ([String]) -> Bool
        ) throws -> OpenAPI.PathItem.Map {
            try withAutoRelease {
                let operations = try operationCache.values { !predicate($0.path.components) }
                let pathItemMapped: OpenAPI.PathItem.PathItemMap = operations.reduce(into: [:]) { res, next in
                    res[next.path, default: .init()][next.httpMethod] = next.operation
                }
                return pathItemMapped.mapValues { .pathItem($0) }
            }
        }
        
        public func getPaths(
            forTags predicate: ([String]) -> Bool
        ) throws -> OpenAPI.PathItem.Map {
            try withAutoRelease {
                let operations = try operationCache.values { predicate($0.operation.tags ?? []) }
                let pathItemMapped: OpenAPI.PathItem.PathItemMap = operations.reduce(into: [:]) { res, next in
                    res[next.path, default: .init()][next.httpMethod] = next.operation
                }
                return pathItemMapped.mapValues { .pathItem($0) }
            }
        }
        
        private func initialiseOperationCache() throws {
            try withAutoRelease {
                let operations = try app.routes.all
                    .map { try $0.openAPIPathOperation(using: encoder) }
                
                for operation in operations {
                    let pathOperation: OpenAPIPathOperation = .init(
                        path: operation.path,
                        httpMethod: operation.verb,
                        operation: operation.operation
                    )
                    let operationKey = "\(operation.verb.rawValue) - \(operation.path.rawValue)"
                    operationCache.set(operationKey, tag: operation.verb, value: pathOperation)
                }
            }
            
        }
        
        private func initialiseTagCache() throws {
            let tags = app.routes.openAPITags()
            for tag in tags {
                tagsCache.set(tag.name, value: tag)
            }
        }
    }
}
