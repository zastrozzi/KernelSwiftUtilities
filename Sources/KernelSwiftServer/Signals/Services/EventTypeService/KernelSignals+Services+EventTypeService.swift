//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelSignals.Services {
    public struct EventTypeService: DBAccessible, APIModelAccessible, Sendable {
        @KernelDI.Injected(\.vapor) public var app
        public typealias FeatureContainer = KernelSignals
        
        public init() {
            Self.logInit()
        }
    }
}
