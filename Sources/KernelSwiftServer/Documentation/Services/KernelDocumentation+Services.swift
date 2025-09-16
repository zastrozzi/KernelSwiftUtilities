//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/06/2025.
//

extension KernelDocumentation {
    public struct Services: Sendable {
        public var openAPI: OpenAPIService
        
        public init() {
            openAPI = .init()
        }
    }
}
