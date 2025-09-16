//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/10/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelLocation.Services {
    public struct GeoLocationService: DBAccessible, Sendable {
        @KernelDI.Injected(\.vapor) public var app
        public typealias FeatureContainer = KernelLocation
    }
}
