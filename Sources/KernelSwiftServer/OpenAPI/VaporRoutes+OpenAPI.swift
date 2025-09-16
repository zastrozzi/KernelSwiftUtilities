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

extension Vapor.Routes {
    public func openAPIPathItems(using encoder: JSONEncoder) throws -> OpenAPI.PathItem.Map {
        let operations = try all
            .map { try $0.openAPIPathOperation(using: encoder) }

        let operationsByPath = OpenAPIOrderedDictionary(
            grouping: operations,
            by: { $0.path }
        )

        return operationsByPath.mapValues { operations in
            var pathItem = OpenAPI.PathItem()

            for item in operations {
                pathItem[item.verb] = item.operation
            }

            return .pathItem(pathItem)
//            return pathItem
        }
    }
    
    public func openAPIPathItemsExcluding(
        using encoder: JSONEncoder,
        excluding predicate: ([PathComponent]) -> Bool
    ) throws -> OpenAPI.PathItem.Map {
        try autoreleasepool {
            let operations = try all.filter { !predicate($0.path) }
                .map { try $0.openAPIPathOperation(using: encoder) }

            let operationsByPath = OpenAPIOrderedDictionary(
                grouping: operations,
                by: { $0.path }
            )

            let mapped: OpenAPI.PathItem.Map = operationsByPath.mapValues { operations in
                var pathItem = OpenAPI.PathItem()

                for item in operations {
                    pathItem[item.verb] = item.operation
                }
                return .pathItem(pathItem)
            }
            return mapped
        }
        
    }
    
    public func openAPITags() -> [OpenAPI.Tag] {
        let allTagStrings = Set(all.flatMap { $0.openAPITags() })
        return Array(allTagStrings)
    }
}

extension OpenAPI.Tag: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(description)
    }
}

extension OpenAPI.Document: @unchecked @retroactive Sendable, @retroactive Content {}
extension OpenAPI.HttpMethod: @unchecked @retroactive Sendable {}
extension OpenAPI.Operation: @unchecked @retroactive Sendable {}
extension OpenAPI.Path: @unchecked @retroactive Sendable {}
extension OpenAPI.PathItem.Map: @unchecked @retroactive Sendable {}
extension OpenAPI.PathItem: @unchecked @retroactive Sendable {}
extension OpenAPI.Tag: @unchecked @retroactive Sendable {}

public struct OpenAPIPathOperation: Sendable {
    public var path: OpenAPI.Path
    public var httpMethod: OpenAPI.HttpMethod
    public var operation: OpenAPI.Operation
    
    public init(
        path: OpenAPI.Path,
        httpMethod: OpenAPI.HttpMethod,
        operation: OpenAPI.Operation
    ) {
        self.path = path
        self.httpMethod = httpMethod
        self.operation = operation
    }
}
