//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

extension KernelWellKnown {
    public class TextEncoder {
        public init() {}
        private var result: String = ""
    }
}

extension KernelWellKnown.TextEncoder {
    public func encode(_ value: any KernelWellKnown.Geometry) -> String {
        result = String()
        encode(value, withSrid: true)
        return result
    }
    
    private func encode(_ value: KernelWellKnown.Point, withSrid: Bool) {
        appendTypeCode(.point, for: value, srid: (withSrid ? value.srid : nil))
        append("(")
        append(string(for: value))
        append(")")
    }
    
    private func encode(_ value: KernelWellKnown.LineString, withSrid: Bool) {
        appendTypeCode(.lineString, for: value.points.first, srid: (withSrid ? value.srid : nil))
        if value.points.count > 0 {
            append(string(for: value))
        } else {
            append(" EMPTY")
        }
    }
    
    private func encode(_ value: KernelWellKnown.Polygon, withSrid: Bool) {
        appendTypeCode(.polygon, for: value.exteriorRing.points.first, srid: (withSrid ? value.srid : nil))
        if value.exteriorRing.points.count == 0 {
            append(" EMPTY")
        } else {
            append("(")
            let components = value.lineStrings.map { string(for: $0) }
            append(components.joined(separator: ", "))
            append(")")
        }
    }
    
    private func encode(_ value: KernelWellKnown.MultiPoint, withSrid: Bool) {
        appendTypeCode(.multiPoint, for: value.points.first, srid: (withSrid ? value.srid : nil))
        if value.points.count > 0 {
            append("(")
            let components = value.points.map { "(" + string(for: $0) + ")" }
            append(components.joined(separator: ", "))
            append(")")
        } else {
            append(" EMPTY")
        }
    }
    
    private func encode(_ value: KernelWellKnown.MultiLineString, withSrid: Bool) {
        appendTypeCode(.multiLineString, for: value.lineStrings.first?.points.first, srid: (withSrid ? value.srid : nil))
        if value.lineStrings.count > 0 {
            append("(")
            let components = value.lineStrings.map { string(for: $0) }
            append(components.joined(separator: ", "))
            append(")")
        } else {
            append(" EMPTY")
        }
    }
    
    private func encode(_ value: KernelWellKnown.MultiPolygon, withSrid: Bool) {
        appendTypeCode(.multiPolygon, for: value.polygons.first?.exteriorRing.points.first, srid: (withSrid ? value.srid : nil))
        if value.polygons.count > 0 {
            append("(")
            let components = value.polygons.map { string(for: $0) }
            append(components.joined(separator: ", "))
            append(")")
        } else {
            append(" EMPTY")
        }
    }
    
    private func encode(_ value: KernelWellKnown.GeometryCollection, withSrid: Bool) {
        appendTypeCode(.geometryCollection, for: nil, srid: (withSrid ? value.srid : nil))
        if value.geometries.count > 0 {
            append("(")
            value.geometries.forEach { encode($0, withSrid: false) }
            append(")")
        } else {
            append(" EMPTY")
        }
    }
    
    private func encode(_ value: any KernelWellKnown.Geometry, withSrid: Bool) {
        if let value = value as? KernelWellKnown.Point {
            encode(value, withSrid: withSrid)
        } else if let value = value as? KernelWellKnown.LineString {
            encode(value, withSrid: withSrid)
        } else if let value = value as? KernelWellKnown.Polygon {
            encode(value, withSrid: withSrid)
        } else if let value = value as? KernelWellKnown.MultiPoint {
            encode(value, withSrid: withSrid)
        } else if let value = value as? KernelWellKnown.MultiLineString {
            encode(value, withSrid: withSrid)
        } else if let value = value as? KernelWellKnown.MultiPolygon {
            encode(value, withSrid: withSrid)
        } else if let value = value as? KernelWellKnown.GeometryCollection {
            encode(value, withSrid: withSrid)
        } else {
            assertionFailure()
        }
    }
    
    private func appendTypeCode(_ typeCode: KernelWellKnown.TextTypeCode, for point: KernelWellKnown.Point? = nil, srid: UInt?) {
        var typeCode = typeCode.rawValue
        
        if let srid = srid {
            typeCode = "SRID=\(srid);" + typeCode
        }

        append(typeCode)
    }
    
    private func append(_ value: UInt32) {
        result += String(value)
    }
    
    private func append(_ value: Double) {
        result += String(value)
    }
    
    private func append(_ value: String) {
        result += value
    }
    
    private func string(for value: KernelWellKnown.Point) -> String {
        var coords: [String] = []
        coords.append(String(value.x))
        coords.append(String(value.y))
        if let z = value.z {
            coords.append(String(z))
        }
        if let m = value.m {
            coords.append(String(m))
        }
        return coords.joined(separator: " ")
    }
    
    private func string(for value: KernelWellKnown.LineString) -> String {
        var string = "("
        string += value.points.map { self.string(for: $0) }.joined(separator: ", ")
        string += ")"
        return string
    }
    
    private func string(for value: KernelWellKnown.Polygon) -> String {
        var string = "("
        string += value.lineStrings.map { self.string(for: $0) }.joined(separator: ", ")
        string += ")"
        return string
    }
    
}
