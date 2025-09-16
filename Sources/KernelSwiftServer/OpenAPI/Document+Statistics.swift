//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import OpenAPIKit30

extension OpenAPI.Document {
    public func endpointCount() -> Int {
        paths.reduce(into: 0, { acc, next in
            acc += next.value.pathItemValue?.endpoints.count ?? 0
        })
    }
}
