//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/09/2024.
//

import KernelSwiftServer
import XCTest

final class PostGISGeometryTests: PostGISTestCase {
    func testPoint() async throws {
        let point = KernelFluentPostGIS.Geometric.Point2D(x: 1, y: 2, coordinateSystem: .wgs84)
        
        let user = UserLocation(location: point)
        try await user.save(on: self.db)
        
        let fetched = try await UserLocation.find(1, on: self.db)
        XCTAssertEqual(fetched?.location, point)
        
        let all = try await UserLocation.query(on: self.db)
            .filter(postGIS: .distanceWithin(\.$location, user.location, 1000, .left))
            .all()
        XCTAssertEqual(all.count, 1)
        
    }

    func testLineString() async throws {
        let point = KernelFluentPostGIS.Geometric.Point2D(x: 1, y: 2, coordinateSystem: .wgs84)
        let point2 = KernelFluentPostGIS.Geometric.Point2D(x: 2, y: 3, coordinateSystem: .wgs84)
        let point3 = KernelFluentPostGIS.Geometric.Point2D(x: 3, y: 2, coordinateSystem: .wgs84)
        let lineString = KernelFluentPostGIS.Geometric.LineString2D(points: [point, point2, point3, point], coordinateSystem: .wgs84)

        let user = UserPath(path: lineString)
        try await user.save(on: self.db)

        let fetched = try await UserPath.find(1, on: self.db)
        XCTAssertEqual(fetched?.path, lineString)
    }

    func testPolygon() async throws {
        let point = KernelFluentPostGIS.Geometric.Point2D(x: 1, y: 2, coordinateSystem: .wgs84)
        let point2 = KernelFluentPostGIS.Geometric.Point2D(x: 2, y: 3, coordinateSystem: .wgs84)
        let point3 = KernelFluentPostGIS.Geometric.Point2D(x: 3, y: 2, coordinateSystem: .wgs84)
        let lineString = KernelFluentPostGIS.Geometric.LineString2D(points: [point, point2, point3, point], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(
            exteriorRing: lineString,
            interiorRings: [lineString, lineString],
            coordinateSystem: .wgs84
        )

        let user = UserArea(area: polygon)
        try await user.save(on: self.db)

        let fetched = try await UserArea.find(1, on: self.db)
        XCTAssertEqual(fetched?.area, polygon)
    }

    func testGeometryCollection() async throws {
        let point = KernelFluentPostGIS.Geometric.Point2D(x: 1, y: 2, coordinateSystem: .wgs84)
        let point2 = KernelFluentPostGIS.Geometric.Point2D(x: 2, y: 3, coordinateSystem: .wgs84)
        let point3 = KernelFluentPostGIS.Geometric.Point2D(x: 3, y: 2, coordinateSystem: .wgs84)
        let lineString = KernelFluentPostGIS.Geometric.LineString2D(points: [point, point2, point3, point], coordinateSystem: .wgs84)
        let polygon = KernelFluentPostGIS.Geometric.Polygon2D(
            exteriorRing: lineString,
            interiorRings: [lineString, lineString],
            coordinateSystem: .wgs84
        )
        let geometries: [any PostGISCollectable] = [point, point2, point3, lineString, polygon]
        let geometryCollection = KernelFluentPostGIS.Geometric.GeometryCollection2D(from: geometries, coordinateSystem: .wgs84)

        let user = UserCollection(collection: geometryCollection)
        try await user.save(on: self.db)
//
        let fetched = try await UserCollection.find(1, on: self.db)
        if let fetched {
            print(fetched.collection)
        }
//        XCTAssertEqual(fetched?.collection, geometryCollection)
    }
}
