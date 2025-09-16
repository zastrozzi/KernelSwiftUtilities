//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import Foundation
import NIOCore

extension KernelWellKnown {
    public class BinaryEncoder {
        fileprivate let byteOrder: ByteOrder
        fileprivate var buffer: ByteBuffer = .init()
        
        public init(
            byteOrder: ByteOrder = .bigEndian
        ) {
            self.byteOrder = byteOrder
        }
    }
}

extension KernelWellKnown.BinaryEncoder {
    public enum Error: Swift.Error {
        case dataCorrupted
        case unexpectedType(Any.Type)
    }
}

extension KernelWellKnown.BinaryEncoder {
    public func encode(_ value: any KernelWellKnown.Geometry) -> Data {
        buffer.clear()
        encode(value, withSrid: true)
        return buffer.getData(at: buffer.readableBytesView.startIndex, length: buffer.readableBytesView.count)!
    }
    
    public func encodeBytes(_ value: any KernelWellKnown.Geometry) -> [UInt8] {
        buffer.clear()
        encode(value, withSrid: true)
        return buffer.getBytes(at: buffer.readableBytesView.startIndex, length: buffer.readableBytesView.count)!
    }
}

extension KernelWellKnown.BinaryEncoder {
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

    private func encode(_ value: KernelWellKnown.Point, withSrid: Bool) {
        writeByteOrder()
        writeTypeCode(.point, for: value, srid: withSrid ? value.srid : nil)
        write(value)
    }
    
    private func encode(_ value: KernelWellKnown.LineString, withSrid: Bool) {
        writeByteOrder()
        writeTypeCode(.lineString, for: value.points.first, srid: withSrid ? value.srid : nil)
        if value.points.count > 0 { write(value) }
    }

    private func encode(_ value: KernelWellKnown.Polygon, withSrid: Bool) {
        writeByteOrder()
        writeTypeCode(.polygon, for: value.exteriorRing.points.first, srid: withSrid ? value.srid : nil)
        write(value)
    }
    
    private func encode(_ value: KernelWellKnown.MultiPoint, withSrid: Bool) {
        writeByteOrder()
        writeTypeCode(.multiPoint, for: value.points.first, srid: withSrid ? value.srid : nil)
        if value.points.count > 0 { write(value) }
    }
    
    private func encode(_ value: KernelWellKnown.MultiLineString, withSrid: Bool) {
        writeByteOrder()
        writeTypeCode(.multiLineString, for: value.lineStrings.first?.points.first, srid: withSrid ? value.srid : nil)
        if !value.lineStrings.isEmpty { write(value) }
    }
    
    private func encode(_ value: KernelWellKnown.MultiPolygon, withSrid: Bool) {
        writeByteOrder()
        writeTypeCode(.multiPolygon, for: value.polygons.first?.exteriorRing.points.first, srid: withSrid ? value.srid : nil)
        if !value.polygons.isEmpty { write(value) }
    }
    
    private func encode(_ value: KernelWellKnown.GeometryCollection, withSrid: Bool) {
        writeByteOrder()
        writeTypeCode(.geometryCollection, srid: withSrid ? value.srid : nil)
        if !value.geometries.isEmpty { write(value) }
    }
}

extension KernelWellKnown.BinaryEncoder {
    private func write(_ value: KernelWellKnown.Point) {
        write(value.x)
        write(value.y)
        if let z = value.z { write(z) }
        if let m = value.m { write(m) }
    }
    
    private func write(_ value: KernelWellKnown.LineString) {
        write(UInt32(value.points.count))
        for point in value.points { write(point) }
    }
    
    private func write(_ value: KernelWellKnown.Polygon) {
        if value.exteriorRing.points.isEmpty {
            write(UInt32(0))
        } else {
            write(UInt32(1 + value.interiorRings.count))
            write(value.exteriorRing)
            for ring in value.interiorRings { write(ring) }
        }
    }
    
    private func write(_ value: KernelWellKnown.MultiPoint) {
        write(UInt32(value.points.count))
        for point in value.points { encode(point, withSrid: false) }
    }
    
    private func write(_ value: KernelWellKnown.MultiLineString) {
        write(UInt32(value.lineStrings.count))
        for lineString in value.lineStrings { encode(lineString, withSrid: false) }
    }
    
    private func write(_ value: KernelWellKnown.MultiPolygon) {
        write(UInt32(value.polygons.count))
        for polygon in value.polygons { encode(polygon, withSrid: false) }
    }
    
    private func write(_ value: KernelWellKnown.GeometryCollection) {
        write(UInt32(value.geometries.count))
        for geometry in value.geometries { encode(geometry, withSrid: false) }
    }
}

extension KernelWellKnown.BinaryEncoder {
    private func writeByteOrder() {
        writeBytes(of: byteOrder == .bigEndian ? byteOrder.rawValue.bigEndian : byteOrder.rawValue.littleEndian)
    }
    
    private func writeTypeCode(_ typeCode: KernelWellKnown.BinaryTypeCode, for point: KernelWellKnown.Point? = nil, srid: UInt?) {
        var typeCode = typeCode.rawValue
        if point?.z != nil { typeCode |= .ieee754.bit.b0 }
        if point?.m != nil { typeCode |= .ieee754.bit.b1 }
        if srid != nil { typeCode |= .ieee754.bit.b2 }
        write(typeCode)
        if let srid { write(UInt32(srid)) }
    }
}

extension KernelWellKnown.BinaryEncoder {
    private func write(_ value: UInt32) {
        writeBytes(of: byteOrder == .bigEndian ? value.bigEndian : value.littleEndian)
    }
    
    public func write(_ value: Double) {
        writeBytes(of: byteOrder == .bigEndian ? value.bitPattern.bigEndian : value.bitPattern.littleEndian)
    }
    
    private func writeBytes<T>(of value: T) {
        var value = value
        let _ = withUnsafeBytes(of: &value) { ptr in
            buffer.writeBytes(ptr)
        }
    }
}
