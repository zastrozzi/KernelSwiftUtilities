//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/04/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelGoogleCloud.Services {
    public struct StorageObjectService: DBAccessible, Sendable {
        @KernelDI.Injected(\.vapor) public var app
        public typealias FeatureContainer = KernelGoogleCloud
        
        public init() {
            Self.logInit()
        }
    }
}
