//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/09/2024.
//

import FluentKit
import FluentPostgresDriver
import PostgresKit
import XCTest
import KernelSwiftServer

class PostGISTestCase: XCTestCase {
    var dbs: Databases!
    var db: Database {
        self.dbs.database(
            logger: KernelFluentPostGIS.logger,
            on: self.dbs.eventLoopGroup.next()
        )!
    }

    override func setUp() async throws {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let threadPool = NIOThreadPool(numberOfThreads: 1)
        self.dbs = Databases(threadPool: threadPool, on: eventLoopGroup)

        self.dbs.use(
            .postgres(
                configuration: .init(
                    hostname: "localhost",
                    port: 5432,
                    username: "postgresdb",
                    password: "postgresdb",
                    database: "postgis_tests",
                    tls: .disable
                ),
                maxConnectionsPerEventLoop: 1,
                connectionPoolTimeout: .seconds(10),
                sqlLogLevel: .debug
            ),
            as: .psql
        )
        
        do {
            
            for migration in self.migrations {
                try await migration.prepare(on: self.db)
            }
        } catch {
            print(String(reflecting: error))
            throw error
        }
    }

    override func tearDown() async throws {
        for migration in self.migrations {
            try await migration.revert(on: self.db)
        }
    }

    private let migrations: [AsyncMigration] = [
        KernelFluentPostGIS.EnablePostGISMigration(),
        UserLocationMigration(),
        CityMigration(),
        UserPathMigration(),
        UserAreaMigration(),
        UserCollectionMigration()
    ]
}
