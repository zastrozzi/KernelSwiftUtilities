//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/06/2024.
//

import FluentKit

extension KernelFluentModel.Audit {
    public final class DiffableModelDictionary: DatabaseInput {
        public var storage: [FieldKey: DatabaseQuery.Value] = [:]
        public let wantsUnmodifiedKeys: Bool
        
        public init(wantsUnmodifiedKeys: Bool = false) {
            self.wantsUnmodifiedKeys = wantsUnmodifiedKeys
        }

        public func set(_ value: DatabaseQuery.Value, at key: FieldKey) {
            self.storage[key] = value
        }
    }
}
