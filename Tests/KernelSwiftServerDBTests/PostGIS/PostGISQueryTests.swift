//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/09/2024.
//

import KernelSwiftServer
import XCTest

final class PostGISQueryTests: PostGISTestCase {
    func testContains() async throws {
        let exteriorRing = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: exteriorRing, coordinateSystem: .wgs84)

        let user = UserArea(area: polygon)
        try await user.save(on: self.db)

        let testPoint = KernelFluentPostGIS.Geometric.Point2D(x: 5, y: 5, coordinateSystem: .wgs84)
        let all = try await UserArea.query(on: self.db)
            .filter(postGIS: .contains(\.$area, testPoint, .left))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testContainsReversed() async throws {
        let exteriorRing = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: exteriorRing, coordinateSystem: .wgs84)

        let testPoint = KernelFluentPostGIS.Geometric.Point2D(x: 5, y: 5, coordinateSystem: .wgs84)
        let user = UserLocation(location: testPoint)
        try await user.save(on: self.db)

        let all = try await UserLocation.query(on: self.db)
            .filter(postGIS: .contains(\.$location, polygon, .right))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testContainsWithHole() async throws {
        let exteriorRing = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let hole = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 2.5, y: 2.5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 7.5, y: 2.5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 7.5, y: 7.5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 2.5, y: 7.5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 2.5, y: 2.5, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: exteriorRing, interiorRings: [hole], coordinateSystem: .wgs84)

        let user = UserArea(area: polygon)
        try await user.save(on: self.db)

        let testPoint = KernelFluentPostGIS.Geometric.Point2D(x: 5, y: 5, coordinateSystem: .wgs84)
        let all = try await UserArea.query(on: self.db)
            .filter(postGIS: .contains(\.$area, testPoint, .left))
            .all()
        XCTAssertEqual(all.count, 0)

        let testPoint2 = KernelFluentPostGIS.Geometric.Point2D(x: 1, y: 5, coordinateSystem: .wgs84)
        let all2 = try await UserArea.query(on: self.db)
            .filter(postGIS: .contains(\.$area, testPoint2, .left))
            .all()
        XCTAssertEqual(all2.count, 1)
    }

    func testCrosses() async throws {
        let exteriorRing = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: exteriorRing, coordinateSystem: .wgs84)

        let testPath = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 15, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 5, y: 5, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)

        let user = UserArea(area: polygon)
        try await user.save(on: self.db)

        let all = try await UserArea.query(on: self.db)
            .filter(postGIS: .crosses(\.$area, testPath, .left))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testCrossesReversed() async throws {
        let exteriorRing = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: exteriorRing, coordinateSystem: .wgs84)

        let testPath = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 15, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 5, y: 5, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)

        let user = UserPath(path: testPath)
        try await user.save(on: self.db)

        let all = try await UserPath.query(on: self.db)
            .filter(postGIS: .crosses(\.$path, polygon, .right))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testDisjoint() async throws {
        let exteriorRing = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: exteriorRing, coordinateSystem: .wgs84)

        let testPath = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 15, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 11, y: 5, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)

        let user = UserArea(area: polygon)
        try await user.save(on: self.db)

        let all = try await UserArea.query(on: self.db)
            .filter(postGIS: .disjoint(\.$area, testPath, .left))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testDisjointReversed() async throws {
        let exteriorRing = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: exteriorRing, coordinateSystem: .wgs84)

        let testPath = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 15, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 11, y: 5, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)

        let user = UserPath(path: testPath)
        try await user.save(on: self.db)

        let all = try await UserPath.query(on: self.db)
            .filter(postGIS: .disjoint(\.$path, polygon, .right))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testEquals() async throws {
        let exteriorRing = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: exteriorRing, coordinateSystem: .wgs84)

        let user = UserArea(area: polygon)
        try await user.save(on: self.db)

        let all = try await UserArea.query(on: self.db)
            .filter(postGIS: .equals(\.$area, polygon))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testIntersects() async throws {
        let exteriorRing = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: exteriorRing, coordinateSystem: .wgs84)

        let testPath = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 15, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 5, y: 5, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)

        let user = UserArea(area: polygon)
        try await user.save(on: self.db)

        let all = try await UserArea.query(on: self.db)
            .filter(postGIS: .intersects(\.$area, testPath, .left))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testIntersectsReversed() async throws {
        let exteriorRing = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: exteriorRing, coordinateSystem: .wgs84)

        let testPath = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 15, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 5, y: 5, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)

        let user = UserPath(path: testPath)
        try await user.save(on: self.db)

        let all = try await UserPath.query(on: self.db)
            .filter(postGIS: .intersects(\.$path, polygon, .right))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testOverlaps() async throws {
        let testPath = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 15, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 5, y: 5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 6, y: 6, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)

        let testPath2 = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 16, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 5, y: 5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 6, y: 6, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 2, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)

        let user = UserPath(path: testPath)
        try await user.save(on: self.db)

        let all = try await UserPath.query(on: self.db)
            .filter(postGIS: .overlaps(\.$path, testPath2, .left))
//            .filterGeometryOverlaps(\.$path, testPath2)
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testOverlapsReversed() async throws {
        let testPath = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 15, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 5, y: 5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 6, y: 6, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)

        let testPath2 = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 16, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 5, y: 5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 6, y: 6, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 2, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)

        let user = UserPath(path: testPath)
        try await user.save(on: self.db)

        let all = try await UserPath.query(on: self.db)
            .filter(postGIS: .overlaps(\.$path, testPath2, .right))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testTouches() async throws {
        let testPath = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 1, y: 1, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 2, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)

        let testPoint = KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 2, coordinateSystem: .wgs84)

        let user = UserPath(path: testPath)
        try await user.save(on: self.db)

        let all = try await UserPath.query(on: self.db)
            .filter(postGIS: .touches(\.$path, testPoint, .left))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testTouchesReversed() async throws {
        let testPath = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 1, y: 1, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 2, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)

        let testPoint = KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 2, coordinateSystem: .wgs84)

        let user = UserPath(path: testPath)
        try await user.save(on: self.db)

        let all = try await UserPath.query(on: self.db)
            .filter(postGIS: .touches(\.$path, testPoint, .right))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testWithin() async throws {
        let exteriorRing = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: exteriorRing, coordinateSystem: .wgs84)
        let hole = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 2.5, y: 2.5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 7.5, y: 2.5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 7.5, y: 7.5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 2.5, y: 7.5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 2.5, y: 2.5, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon2 = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: hole, coordinateSystem: .wgs84)

        let user = UserArea(area: polygon2)
        try await user.save(on: self.db)

        let all = try await UserArea.query(on: self.db)
            .filter(postGIS: .within(\.$area, polygon, .left))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testWithinReversed() async throws {
        let exteriorRing = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 0, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 10, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 10, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 0, y: 0, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: exteriorRing, coordinateSystem: .wgs84)
        let hole = KernelFluentPostGIS.Geometric.LineString2D(points: [
            KernelFluentPostGIS.Geometric.Point2D(x: 2.5, y: 2.5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 7.5, y: 2.5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 7.5, y: 7.5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 2.5, y: 7.5, coordinateSystem: .wgs84),
            KernelFluentPostGIS.Geometric.Point2D(x: 2.5, y: 2.5, coordinateSystem: .wgs84),
        ], coordinateSystem: .wgs84)
        let polygon2 = KernelFluentPostGIS.Geometric.Polygon2D(exteriorRing: hole, coordinateSystem: .wgs84)

        let user = UserArea(area: polygon)
        try await user.save(on: self.db)

        let all = try await UserArea.query(on: self.db)
            .filter(postGIS: .within(\.$area, polygon2, .right))
            .all()
        XCTAssertEqual(all.count, 1)
    }

    func testDistanceWithin() async throws {
        let berlin = KernelFluentPostGIS.Geographic.Point2D(longitude: 13.41053, latitude: 52.52437, coordinateSystem: .wgs84)
        
        // 255 km from Berlin
        let hamburg = City(location: KernelFluentPostGIS.Geographic.Point2D(longitude: 10.01534, latitude: 53.57532, coordinateSystem: .wgs84))
        try await hamburg.save(on: self.db)
        
        // 505 km from Berlin
        let munich = City(location: KernelFluentPostGIS.Geographic.Point2D(longitude: 11.57549, latitude: 48.13743, coordinateSystem: .wgs84))
        try await munich.save(on: self.db)
        
        // 27 km from Berlin
        let potsdam = City(location: KernelFluentPostGIS.Geographic.Point2D(longitude: 13.06566, latitude: 52.39886, coordinateSystem: .wgs84))
        try await potsdam.save(on: self.db)
        
        let all = try await City.query(on: self.db)
            .filter(postGIS: .distanceWithin(\.$location, berlin, 30 * 1000, .left))
            .all()
        
        XCTAssertEqual(all.map(\.id), [potsdam].map(\.id))
    }

    func testSortByDistance() async throws {
        let berlin = KernelFluentPostGIS.Geographic.Point2D(longitude: 13.41053, latitude: 52.52437, coordinateSystem: .wgs84)

        // 255 km from Berlin
        let hamburg = City(location: KernelFluentPostGIS.Geographic.Point2D(longitude: 10.01534, latitude: 53.57532, coordinateSystem: .wgs84))
        try await hamburg.save(on: self.db)

        // 505 km from Berlin
        let munich = City(location: KernelFluentPostGIS.Geographic.Point2D(longitude: 11.57549, latitude: 48.13743, coordinateSystem: .wgs84))
        try await munich.save(on: self.db)

        // 27 km from Berlin
        let potsdam = City(location: KernelFluentPostGIS.Geographic.Point2D(longitude: 13.06566, latitude: 52.39886, coordinateSystem: .wgs84))
        try await potsdam.save(on: self.db)

        let all = try await City.query(on: self.db)
            .sort(postGIS: .distance(\.$location, berlin))
            .all()
        XCTAssertEqual(all.map(\.id), [potsdam, hamburg, munich].map(\.id))
    }
}
