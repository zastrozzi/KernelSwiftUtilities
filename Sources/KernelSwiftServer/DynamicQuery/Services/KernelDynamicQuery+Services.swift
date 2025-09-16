//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/02/2025.
//

extension KernelDynamicQuery {
    public struct Services: Sendable {
        public var query: QueryService
        public var schema: SchemaService
        
        public init() {
            self.query = .init()
            self.schema = .init()
        }
    }
}
