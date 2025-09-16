//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/06/2023.
//

import Vapor
import NIOConcurrencyHelpers
import Fluent
import Collections
import KernelSwiftCommon

//@dynamicMemberLookup
public struct KernelServerPlatform: Sendable {
    public struct RootStorageKey: StorageKey {
        public typealias Value = KernelServerPlatform
    }
    public let dbLocks: SimpleMemoryCache<DatabaseID, CRUDModel.DBAccessor>
    @KernelDI.Injected(\.vapor) public var app: Application
    
    public init() {
        self.dbLocks = .init()
        ContentConfiguration.global.use(decoder: PlaintextDecoder(), for: .pkcs8)
        app.logger.info("Initialising KernelServerPlatform")
    }
    
    public static func initialise(for app: Application) {
        app.storage[RootStorageKey.self] = Self.init()
    }
    
    public static var defaultJSONDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .flexible
        return decoder
    }
    
    public static var defaultURLQueryDecoder: URLEncodedFormDecoder {
        let safeURLQueryDecoder: URLEncodedFormDecoder = .init(
            configuration: .init(dateDecodingStrategy: .flexible)
        )
        return safeURLQueryDecoder
    }
    
    public static var defaultPathParamDecoder: PathParamDecoder {
        let pathParamDecoder = PathParamDecoder()
        return pathParamDecoder
    }
    
    public static var defaultPlainTextDecoder: PlaintextDecoder {
        let decoder = PlaintextDecoder()
        return decoder
    }

    @inlinable
    func di<Container: FeatureContainer>(_ containerType: Container.Type) -> Container {
        guard let container = app.storage[Container._StorageKey.self] else { preconditionFailure("Requested container not initialised, \(containerType)") }
        return container as! Container
    }
    
    func setFeatureContainer<Container: FeatureContainer>(_ container: Container) {
        app.storage[Container._StorageKey.self] = (container as! Container._StorageKey.Value)
        app.storage[Container._ConfigStorageKey.self] = (LabelledMemoryCache<Container.ConfigKeys>() as! Container._ConfigStorageKey.Value)
    }
    
    @inlinable
    func withDBLock(_ id: DatabaseID) throws -> CRUDModel.DBAccessor {
        guard let lock = dbLocks.get(id) else {
            return dbLocks.set(id, value: {
                return app.db(id)
            })
        }
        return lock
    }
}

extension Application {
    public var kp: KernelServerPlatform {
        get {
            guard let root = storage[KernelServerPlatform.RootStorageKey.self] else { fatalError("Kernel Platform has not been initialised") }
            return root
        }
        set {
            self.storage[KernelServerPlatform.RootStorageKey.self] = newValue
        }
    }
    
    @inlinable
    public func kernelDI<Container: KernelServerPlatform.FeatureContainer>(_ containerType: Container.Type) -> Container {
        self.kp.di(containerType)
    }
    
    @inlinable
    public func withDBLock(_ id: DatabaseID) throws -> CRUDModel.DBAccessor {
        try kp.withDBLock(id)
    }
    
    @inlinable
    public func withDBLock(_ id: DatabaseID) throws -> Database {
        try kp.withDBLock(id)()
    }
}

