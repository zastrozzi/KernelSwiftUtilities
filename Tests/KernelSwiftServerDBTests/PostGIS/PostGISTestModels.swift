//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/09/2024.
//

import FluentKit
import KernelSwiftServer

final class UserLocation: Model, @unchecked Sendable {
    static let schema = "user_location"

    @ID(custom: .id, generatedBy: .database)
    var id: Int?

    @PostGISField(key: "location")
    var location: KernelFluentPostGIS.Geometric.Point2D

    init() {}

    init(location: KernelFluentPostGIS.Geometric.Point2D) {
        self.location = location
    }
}

struct UserLocationMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(UserLocation.schema)
            .field(.id, .int, .identifier(auto: true))
            .field("location", .geometricPoint2D(.wgs84))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(UserLocation.schema).delete()
    }
}

/// A model for testing `GeographicPoint2D`-related functionality
final class City: Model, @unchecked Sendable {
    static let schema = "city_location"

    @ID(custom: .id, generatedBy: .database)
    var id: Int?

    @PostGISField(key: "location")
    var location: KernelFluentPostGIS.Geographic.Point2D

    init() {}

    init(location: KernelFluentPostGIS.Geographic.Point2D) {
        self.location = location
    }
}

struct CityMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(City.schema)
            .field(.id, .int, .identifier(auto: true))
            .field("location", .geographicPoint2D(.wgs84))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(City.schema).delete()
    }
}

final class UserPath: Model, @unchecked Sendable {
    static let schema: String = "user_path"

    @ID(custom: .id, generatedBy: .database)
    var id: Int?

    @PostGISField(key: "path")
    var path: KernelFluentPostGIS.Geometric.LineString2D

    init() {}

    init(path: KernelFluentPostGIS.Geometric.LineString2D) {
        self.path = path
    }
}

struct UserPathMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(UserPath.schema)
            .field(.id, .int, .identifier(auto: true))
            .field("path", .geometricLineString2D(.wgs84))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(UserPath.schema).delete()
    }
}

final class UserArea: Model, @unchecked Sendable {
    static let schema: String = "user_area"

    @ID(custom: .id, generatedBy: .database)
    var id: Int?

    @PostGISField(key: "area")
    public var area: KernelFluentPostGIS.Geometric.Polygon2D

    init() {}

    init(area: KernelFluentPostGIS.Geometric.Polygon2D) {
        self.area = area
    }
}

struct UserAreaMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(UserArea.schema)
            .field(.id, .int, .identifier(auto: true))
            .field("area", .geometricPolygon2D(.wgs84))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(UserArea.schema).delete()
    }
}

final class UserCollection: Model, @unchecked Sendable {
    static let schema: String = "user_collection"

    @ID(custom: .id, generatedBy: .database)
    var id: Int?

    @PostGISField(key: "collection")
    var collection: KernelFluentPostGIS.Geometric.GeometryCollection2D

    init() {}

    init(collection: KernelFluentPostGIS.Geometric.GeometryCollection2D) {
        self.collection = collection
    }
}

struct UserCollectionMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(UserCollection.schema)
            .field(.id, .int, .identifier(auto: true))
            .field("collection", .geometricGeometryCollection2D(.wgs84))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(UserCollection.schema).delete()
    }
}
