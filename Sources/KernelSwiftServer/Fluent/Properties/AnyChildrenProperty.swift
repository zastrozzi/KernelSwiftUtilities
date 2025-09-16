//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/05/2023.
//

import Foundation
import Vapor
import FluentKit

public protocol AnyChildrenProperty {
    var keys: [FieldKey] { get }
    func input(to input: DatabaseInput)
    func output(from output: DatabaseOutput) throws
    func load(on database: Database) async throws
}

extension ChildrenProperty: AnyChildrenProperty {}

extension Fields where Self: Model {
//    public var childrenProperties: [String] {
//        self.properties.compactMap { $0 as? AnyChildrenProperty }
//        return []
//    }
    
    public func loadChildrenProperties(onDB db: @escaping CRUDModel.DBAccessor) async throws -> Void {
        try await self.properties.compactMap { $0 as? AnyChildrenProperty }.asyncForEach {
            try await $0.load(on: db())
        }
    }
}
