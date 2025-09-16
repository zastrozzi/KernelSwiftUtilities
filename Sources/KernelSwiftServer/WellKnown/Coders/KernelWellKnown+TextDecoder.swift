//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import Foundation

extension KernelWellKnown {
    public class TextDecoder {
        private var srid: UInt = 0
        private var scanner: Scanner = .init()
        
        public init() {}
    }
}

extension KernelWellKnown.TextDecoder {
    public enum Error: Swift.Error {
        case dataCorrupted
        case unexpectedType
        case unimplemented
    }
}

extension KernelWellKnown.TextDecoder {
    public func decode<T>(from value: String) throws -> T {
        scanner = Scanner(string: value)
        scanner.charactersToBeSkipped = CharacterSet.whitespaces
        scanner.caseSensitive = false
        srid = try scanSRID()
        guard let value = try scanGeometry() as? T else { throw Error.unexpectedType }
        return value
    }
}

extension KernelWellKnown.TextDecoder {
    private func scanSRID() throws -> UInt {
        guard
            scanner.scanString("SRID=") != nil,
            let srid: Int32 = scanner.scanInt32(),
            scanner.scanString(";") != nil
        else { throw Error.dataCorrupted }

        return UInt(srid)
    }
    
    private func scanGeometry() throws -> (any KernelWellKnown.Geometry)? {
        guard let type = scanType() else { throw Error.dataCorrupted }
        let empty = self.scanEmpty()
        
        switch type {
        case .point:
            guard let point = scanPoint() else { throw Error.dataCorrupted }
            return point
        case .lineString:
            if empty { return KernelWellKnown.LineString() }
            else {
                var points: [KernelWellKnown.Point] = []
                while let point = scanPoint() { points.append(point) }
                return KernelWellKnown.LineString(points: points)
            }
        case .polygon:
            if empty {
                return KernelWellKnown.Polygon(exteriorRing: KernelWellKnown.LineString(points:[]))
            } else {
                var lineStrings: [KernelWellKnown.LineString] = []
                while let lineString = scanLineString() {
                    lineStrings.append(lineString)
                }
                return KernelWellKnown.Polygon(exteriorRing: lineStrings.first!)
            }
        case .multiPoint:
            if empty {
                return KernelWellKnown.MultiPoint(points: [])
            } else {
                var points: [KernelWellKnown.Point] = []
                while scanner.scanString("(") != nil, let point = scanPoint() {
                    points.append(point)
                    if scanner.scanString(",") == nil { break }
                }
                return KernelWellKnown.MultiPoint(points: points)
            }
        case .multiLineString:
            if empty {
                return KernelWellKnown.MultiLineString(lineStrings: [])
            } else {
                var lineStrings: [KernelWellKnown.LineString] = []
                while let lineString = scanLineString() {
                    lineStrings.append(lineString)
                }
                return KernelWellKnown.MultiLineString(lineStrings: lineStrings)
            }
        case .multiPolygon:
            if empty {
                return KernelWellKnown.MultiPolygon(polygons: [])
            } else {
                var polygons: [KernelWellKnown.Polygon] = []
                while let polygon = scanPolygon() {
                    polygons.append(polygon)
                }
                return KernelWellKnown.MultiPolygon(polygons: polygons)
            }
        case .geometryCollection:
            if empty {
                return KernelWellKnown.GeometryCollection(geometries: [])
            } else {
                var geometries: [any KernelWellKnown.Geometry] = []
                while let geometry = try scanGeometry() {
                    geometries.append(geometry)
                    if scanner.isAtEnd || scanner.scanString(")") != nil {
                        break
                    }
                }
                return KernelWellKnown.GeometryCollection(geometries: geometries)
            }
        }
    }
}

extension KernelWellKnown.TextDecoder {
    private func scanType() -> KernelWellKnown.TextTypeCode? {
        let boundarySet = CharacterSet.whitespaces.union(CharacterSet(charactersIn: "("))
        let rawType = scanner.scanUpToCharacters(from: boundarySet)
        guard let rawType, let type: KernelWellKnown.TextTypeCode = .init(rawValue: rawType) else { return nil }
        return type
    }
    
    func scanEmpty() -> Bool {
        let scanLocation = scanner.currentIndex
        if scanner.scanString("EMPTY") != nil { return true }
        scanner.currentIndex = scanLocation
        if scanner.scanString("(") == nil { scanner.currentIndex = scanLocation }
        return false
    }
    
    func scanPoint() -> KernelWellKnown.Point? {
        var vector: [Double] = []
        
        while scanner.scanString(")") == nil
            && scanner.scanString(",") == nil,
            let number = scanner.scanDouble() {
            vector.append(number)
        }
        
        if vector.count < 2 { return nil }
        
        return .init(vector: vector)
    }
    
    func scanLineString() -> KernelWellKnown.LineString? {
        var points: [KernelWellKnown.Point] = []
        
        let _ = scanner.scanString("(")
        while let point = scanPoint() { points.append(point) }

        if points.isEmpty { return nil }
        
        return .init(points: points)
    }
    
    private func scanPolygon() -> KernelWellKnown.Polygon? {
        var lineStrings: [KernelWellKnown.LineString] = []
        
        let _ = scanner.scanString("(")
        while let lineString = scanLineString() { lineStrings.append(lineString) }
        
        if lineStrings.isEmpty { return nil }
        let interiorRings = Array(lineStrings[1...])
        return .init(exteriorRing: lineStrings.first!, interiorRings: interiorRings)
    }
}
