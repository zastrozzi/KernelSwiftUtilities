//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/08/2023.
//

import Foundation
import SwiftData

public enum KernelSwiftDataStorageLocation: Sendable {
    case inMemory(modelName: String)
    case fileSystem(directory: KernelSwiftDataDirectory)
}

public struct KernelSwiftDataDirectory: Sendable {
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
        guard let url = FileManager.default.urls(for: directory, in: domainMask).first?.appendingPathComponent(subpathToDB) else { throw KernelSwiftDataError.badURL }
        return url
    }
}

@available(iOS 17, macOS 14.0, *)
public struct KernelSwiftDataConfig {
    public var schema: Schema
    public var location: KernelSwiftDataStorageLocation
    public var allowsSave: Bool
    
    public init(
        schema: Schema,
        location: KernelSwiftDataStorageLocation,
        allowsSave: Bool = true
    ) {
        self.schema = schema
        self.location = location
        self.allowsSave = allowsSave
    }
}

@available(iOS 17, macOS 14.0, *)
public struct KernelSwiftDataStack: KernelSwiftPersistenceStore {
    public var modelContainer: ModelContainer
    public var defaultModelContext: ModelContext
    
    public init(
        schema: Schema,
        configurations: [KernelSwiftDataConfig]
    ) throws {
        var configs: [ModelConfiguration] = []
//        configurations.append(.init(schema: schema))
        configs.append(
            contentsOf: try configurations.map {
                switch $0.location {
                case let .inMemory(modelName):
                    .init(
                        modelName,
                        schema: $0.schema,
                        isStoredInMemoryOnly: true,
                        allowsSave: $0.allowsSave
                    )
                case let .fileSystem(directory):
                    .init(
                        directory.fileName,
                        schema: $0.schema,
                        url: try directory.dbFileURL(),
                        allowsSave: $0.allowsSave
                    )
                }
            }
        )
        modelContainer = try .init(for: schema, configurations: configs)
        defaultModelContext = .init(modelContainer)
    }
    
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


public enum KernelSwiftDataError: Error {
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

extension KernelSwiftDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badURL: return "[KernelSwiftData] Bad URL"
        case .noAppState: return "[KernelDIContainer] No App State"
        case .noPersistentState: return "[KernelDIContainer] No Persistent State"
        case .noHTTPService: return "[KernelDIContainer] No HTTP Service"
        case .noRemoteDebuggingClient: return "[KernelDIContainer] No Remote Debugging Client"
        case .noSettingAppState: return "[KernelDIContainer] App State cannot be altered from outside of initialize method"
        case .noSettingPersistentState: return "[KernelDIContainer] Persistent State cannot be altered from outside of initialize method"
        case .noSettingHTTPService: return "[KernelDIContainer] HTTP Service cannot be altered from outside of initialize method"
        case .noSettingRemoteDebuggingClient: return "[KernelDIContainer] Remote Debugging Client cannot be altered from outside of initialize method"
        }
    }
}
