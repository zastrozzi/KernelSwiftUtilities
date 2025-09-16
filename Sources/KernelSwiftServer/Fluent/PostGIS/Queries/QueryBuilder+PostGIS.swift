//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 25/09/2024.
//

import PostgresKit
import FluentKit

extension QueryBuilder {
    public static func fieldPath<Field>(_ field: KeyPath<Model, Field>) -> SQLExpression where Field: QueryableProperty, Field.Model == Model {
        let path = Model.path(for: field).map(\.description).joined(separator: "_")
        return SQLColumn(path)
    }
    
    @discardableResult
    public func filter<Field, Value>(postGIS function: KernelFluentPostGIS.FilterFunction<Model, Field, Value>) -> Self where Field: QueryableProperty, Field.Model == Model {
        self.filter(postGISFunction: function.functionName(), args: function.sqlExpressions())
    }
    
    @discardableResult
    public func sort<Field, Value>(postGIS function: KernelFluentPostGIS.SortFunction<Model, Field, Value>) -> Self where Field: QueryableProperty, Field.Model == Model {
        self.sort(postGISFunction: function.functionName(), args: function.sqlExpressions())
    }
    
    public func filter(postGISFunction functionName: KernelFluentPostGIS.FunctionName, args: [SQLExpression]) -> Self {
        self.filter(.sql(SQLFunction(functionName.rawValue, args: args)))
    }
    
    public func sort(postGISFunction functionName: KernelFluentPostGIS.FunctionName, args: [SQLExpression]) -> Self {
        self.sort(.sql(SQLFunction(functionName.rawValue, args: args)))
    }
}
