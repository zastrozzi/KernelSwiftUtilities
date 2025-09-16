//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 25/09/2024.
//

import Testing
import KernelSwiftServer

@Suite
struct WellKnownBinaryCodingByteTests {
    
    var encoder: KernelWellKnown.BinaryEncoder = .init()
    var decoder: KernelWellKnown.BinaryDecoder = .init()

    @Test
    func testPoint2D() throws {
        for _ in 0..<100000 {
            let value = KernelWellKnown.Point(vector: [1, 2])
            let bytes = encoder.encodeBytes(value)
            let value2: KernelWellKnown.Point = try decoder.decode(from: bytes)
            #expect(value == value2)
        }
    }

    @Test
    func testPoint3D() throws {
        let value = KernelWellKnown.Point(vector: [1, 2, 3])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.Point = try decoder.decode(from: bytes)
        #expect(value == value2)
    }

    @Test
    func testPoint4D() throws {
        let value = KernelWellKnown.Point(vector: [1, 2, 3, 4])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.Point = try decoder.decode(from: bytes)
        #expect(value == value2)
    }

    @Test
    func testLineStringEmpty() throws {
        let value = KernelWellKnown.LineString(points: [])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.LineString = try decoder.decode(from: bytes)
        #expect(value == value2)
    }

    @Test
    func testLineString2D() throws {
        let value = KernelWellKnown.LineString(points: [
            KernelWellKnown.Point(vector: [1, 2]),
            KernelWellKnown.Point(vector: [2, 3]),
        ])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.LineString = try decoder.decode(from: bytes)
        #expect(value == value2)
    }

    @Test
    func testLineString3D() throws {
        let value = KernelWellKnown.LineString(points: [
            KernelWellKnown.Point(vector: [1, 2, 3]),
            KernelWellKnown.Point(vector: [4, 5, 6]),
        ])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.LineString = try decoder.decode(from: bytes)
        #expect(value == value2)
    }

    @Test
    func testLineString4D() throws {
        let value = KernelWellKnown.LineString(points: [
            KernelWellKnown.Point(vector: [1, 2, 3, 4]),
            KernelWellKnown.Point(vector: [5, 6, 7, 8]),
        ])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.LineString = try decoder.decode(from: bytes)
        #expect(value == value2)
    }

    @Test
    func testPolygonEmpty() throws {
        let value = KernelWellKnown.Polygon(
            exteriorRing: KernelWellKnown.LineString(points: []))
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.Polygon = try decoder.decode(from: bytes)
        #expect(value == value2)
    }

    @Test
    func testPolygon() throws {
        let lineString = KernelWellKnown.LineString(points: [
            KernelWellKnown.Point(vector: [1, 2]),
            KernelWellKnown.Point(vector: [3, 4]),
            KernelWellKnown.Point(vector: [6, 5]),
            KernelWellKnown.Point(vector: [1, 2]),
        ])
        let value = KernelWellKnown.Polygon(exteriorRing: lineString)
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.Polygon = try decoder.decode(from: bytes)
        #expect(value == value2)
    }

    @Test
    func testMultiPointEmpty() throws {
        let value = KernelWellKnown.MultiPoint(points: [])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.MultiPoint = try decoder.decode(from: bytes)
        #expect(value == value2)
    }

    @Test
    func testMultiPoint() throws {
        let value = KernelWellKnown.MultiPoint(points: [
            KernelWellKnown.Point(vector: [1, 2]),
            KernelWellKnown.Point(vector: [2, 3]),
        ])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.MultiPoint = try decoder.decode(from: bytes)
        #expect(value == value2)
    }

    @Test
    func testMultiLineStringEmpty() throws {
        let value = KernelWellKnown.MultiLineString(lineStrings: [])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.MultiLineString = try decoder.decode(
            from: bytes)
        #expect(value == value2)
    }

    @Test
    func testMultiLineString() throws {
        let value = KernelWellKnown.MultiLineString(lineStrings: [
            KernelWellKnown.LineString(points: [
                KernelWellKnown.Point(vector: [1, 2]),
                KernelWellKnown.Point(vector: [2, 3]),
            ]),
            KernelWellKnown.LineString(points: [
                KernelWellKnown.Point(vector: [4, 5]),
                KernelWellKnown.Point(vector: [6, 7]),
            ]),
        ])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.MultiLineString = try decoder.decode(
            from: bytes)
        #expect(value == value2)
    }

    @Test
    func testMultiPolygonEmpty() throws {
        let value = KernelWellKnown.MultiLineString(lineStrings: [])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.MultiLineString = try decoder.decode(
            from: bytes)
        #expect(value == value2)
    }

    @Test
    func testMultiPolygon() throws {
        for _ in 0..<100000 {
            let lineString = KernelWellKnown.LineString(points: [
                KernelWellKnown.Point(vector: [1, 2]),
                KernelWellKnown.Point(vector: [3, 4]),
                KernelWellKnown.Point(vector: [6, 5]),
                KernelWellKnown.Point(vector: [1, 2]),
            ])
            let polygon = KernelWellKnown.Polygon(exteriorRing: lineString)
            let lineString2 = KernelWellKnown.LineString(points: [
                KernelWellKnown.Point(vector: [1, 2]),
                KernelWellKnown.Point(vector: [3, 4]),
                KernelWellKnown.Point(vector: [6, 5]),
                KernelWellKnown.Point(vector: [1, 2]),
            ])
            let polygon2 = KernelWellKnown.Polygon(exteriorRing: lineString2)
            let value = KernelWellKnown.MultiPolygon(polygons: [polygon, polygon2])
            let bytes = encoder.encodeBytes(value)
            let value2: KernelWellKnown.MultiPolygon = try decoder.decode(
                from: bytes)
            #expect(value == value2)
        }
    }

    @Test
    func testGeometryCollectionEmpty() throws {
        let value = KernelWellKnown.GeometryCollection(geometries: [])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.GeometryCollection = try decoder.decode(
            from: bytes)
        #expect(value == value2)
    }

    @Test
    func testGeometryCollection() throws {
        let value = KernelWellKnown.GeometryCollection(geometries: [
            KernelWellKnown.Point(vector: [1, 2])
        ])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.GeometryCollection = try decoder.decode(
            from: bytes)
        #expect(value == value2)
    }

    @Test
    func testGeometryCollectionLineString() throws {
        let value = KernelWellKnown.GeometryCollection(geometries: [
            KernelWellKnown.LineString(points: [
                KernelWellKnown.Point(vector: [1, 2]),
                KernelWellKnown.Point(vector: [2, 3]),
            ])
        ])
        let bytes = encoder.encodeBytes(value)
        let value2: KernelWellKnown.GeometryCollection = try decoder.decode(
            from: bytes)
        #expect(value == value2)
    }
}
