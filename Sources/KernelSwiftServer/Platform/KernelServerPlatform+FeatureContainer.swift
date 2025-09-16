//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/06/2023.
//

import Vapor
import NIOConcurrencyHelpers
import KernelSwiftCommon
import Fluent

public protocol _KernelServerPlatformFeatureContainer: FeatureLoggable {
    associatedtype ConfigKeys: LabelRepresentable
    associatedtype _StorageKey: StorageKey = KernelServerPlatform.StorageKeyWrapper<Self>
    associatedtype _ConfigStorageKey: StorageKey = KernelServerPlatform.StorageKeyWrapper<KernelServerPlatform.LabelledMemoryCache<ConfigKeys>>
    associatedtype Fluent: _KernelServerPlatformFeatureContainerFluent = _EmptyFluent
    var app: Application { get }
    var config: KernelServerPlatform.LabelledMemoryCache<ConfigKeys> { get }
    static var name: String { get }
    
//    init(for app: Application) async
    init() async
    
    /// Feature Containers specialise their initialisation via postInit() - akin to a lifecycle event didInit()
    func postInit() async throws
}

public enum _EmptyFluent: _KernelServerPlatformFeatureContainerFluent {
    public enum SchemaName: String, KernelFluentNamespacedSchemaName {
        public static let namespace: String = ""
        case empty
    }
    
    public enum Migrations: _KernelServerPlatformFeatureContainerMigrations {
        public typealias SchemaName = _EmptyFluent.SchemaName
        public static func prepare(on app: Application, for databaseId: DatabaseID) {}
    }
    
    public enum Model: _KernelServerPlatformFeatureContainerFluentModel {
        public typealias SchemaName = _EmptyFluent.SchemaName
    }
}

public protocol _KernelServerPlatformFeatureContainerFluent {
    associatedtype Migrations: _KernelServerPlatformFeatureContainerMigrations
    associatedtype Model: _KernelServerPlatformFeatureContainerFluentModel
}

public protocol _KernelServerPlatformFeatureContainerMigrations {
    associatedtype SchemaName: KernelFluentNamespacedSchemaName
    static func prepare(on app: Application, for databaseId: DatabaseID)
}

public protocol _KernelServerPlatformFeatureContainerFluentModel {
    associatedtype SchemaName: KernelFluentNamespacedSchemaName
}

extension _KernelServerPlatformFeatureContainerMigrations {
    public static func prepareAndMigrate(on app: Application, for databaseId: DatabaseID) async throws {
        prepare(on: app, for: databaseId)
        try await app.autoMigrate()
    }
}

public protocol _KernelServerPlatformLabelledKeyRepresentable: Hashable {
    var label: String { get }
}

extension KernelServerPlatform {
    public typealias FeatureContainer = _KernelServerPlatformFeatureContainer
    public typealias FluentContainer = _KernelServerPlatformFeatureContainerFluent
    public typealias FluentMigrations = _KernelServerPlatformFeatureContainerMigrations
    public typealias FluentModel = _KernelServerPlatformFeatureContainerFluentModel
}



//extension KernelServerPlatform.LabelledKeyRepresentable {
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.label == rhs.label
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        label.hash(into: &hasher)
//    }
//}


extension KernelServerPlatform.FeatureContainer {
    public static var name: String { String(describing: Self.self) }
    
    public static func logInit(level: Logger.Level = .info) {
        Self.logger.log(level: level, "Initialising \(Self.name)")
    }
    
    public static func initialise(
        for app: Application,
        withConfiguration configParameters: Array<(key: ConfigKeys, value: any Sendable)> = []
    ) async throws {
        let feature = await Self.init()
        app.kp.setFeatureContainer(feature)
        feature.config.set(configParameters)
        try await feature.postInit()
    }
    
    public static func initialise(
        for app: Application,
        withConfiguration configParameters: (key: ConfigKeys, value: any Sendable)...
    ) async throws {
        try await initialise(for: app, withConfiguration: configParameters)
        
    }
    
    public static func initialise(
        for app: Application,
        withConfiguration configParameters: KernelServerPlatform.ConfigValue<Self>...
    ) async throws {
        try await initialise(for: app, withConfiguration: configParameters.map { ($0.key, $0.value) })
        
    }
    
    
    public func postInit() async throws {}

    public var config: KernelServerPlatform.LabelledMemoryCache<ConfigKeys> {
        get {
            guard let config = app.storage[_ConfigStorageKey.self] else { fatalError() }
            return config as! KernelServerPlatform.LabelledMemoryCache<ConfigKeys>
        }
    }
}

extension KernelServerPlatform {
    public enum ConfigValue<Container: KernelServerPlatform.FeatureContainer>: Sendable {
        case configKey(_ key: Container.ConfigKeys, _ value: any Sendable)
        
        public var key: Container.ConfigKeys {
            switch self {
            case let .configKey(key, _): key
            }
        }
        
        public var value: any Sendable {
            switch self {
            case let .configKey(_, value): value
            }
        }
    }
}
