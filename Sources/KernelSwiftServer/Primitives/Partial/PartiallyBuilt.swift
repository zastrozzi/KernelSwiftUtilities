//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/04/2023.
//

import Foundation

@propertyWrapper
public struct PartiallyBuilt<Value: PartialConvertible> {

    public var wrappedValue: Value? {
        return try? projectedValue.unwrapped()
    }

    public var projectedValue: PartialBuilder<Value>

    public init(builder: PartialBuilder<Value> = PartialBuilder<Value>()) {
        projectedValue = builder
    }

    public init(partial: Partial<Value>) {
        projectedValue = PartialBuilder(partial: partial)
    }

}
