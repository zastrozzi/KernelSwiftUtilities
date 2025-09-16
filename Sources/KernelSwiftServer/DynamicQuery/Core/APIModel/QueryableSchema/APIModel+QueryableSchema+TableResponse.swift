//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Core.APIModel.QueryableSchema {
    public struct TableResponse: OpenAPIContent, DynamicPropertyAccessible {
        public var id: UUID
        public var displayName: String
        public var tableIdentifiers: KernelDynamicQuery.Core.APIModel.TableIdentifiers
        
        public init(
            displayName: String,
            tableIdentifiers: KernelDynamicQuery.Core.APIModel.TableIdentifiers
        ) {
            self.id = tableIdentifiers.uuidHash()
            self.displayName = displayName
            self.tableIdentifiers = tableIdentifiers
        }
    }
}
