//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit
import Vapor

extension KernelFluentPostGIS.Geographic {
    public struct GeometryCollection2D: PostGISCodable, PostGISCollectable, OpenAPIContent {
        public typealias GeometryType = KernelWellKnown.GeometryCollection
        
        
        public let geometries: CategorisedCollection
        public let coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        
        public init(
            geometries: CategorisedCollection,
            coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        ) {
            self.geometries = geometries
            self.coordinateSystem = coordinateSystem
        }
        
        public init(geometry: GeometryType) {
            self.geometries = .init(from: geometry.geometries)
            self.coordinateSystem = .init(rawValue: geometry.srid)
        }
        
        public init(
            from collectables: [any PostGISCollectable],
            coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        ) {
            self.init(geometries: .init(from: collectables), coordinateSystem: coordinateSystem)
        }
        
        public var geometry: GeometryType {
            .init(geometries: geometries.allGeometries.map(\.baseGeometry), srid: coordinateSystem.rawValue)
        }

        public enum CodingKeys: String, CodingKey {
            case geometries
            case coordinateSystem
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.geometries = try container.decode(CategorisedCollection.self, forKey: .geometries)
            self.coordinateSystem = try container.decode(KernelFluentPostGIS.CoordinateSystem.self, forKey: .coordinateSystem)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(geometries, forKey: .geometries)
            try container.encode(coordinateSystem, forKey: .coordinateSystem)
        }
        
        public static var sample: KernelFluentPostGIS.Geographic.GeometryCollection2D {
            .init(
                geometries: .init(
                    points: [.sample],
                    lineStrings: [
                        .init(points: [.sample, .sample], coordinateSystem: .wgs84)
                    ]
                ),
                coordinateSystem: .wgs84
            )
        }
    }
}

extension KernelFluentPostGIS.Geographic.GeometryCollection2D {
    public struct CategorisedCollection: OpenAPIContent {
        public var points: [KernelFluentPostGIS.Geographic.Point2D]?
        public var lineStrings: [KernelFluentPostGIS.Geographic.LineString2D]?
        public var polygons: [KernelFluentPostGIS.Geographic.Polygon2D]?
        public var multiPoints: [KernelFluentPostGIS.Geographic.MultiPoint2D]?
        public var multiLineStrings: [KernelFluentPostGIS.Geographic.MultiLineString2D]?
        public var multiPolygons: [KernelFluentPostGIS.Geographic.MultiPolygon2D]?
        public var geometryCollections: [KernelFluentPostGIS.Geographic.GeometryCollection2D]?
        
        public init(
            points: [KernelFluentPostGIS.Geographic.Point2D]? = nil,
            lineStrings: [KernelFluentPostGIS.Geographic.LineString2D]? = nil,
            polygons: [KernelFluentPostGIS.Geographic.Polygon2D]? = nil,
            multiPoints: [KernelFluentPostGIS.Geographic.MultiPoint2D]? = nil,
            multiLineStrings: [KernelFluentPostGIS.Geographic.MultiLineString2D]? = nil,
            multiPolygons: [KernelFluentPostGIS.Geographic.MultiPolygon2D]? = nil,
            geometryCollections: [KernelFluentPostGIS.Geographic.GeometryCollection2D]? = nil
        ) {
            self.points = points
            self.lineStrings = lineStrings
            self.polygons = polygons
            self.multiPoints = multiPoints
            self.multiLineStrings = multiLineStrings
            self.multiPolygons = multiPolygons
            self.geometryCollections = geometryCollections
        }
        
        public init(from typeCollection: [any KernelWellKnown.Geometry]) {
            var points: [KernelFluentPostGIS.Geographic.Point2D] = []
            var lineStrings: [KernelFluentPostGIS.Geographic.LineString2D] = []
            var polygons: [KernelFluentPostGIS.Geographic.Polygon2D] = []
            var multiPoints: [KernelFluentPostGIS.Geographic.MultiPoint2D] = []
            var multiLineStrings: [KernelFluentPostGIS.Geographic.MultiLineString2D] = []
            var multiPolygons: [KernelFluentPostGIS.Geographic.MultiPolygon2D] = []
            var geometryCollections: [KernelFluentPostGIS.Geographic.GeometryCollection2D] = []
            
            typeCollection.forEach {
                if let value = $0 as? KernelFluentPostGIS.Geographic.Point2D.GeometryType {
                    points.append(.init(geometry: value))
                }
                else if let value = $0 as? KernelFluentPostGIS.Geographic.LineString2D.GeometryType {
                    lineStrings.append(.init(geometry: value))
                }
                else if let value = $0 as? KernelFluentPostGIS.Geographic.Polygon2D.GeometryType {
                    polygons.append(.init(geometry: value))
                }
                else if let value = $0 as? KernelFluentPostGIS.Geographic.MultiPoint2D.GeometryType {
                    multiPoints.append(.init(geometry: value))
                }
                else if let value = $0 as? KernelFluentPostGIS.Geographic.MultiLineString2D.GeometryType {
                    multiLineStrings.append(.init(geometry: value))
                }
                else if let value = $0 as? KernelFluentPostGIS.Geographic.MultiPolygon2D.GeometryType {
                    multiPolygons.append(.init(geometry: value))
                }
                else if let value = $0 as? KernelFluentPostGIS.Geographic.GeometryCollection2D.GeometryType {
                    geometryCollections.append(.init(geometry: value))
                }
            }
            self.init(
                points: points.isEmpty ? nil : points,
                lineStrings: lineStrings.isEmpty ? nil : lineStrings,
                polygons: polygons.isEmpty ? nil : polygons,
                multiPoints: multiPoints.isEmpty ? nil : multiPoints,
                multiLineStrings: multiLineStrings.isEmpty ? nil : multiLineStrings,
                multiPolygons: multiPolygons.isEmpty ? nil : multiPolygons,
                geometryCollections: geometryCollections.isEmpty ? nil : geometryCollections
            )
        }
        
        public init(from collectables: [any PostGISCollectable]) {
            self.init(from: collectables.map { $0.baseGeometry })
        }
        
        public var allGeometries: [any PostGISCollectable] {
            var collection: [any PostGISCollectable] = []
            if let points { collection.append(contentsOf: points) }
            if let lineStrings { collection.append(contentsOf: lineStrings) }
            if let polygons { collection.append(contentsOf: polygons) }
            if let multiPoints { collection.append(contentsOf: multiPoints) }
            if let multiLineStrings { collection.append(contentsOf: multiLineStrings) }
            if let geometryCollections { collection.append(contentsOf: geometryCollections) }
            return collection
        }
    }
}
