//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit
import Vapor

extension KernelFluentPostGIS.Geometric {
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
//            print("GEOMETRY COLLECTION \(coordinateSystem)")
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
        
        public static func == (
            lhs: KernelFluentPostGIS.Geometric.GeometryCollection2D,
            rhs: KernelFluentPostGIS.Geometric.GeometryCollection2D
        ) -> Bool {
            guard lhs.geometries.allGeometries.count == rhs.geometries.allGeometries.count else { return false }
            for i in 0..<lhs.geometries.allGeometries.count {
                guard lhs.geometries.allGeometries[i].isEqual(to: rhs.geometries.allGeometries[i]) else { return false }
            }
            return true
        }
    }
}

extension KernelFluentPostGIS.Geometric.GeometryCollection2D {
    public struct CategorisedCollection: OpenAPIContent {
        public var points: [KernelFluentPostGIS.Geometric.Point2D]?
        public var lineStrings: [KernelFluentPostGIS.Geometric.LineString2D]?
        public var polygons: [KernelFluentPostGIS.Geometric.Polygon2D]?
        public var multiPoints: [KernelFluentPostGIS.Geometric.MultiPoint2D]?
        public var multiLineStrings: [KernelFluentPostGIS.Geometric.MultiLineString2D]?
        public var multiPolygons: [KernelFluentPostGIS.Geometric.MultiPolygon2D]?
//        public var geometryCollections: [KernelFluentPostGIS.Geometric.GeometryCollection2D]?
        
        public init(
            points: [KernelFluentPostGIS.Geometric.Point2D]? = nil,
            lineStrings: [KernelFluentPostGIS.Geometric.LineString2D]? = nil,
            polygons: [KernelFluentPostGIS.Geometric.Polygon2D]? = nil,
            multiPoints: [KernelFluentPostGIS.Geometric.MultiPoint2D]? = nil,
            multiLineStrings: [KernelFluentPostGIS.Geometric.MultiLineString2D]? = nil,
            multiPolygons: [KernelFluentPostGIS.Geometric.MultiPolygon2D]? = nil
//            geometryCollections: [KernelFluentPostGIS.Geometric.GeometryCollection2D]? = nil
        ) {
            self.points = points
            self.lineStrings = lineStrings
            self.polygons = polygons
            self.multiPoints = multiPoints
            self.multiLineStrings = multiLineStrings
            self.multiPolygons = multiPolygons
//            self.geometryCollections = geometryCollections
        }
        
        public init(from geometries: [any KernelWellKnown.Geometry]) {
            var points: [KernelFluentPostGIS.Geometric.Point2D] = []
            var lineStrings: [KernelFluentPostGIS.Geometric.LineString2D] = []
            var polygons: [KernelFluentPostGIS.Geometric.Polygon2D] = []
            var multiPoints: [KernelFluentPostGIS.Geometric.MultiPoint2D] = []
            var multiLineStrings: [KernelFluentPostGIS.Geometric.MultiLineString2D] = []
            var multiPolygons: [KernelFluentPostGIS.Geometric.MultiPolygon2D] = []
//            var geometryCollections: [KernelFluentPostGIS.Geometric.GeometryCollection2D] = []
            
            geometries.forEach {
                if let value = $0 as? KernelFluentPostGIS.Geometric.Point2D.GeometryType {
                    points.append(.init(geometry: value))
                }
                else if let value = $0 as? KernelFluentPostGIS.Geometric.LineString2D.GeometryType {
                    lineStrings.append(.init(geometry: value))
                }
                else if let value = $0 as? KernelFluentPostGIS.Geometric.Polygon2D.GeometryType {
                    polygons.append(.init(geometry: value))
                }
                else if let value = $0 as? KernelFluentPostGIS.Geometric.MultiPoint2D.GeometryType {
                    multiPoints.append(.init(geometry: value))
                }
                else if let value = $0 as? KernelFluentPostGIS.Geometric.MultiLineString2D.GeometryType {
                    multiLineStrings.append(.init(geometry: value))
                }
                else if let value = $0 as? KernelFluentPostGIS.Geometric.MultiPolygon2D.GeometryType {
                    multiPolygons.append(.init(geometry: value))
                }
//                else if let value = $0 as? KernelFluentPostGIS.Geometric.GeometryCollection2D.GeometryType {
//                    geometryCollections.append(.init(geometry: value))
//                }
            }
            self.init(
                points: points.isEmpty ? nil : points,
                lineStrings: lineStrings.isEmpty ? nil : lineStrings,
                polygons: polygons.isEmpty ? nil : polygons,
                multiPoints: multiPoints.isEmpty ? nil : multiPoints,
                multiLineStrings: multiLineStrings.isEmpty ? nil : multiLineStrings,
                multiPolygons: multiPolygons.isEmpty ? nil : multiPolygons
//                geometryCollections: geometryCollections.isEmpty ? nil : geometryCollections
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
            if let multiPolygons { collection.append(contentsOf: multiPolygons) }
//            if let geometryCollections { collection.append(contentsOf: geometryCollections) }
            return collection
        }
        
        public enum CodingKeys: String, CodingKey {
            case points
            case lineStrings
            case polygons
            case multiPoints
            case multiLineStrings
            case multiPolygons
//            case geometryCollections
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            points = try container.decodeIfPresent([KernelFluentPostGIS.Geometric.Point2D].self, forKey: .points)
            lineStrings = try container.decodeIfPresent([KernelFluentPostGIS.Geometric.LineString2D].self, forKey: .lineStrings)
            polygons = try container.decodeIfPresent([KernelFluentPostGIS.Geometric.Polygon2D].self, forKey: .polygons)
            multiPoints = try container.decodeIfPresent([KernelFluentPostGIS.Geometric.MultiPoint2D].self, forKey: .multiPoints)
            multiPolygons = try container.decodeIfPresent([KernelFluentPostGIS.Geometric.MultiPolygon2D].self, forKey: .multiPolygons)
//            geometryCollections = try container.decodeIfPresent([KernelFluentPostGIS.Geometric.GeometryCollection2D].self, forKey: .geometryCollections)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(points, forKey: .points)
            try container.encodeIfPresent(lineStrings, forKey: .lineStrings)
            try container.encodeIfPresent(polygons, forKey: .polygons)
            try container.encodeIfPresent(multiPoints, forKey: .multiPoints)
            try container.encodeIfPresent(multiLineStrings, forKey: .multiLineStrings)
            try container.encodeIfPresent(multiPolygons, forKey: .multiPolygons)
//            try container.encodeIfPresent(geometryCollections, forKey: .geometryCollections)
        }
    }
}
