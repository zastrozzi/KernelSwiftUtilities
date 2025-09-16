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
    public class BinaryDecoder {
        public var userInfo: [CodingUserInfoKey : Any] = [:]
        public var codingPath: [CodingKey] = []
        fileprivate var buffer: ByteBuffer = .init()
        fileprivate var byteOrder: ByteOrder = .littleEndian
        fileprivate var byteLength: Int = 0
        fileprivate var typeCode: UInt32 = 0
        fileprivate var pointSize: UInt8 = 2
        fileprivate var srid: UInt32 = 2

        public init() {}
    }
}

extension KernelWellKnown.BinaryDecoder {
    public enum Error: Swift.Error {
        case dataCorrupted
        case unexpectedType
        case unimplemented
    }
}

extension KernelWellKnown.BinaryDecoder {
    public func decode<T>(from data: Data) throws -> T {
        guard let value = try decode(fromBytes: [UInt8](data)) as? T else {
            throw Error.unexpectedType
        }
        return value
    }
    
    public static func decode<T>(_ type: T.Type = T.self, from data: Data) throws -> T {
        let decoder = KernelWellKnown.BinaryDecoder()
        return try decoder.decode(from: data)
    }
    
    public func decode<T: KernelWellKnown.Geometry>(from byteBuffer: ByteBuffer) throws -> T {
        self.buffer = byteBuffer
        self.byteLength = byteBuffer.readableBytes
        return try decode(srid: nil) as! T
    }
    
    public func decode<T>(from bytes: [UInt8]) throws -> T {
        guard let value = try decode(fromBytes: bytes) as? T else {
            throw Error.unexpectedType
        }
        return value
    }
}

extension KernelWellKnown.BinaryDecoder {
    private func decode(fromBytes bytes: [UInt8], srid: UInt32? = nil) throws -> any KernelWellKnown.Geometry {
        self.buffer = .init(bytes: bytes)
        self.byteLength = bytes.count
        return try decode(srid: srid)
    }

    private func decode(srid: UInt32? = nil) throws -> any KernelWellKnown.Geometry {
        let srid = srid
        guard let byteOrder: KernelWellKnown.ByteOrder = .init(rawValue: try decode(UInt8.self)) else {
            throw Error.dataCorrupted
        }
        
        self.byteOrder = byteOrder
        typeCode = try decode(UInt32.self)
        pointSize = 2
        if typeCode.and(.ieee754.bit.b0, not: .zero) { pointSize += 1 }
        if typeCode.and(.ieee754.bit.b1, not: .zero) { pointSize += 1 }
        if srid == nil {
            typeCode &= .ieee754.bit.max28bit
            self.srid = try decode(UInt32.self)
        }
        
        guard let binaryType: KernelWellKnown.BinaryTypeCode = .init(rawValue: typeCode) else { throw Error.dataCorrupted }
        return switch binaryType {
            case .point: try decode(KernelWellKnown.Point.self)
            case .lineString: try decode(KernelWellKnown.LineString.self)
            case .polygon: try decode(KernelWellKnown.Polygon.self)
            case .multiPoint: try decode(KernelWellKnown.MultiPoint.self)
            case .multiLineString: try decode(KernelWellKnown.MultiLineString.self)
            case .multiPolygon: try decode(KernelWellKnown.MultiPolygon.self)
            case .geometryCollection: try decode(KernelWellKnown.GeometryCollection.self)
        }
    }
    
    private func decode(_ type: KernelWellKnown.Point.Type) throws -> KernelWellKnown.Point {
        var vector: [Double] = []
        for _ in 0..<pointSize {
            vector.append(try decode(Double.self))
        }
        return .init(vector: vector, srid: .init(srid))
    }
    
    private func decode(_ type: KernelWellKnown.LineString.Type) throws -> KernelWellKnown.LineString {
        guard let count = try? decode(UInt32.self) else { return .init() }
        var points: [KernelWellKnown.Point] = []
        for _ in 0..<count {
            points.append(try decode(KernelWellKnown.Point.self))
        }
        return .init(points: points, srid: .init(srid))
    }
    
    private func decode(_ type: KernelWellKnown.Polygon.Type) throws -> KernelWellKnown.Polygon {
        let localSRID = srid
        let ringCount = try decode(UInt32.self)
        var rings: [KernelWellKnown.LineString] = []
        for _ in 0..<ringCount {
            rings.append(try decode(KernelWellKnown.LineString.self))
        }
        return .init(rings: rings, srid: .init(localSRID))
    }
    
    private func decode(_ type: KernelWellKnown.MultiPoint.Type) throws -> KernelWellKnown.MultiPoint {
        guard let count = try? decode(UInt32.self) else { return .init() }
        var points: [KernelWellKnown.Point] = []
        for _ in 0..<count {
            guard let point = try decode(srid: srid) as? KernelWellKnown.Point else {
                throw Error.dataCorrupted
            }
            points.append(point)
        }
        return .init(points: points, srid: .init(srid))
    }
    
    private func decode(_ type: KernelWellKnown.MultiLineString.Type) throws -> KernelWellKnown.MultiLineString {
        guard let count = try? decode(UInt32.self) else { return .init() }
        var lineStrings: [KernelWellKnown.LineString] = []
        for _ in 0..<count {
            guard let lineString = try decode(srid: srid) as? KernelWellKnown.LineString else {
                throw Error.dataCorrupted
            }
            lineStrings.append(lineString)
        }
        return .init(lineStrings: lineStrings, srid: .init(srid))
    }
    
    private func decode(_ type: KernelWellKnown.MultiPolygon.Type) throws -> KernelWellKnown.MultiPolygon {
        guard let count = try? decode(UInt32.self) else { return .init() }
        var polygons: [KernelWellKnown.Polygon] = []
        for _ in 0..<count {
            guard let polygon = try decode(srid: srid) as? KernelWellKnown.Polygon else {
                throw Error.dataCorrupted
            }
            polygons.append(polygon)
        }
        return .init(polygons: polygons, srid: .init(srid))
    }
    
    private func decode(_ type: KernelWellKnown.GeometryCollection.Type) throws -> KernelWellKnown.GeometryCollection {
        guard let count = try? decode(UInt32.self) else { return .init() }
        var geometries: [any KernelWellKnown.Geometry] = []
        for _ in 0..<count {
            let geometry = try decode(srid: srid)
            geometries.append(geometry)
        }
        return .init(geometries: geometries, srid: .init(srid))
    }
}

extension KernelWellKnown.BinaryDecoder {
    private func decode(_ type: UInt8.Type) throws -> UInt8 {
        var value: UInt8 = .init()
        try read(into: &value)
        return byteOrder == .bigEndian ? value.bigEndian : value.littleEndian
    }
    
    private func decode(_ type: UInt32.Type) throws -> UInt32 {
        var value: UInt32 = .init()
        try read(into: &value)
        return byteOrder == .bigEndian ? value.bigEndian : value.littleEndian
    }
    
    private func decode(_ type: Double.Type) throws -> Double {
        var value: UInt64 = .init()
        try read(into: &value)
        return .init(bitPattern: byteOrder == .bigEndian ? value.bigEndian : value.littleEndian)
    }
}

extension KernelWellKnown.BinaryDecoder {
    private func read<T: FixedWidthInteger>(into: inout T) throws {
        try read(MemoryLayout<T>.size, into: &into)
    }
    
    func read(_ readCount: Int, into: UnsafeMutableRawPointer) throws {
        guard buffer.readerIndex + readCount <= byteLength else {
            throw Error.dataCorrupted
        }
        buffer.readWithUnsafeReadableBytes { ptr in
            let from = ptr.baseAddress!
            memcpy(into, from, readCount)
            return readCount
        }
    }
}
