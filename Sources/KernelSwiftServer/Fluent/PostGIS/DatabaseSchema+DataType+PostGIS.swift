//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import FluentKit
import SQLKit

extension DatabaseSchema.DataType {
    public static func geographicPoint2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)                 -> Self { geographicType("Point", coordinateSystem) }
    public static func geographicLineString2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)            -> Self { geographicType("LineString", coordinateSystem) }
    public static func geographicPolygon2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)               -> Self { geographicType("Polygon", coordinateSystem) }
    public static func geographicMultiPoint2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)            -> Self { geographicType("MultiPoint", coordinateSystem) }
    public static func geographicMultiLineString2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)       -> Self { geographicType("MultiLineString", coordinateSystem) }
    public static func geographicMultiPolygon2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)          -> Self { geographicType("MultiPolygon", coordinateSystem) }
    public static func geographicGeometryCollection2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)    -> Self { geographicType("GeometryCollection", coordinateSystem) }
    
    public static func geometricPoint2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)                  -> Self { geometricType("Point", coordinateSystem) }
    public static func geometricLineString2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)             -> Self { geometricType("LineString", coordinateSystem) }
    public static func geometricPolygon2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)                -> Self { geometricType("Polygon", coordinateSystem) }
    public static func geometricMultiPoint2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)             -> Self { geometricType("MultiPoint", coordinateSystem) }
    public static func geometricMultiLineString2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)        -> Self { geometricType("MultiLineString", coordinateSystem) }
    public static func geometricMultiPolygon2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)           -> Self { geometricType("MultiPolygon", coordinateSystem) }
    public static func geometricGeometryCollection2D(_ coordinateSystem: KernelFluentPostGIS.CoordinateSystem = .wgs84)     -> Self { geometricType("GeometryCollection", coordinateSystem) }
    
    
    
    static func geographicType(_ type: String, _ coordinateSystem: KernelFluentPostGIS.CoordinateSystem) -> Self {
        .sql(unsafeRaw: "geography(\(type), \(coordinateSystem.rawValue))")
    }
    
    static func geometricType(_ type: String, _ coordinateSystem: KernelFluentPostGIS.CoordinateSystem) -> Self {
        .sql(unsafeRaw: "geometry(\(type), \(coordinateSystem.rawValue))")
    }
}
