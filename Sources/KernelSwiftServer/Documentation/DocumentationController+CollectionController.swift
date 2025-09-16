//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 03/06/2025.
//

import Foundation
import KernelSwiftCommon
import Vapor
import Yams
import OpenAPIKit30

public enum DocumentSpecType: String, Sendable {
    case json
    case yml
    
    public var pathSuffix: String {
        switch self {
        case .json: ".json"
        case .yml: ".yml"
        }
    }
}

public struct DocumentationCollection: Sendable {
    public var title: String
    public var contentColor: KernelSwiftCommon.RGBAColor
    public var collectionPath: [PathComponent]
    public var specType: DocumentSpecType
    public var includedTags: [String]
    public var excludedTags: [String]
    
    public init(
        title: String,
        contentColor: KernelSwiftCommon.RGBAColor,
        collectionPath: [PathComponent],
        specType: DocumentSpecType,
        includedTags: [String],
        excludedTags: [String] = ["Documentation"]
    ) {
        self.title = title
        self.contentColor = contentColor
        self.collectionPath = collectionPath
        self.specType = specType
        self.includedTags = includedTags
        self.excludedTags = excludedTags
    }
}

extension DocumentationController {
    public struct CollectionController: RouteCollection, Sendable {
        let collection: DocumentationCollection
        let openAPISpecDescriptor: String
        let rootTitle: String
        let rootPathComponents: [PathComponent]
        let rootOpenAPISubpath: [PathComponent]
        let otherCollections: [DocumentationCollection]
        
        @KernelDI.Injected(\.vapor) public var app
        
        public func boot(routes: RoutesBuilder) throws {
            let collectionRoutes = routes.typeGrouped(collection.collectionPath.map { $0.typedPathComponent })
            collectionRoutes.get(use: renderOpenAPIDocsHandler).tags("Documentation")
            collectionRoutes
                .get(.constant(openAPISpecDescriptor + collection.specType.pathSuffix), use: getJSONDocumentHandler).tags("Documentation")
        }
        
        func renderOpenAPIDocsHandler(_ req: TypedRequest<RenderOpenAPIDocsContext>) async throws -> Response {
            let docsPath = req.url.string + "/" + openAPISpecDescriptor + collection.specType.pathSuffix
//            print(docsPath, "DOCS PATH")
            let scalarHTML = makeOpenAPIDocsScalarHTML(
                title: collection.title,
                contentColor: collection.contentColor,
                path: docsPath
            )
            return try await req.response.success.encode(scalarHTML)
        }
        
        func getJSONDocumentHandler(_ req: TypedRequest<GetJSONDocumentContext>) async throws -> Response {
            let encodedDocument = try withAutoRelease {
                try req.kernelDI(KernelDocumentation.self).services.openAPI.getDocument(
                    forCollection: collection,
                    rootTitle: rootTitle,
                    rootPathComponents: rootPathComponents,
                    rootOpenAPISubpath: rootOpenAPISubpath,
                    otherCollections: otherCollections
                )
            }
            return try await req.response.success.encode(encodedDocument)
            //        return encodedDocument
        }
    }
}
