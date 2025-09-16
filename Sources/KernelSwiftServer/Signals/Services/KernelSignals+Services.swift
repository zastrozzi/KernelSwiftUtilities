//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

extension KernelSignals {
    public struct Services: Sendable {
        public var event: EventService
        public var eventType: EventTypeService
        
        public init() {
            event = .init()
            eventType = .init()
        }
    }
}
