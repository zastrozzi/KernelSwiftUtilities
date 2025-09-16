//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 1/5/24.
//

import Foundation
import Vapor
import KernelSwiftCommon
import Fluent

extension KernelWebFront.Services {
    public struct FlowService: DBAccessible, Sendable {
        @KernelDI.Injected(\.vapor) public var app
        public typealias FeatureContainer = KernelWebFront
        
    }
}
