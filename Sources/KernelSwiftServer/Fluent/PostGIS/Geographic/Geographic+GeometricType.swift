//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 03/10/2024.
//

import KernelSwiftCommon
import FluentKit
import Vapor

extension KernelFluentPostGIS.Geographic {
    public enum GeometricType: Decodable, Encodable {
        case point2d(Point2D)
        case lineString2d(LineString2D)
        case polygon2d(Polygon2D)
        case multiPoint2d(MultiPoint2D)
        case multiLineString2d(MultiLineString2D)
        case multiPolygon2d(MultiPolygon2D)
        case geometryCollection2d(GeometryCollection2D)
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let value = try? container.decode(Point2D.self) { self = .point2d(value) }
            else if let value = try? container.decode(LineString2D.self) { self = .lineString2d(value) }
            else if let value = try? container.decode(Polygon2D.self) { self = .polygon2d(value) }
            else if let value = try? container.decode(MultiPoint2D.self) { self = .multiPoint2d(value) }
            else if let value = try? container.decode(MultiLineString2D.self) { self = .multiLineString2d(value) }
            else if let value = try? container.decode(MultiPolygon2D.self) { self = .multiPolygon2d(value) }
            else if let value = try? container.decode(GeometryCollection2D.self) { self = .geometryCollection2d(value) }
            else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown GeographicType") }
        }
        
        public init(from collectable: any PostGISCollectable) throws {
            if let collectableType = collectable as? Point2D { self = .point2d(collectableType) }
            else if let collectableType = collectable as? LineString2D { self = .lineString2d(collectableType) }
            else if let collectableType = collectable as? Polygon2D { self = .polygon2d(collectableType) }
            else if let collectableType = collectable as? MultiPoint2D { self = .multiPoint2d(collectableType) }
            else if let collectableType = collectable as? MultiLineString2D { self = .multiLineString2d(collectableType) }
            else if let collectableType = collectable as? MultiPolygon2D { self = .multiPolygon2d(collectableType) }
            else if let collectableType = collectable as? GeometryCollection2D { self = .geometryCollection2d(collectableType) }
            else { throw Abort(.unprocessableEntity) }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .point2d(let value): try container.encode(value)
            case .lineString2d(let value): try container.encode(value)
            case .polygon2d(let value): try container.encode(value)
            case .multiPoint2d(let value): try container.encode(value)
            case .multiLineString2d(let value): try container.encode(value)
            case .multiPolygon2d(let value): try container.encode(value)
            case .geometryCollection2d(let value): try container.encode(value)
            }
        }
        
        public func toPostGISCollectable() -> any PostGISCollectable {
            switch self {
            case .point2d(let value): return value
            case .lineString2d(let value): return value
            case .polygon2d(let value): return value
            case .multiPoint2d(let value): return value
            case .multiLineString2d(let value): return value
            case .multiPolygon2d(let value): return value
            case .geometryCollection2d(let value): return value
            }
        }
    }
    
    public enum GeometricTypeCategory: String, Decodable, Encodable, CodingKey {
        case points
        case lineStrings
        case polygons
        case multiPoints
        case multiLineStrings
        case multiPolygons
        case geometryCollections
    }
}
