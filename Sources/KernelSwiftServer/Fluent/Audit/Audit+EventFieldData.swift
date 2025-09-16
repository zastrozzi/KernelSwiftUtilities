//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/06/2024.
//

import FluentKit

extension KernelFluentModel.Audit {
    
    public struct EventFieldData: Codable, Equatable, Sendable {
        public var previous: DatabaseQuery.Value
        public var next: DatabaseQuery.Value
        
        public init(
            previous: DatabaseQuery.Value,
            next: DatabaseQuery.Value
        ) {
            self.previous = previous
            self.next = next
        }
    }
}
