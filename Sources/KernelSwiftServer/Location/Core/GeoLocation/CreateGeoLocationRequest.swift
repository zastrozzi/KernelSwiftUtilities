//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/09/2024.
//

import Vapor
import KernelSwiftCommon

extension KernelLocation.Core.GeoLocation {
    public struct CreateGeoLocationRequest: OpenAPIContent {
        public var name: String
        public var point: KernelFluentPostGIS.Geometric.Point2D
        
        public init(
            name: String,
            point: KernelFluentPostGIS.Geometric.Point2D
        ) {
            self.name = name
            self.point = point
        }
    }
}
