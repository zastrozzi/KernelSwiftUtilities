//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/06/2024.
//

import FluentKit

public protocol KernelFluentNamespacedModel: Model, Sendable {
    associatedtype NamespacedSchemaName: KernelFluentNamespacedSchemaName
    static var namespacedSchema: NamespacedSchemaName { get }
}

extension KernelFluentNamespacedModel {
    public static var schema: String { namespacedSchema.table }
    public static var space: String? { namespacedSchema.namespace }
}
