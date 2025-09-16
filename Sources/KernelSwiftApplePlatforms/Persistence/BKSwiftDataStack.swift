//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/08/2023.
//

import Foundation
import SwiftData

public struct BKSwiftDataDirectory {
    
    
    public var directory: FileManager.SearchPathDirectory
    public var domainMask: FileManager.SearchPathDomainMask
    public var version: UInt
    public var prefix: String
    
    public var fileName: String {
        return "\(prefix)_v\(version)"
    }
    
    private var subpathToDB: String {
        return "\(fileName).sql"
    }
    
    public init(
        directory: FileManager.SearchPathDirectory = .documentDirectory,
        domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
        version: UInt,
        prefix: String
    ) {
        self.directory = directory
        self.domainMask = domainMask
        self.version = version
        self.prefix = prefix
    }
    
    public func dbFileURL() throws -> URL {
        guard let url = FileManager.default.urls(for: directory, in: domainMask).first?.appendingPathComponent(subpathToDB) else { throw BKSwiftDataError.badURL }
        return url
    }
    
    
}

@available(iOS 17, macOS 14.0, *)
public struct BKSwiftDataConfig {
    public init(
        schema: Schema,
        directory: BKSwiftDataDirectory
    ) {
        self.schema = schema
        self.directory = directory
    }
    
    public var schema: Schema
    public var directory: BKSwiftDataDirectory
}

@available(iOS 17, macOS 14.0, *)
public struct BKSwiftDataStack: BKPersistentStore {
//    private var container: ModelContainer
//    private var context: ModelContext
    
    public init(schema: Schema, _ configs: [BKSwiftDataConfig]) throws {
        var configurations: [ModelConfiguration] = []
//        configurations.append(.init(schema: schema))
        configurations.append(contentsOf: try configs.map {
            .init($0.directory.fileName, schema: $0.schema, url: try $0.directory.dbFileURL())
        })
        modelContainer = try .init(for: schema, configurations: configurations)
        defaultModelContext = .init(modelContainer)
    }
    
    public var modelContainer: ModelContainer
    public var defaultModelContext: ModelContext
    
    public func modelContext(for configName: String) -> ModelContext {
        guard let config = modelContainer.configurations.first(where: { $0.name == configName }) else { preconditionFailure() }
        do {
            let context: ModelContext = .init(try .init(for: config.schema!, configurations: [config]))
            return context
        } catch {
            preconditionFailure()
        }
    }
}


public enum BKSwiftDataError: Error {
    case badURL
    case noAppState
    case noPersistentState
    case noHTTPService
    case noRemoteDebuggingClient
    case noSettingAppState
    case noSettingPersistentState
    case noSettingHTTPService
    case noSettingRemoteDebuggingClient
}

extension BKSwiftDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badURL: return "[BKSwiftData] Bad URL"
        case .noAppState: return "[BKDIContainer] No App State"
        case .noPersistentState: return "[BKDIContainer] No Persistent State"
        case .noHTTPService: return "[BKDIContainer] No HTTP Service"
        case .noRemoteDebuggingClient: return "[BKDIContainer] No Remote Debugging Client"
        case .noSettingAppState: return "[BKDIContainer] App State cannot be altered from outside of initialize method"
        case .noSettingPersistentState: return "[BKDIContainer] Persistent State cannot be altered from outside of initialize method"
        case .noSettingHTTPService: return "[BKDIContainer] HTTP Service cannot be altered from outside of initialize method"
        case .noSettingRemoteDebuggingClient: return "[BKDIContainer] Remote Debugging Client cannot be altered from outside of initialize method"
        }
    }
}
