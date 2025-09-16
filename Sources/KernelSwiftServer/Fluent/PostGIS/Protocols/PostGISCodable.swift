//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import FluentKit
import Vapor

public protocol PostGISCodable: Codable, Equatable, CustomStringConvertible, Sendable {
    associatedtype GeometryType: KernelWellKnown.Geometry
    init(geometry: GeometryType)
    var geometry: GeometryType { get }
    var coordinateSystem: KernelFluentPostGIS.CoordinateSystem { get }
}

extension PostGISCodable {
    public var description: String {
        KernelWellKnown.TextEncoder().encode(geometry)
    }
}

extension PostGISCodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(Data.self)
        let decoder = KernelWellKnown.BinaryDecoder()
        print(value.copyBytes())
        let geometry: GeometryType = try decoder.decode(from: value)
        self.init(geometry: geometry)
    }

    public func encode(to encoder: Encoder) throws {
        let binaryEncoder = KernelWellKnown.BinaryEncoder(byteOrder: .littleEndian)
        let data = binaryEncoder.encode(geometry)

        var container = encoder.singleValueContainer()
        try container.encode(data)
    }
    
    public func binaryEncoded() -> Data {
        KernelWellKnown.BinaryEncoder().encode(geometry)
    }
}


//extension PostGISCodable {
//    public init(fromBinary decoder: Decoder) throws {
//        let value = try decoder.singleValueContainer().decode(Data.self)
//        let decoder = KernelWellKnown.BinaryDecoder()
//        let geometry: GeometryType = try decoder.decode(from: value)
//        self.init(geometry: geometry)
//    }
//    
//    public init(fromData data: Data) throws {
//        let decoder = KernelWellKnown.BinaryDecoder()
//        let geometry: GeometryType = try decoder.decode(from: data)
//        self.init(geometry: geometry)
//    }
//
//    public func encodeBinary(to encoder: Encoder) throws {
//        let binaryEncoder = KernelWellKnown.BinaryEncoder(byteOrder: .littleEndian)
//        let data = binaryEncoder.encode(geometry)
//
//        var container = encoder.singleValueContainer()
//        try container.encode(data)
//    }
//    
//    public func binaryEncoded() -> Data {
//        let binaryEncoder = KernelWellKnown.BinaryEncoder(byteOrder: .littleEndian)
//        let data = binaryEncoder.encode(geometry)
//        print(data.copyBytes())
//        return data
//    }
//}

// [1, 1, 0, 0, 32, 230, 16, 0, 0, 0, 0, 0, 0, 0, 0, 240, 63, 0, 0, 0, 0, 0, 0, 0, 64]
// [1, 1, 0, 0, 32, 230, 16, 0, 0, 0, 0, 0, 0, 0, 0, 240, 63, 0, 0, 0, 0, 0, 0, 0, 64]
