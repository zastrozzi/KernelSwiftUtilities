//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/10/2022.
//

import Foundation
import KernelSwiftCommon
import Vapor
import Yams
import OpenAPIKit30

public struct DocumentationController: RouteCollection, Sendable {
    let pathComponents: [PathComponent]
    let openAPISubpath: [PathComponent]
    let openAPISpecDescriptor: String
    let title: String
    let contentColor: KernelSwiftCommon.RGBAColor
    let excludedPaths: [[PathComponent]]
    let excludedTags: [String]
    let collections: [DocumentationCollection]

    @KernelDI.Injected(\.vapor) public var app
    
    public func boot(routes: RoutesBuilder) throws {
        let documentationRoutes = routes.grouped(pathComponents)
        
        let openAPIRoutes = documentationRoutes.typeGrouped(openAPISubpath.map { $0.typedPathComponent })
        openAPIRoutes.get(use: renderOpenAPIDocsHandler).tags("Documentation")
        openAPIRoutes
            .get(.constant(openAPISpecDescriptor + ".json"), use: getJSONDocumentHandler).tags("Documentation")
        for collection in collections {
            try openAPIRoutes.register(
                collection: CollectionController(
                    collection: collection,
                    openAPISpecDescriptor: openAPISpecDescriptor,
                    rootTitle: "Documentation Home",
                    rootPathComponents: pathComponents,
                    rootOpenAPISubpath: openAPISubpath,
                    otherCollections: collections.filter { $0.title != collection.title }
                )
            )
        }
    }
    
    public init(
        title: String,
        contentColor: KernelSwiftCommon.RGBAColor,
        pathComponents: [PathComponent] = [.constant("docs"), .constant("1.0")],
        openAPISubpath: [PathComponent] = [.constant("openapi")],
        openAPISpecDescriptor: String = "spec",
        excludedPaths: [[PathComponent]] = [],
        excludedTags: [String] = ["Documentation"],
        collections: [DocumentationCollection]
//        routes: Routes
    ) {
        self.title = title
        self.contentColor = contentColor
        self.pathComponents = pathComponents
        self.openAPISubpath = openAPISubpath
        self.openAPISpecDescriptor = openAPISpecDescriptor
        self.excludedPaths = excludedPaths + [pathComponents]
        self.excludedTags = excludedTags
        self.collections = collections
    }
    
    func renderOpenAPIDocsHandler(_ req: TypedRequest<RenderOpenAPIDocsContext>) async throws -> Response {
        let docsPath = req.url.string + "/" + openAPISpecDescriptor + ".json"
        let scalarHTML = Self.makeOpenAPIDocsScalarHTML(
            title: title,
            contentColor: contentColor,
            path: docsPath
        )
        return try await req.response.success.encode(scalarHTML)
    }
    
//    @Sendable
    func getJSONDocumentHandler(_ req: TypedRequest<GetJSONDocumentContext>) async throws -> Response {
        let encodedDocument = try withAutoRelease {
            try req.kernelDI(KernelDocumentation.self).services.openAPI.getGlobalDocument(
                title: title,
                pathComponents: pathComponents,
                openAPISubpath: openAPISubpath,
                openAPISpecDescriptor: openAPISpecDescriptor + ".json",
                excludedPaths: excludedPaths,
                excludedTags: excludedTags,
                collections: collections
            )
        }
        return try await req.response.success.encode(encodedDocument)
//        return encodedDocument
    }
    
    public struct GetYAMLDocumentContext: RouteContext {
        public init() {}
        let success: ResponseContext<String> = .success(.ok, .yaml)
    }
    
    public struct GetJSONDocumentContext: RouteContext {
        public init() {}
        let success: ResponseContext<OpenAPI.Document> = .success(.ok, .json)
    }

    public struct RenderOpenAPIDocsContext: RouteContext {
        public init() {}

        let success: ResponseContext<String> = .success(.ok, .html)
    }

}

