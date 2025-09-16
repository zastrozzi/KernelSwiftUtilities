//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/06/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

public protocol DBAccessible: Sendable {
    associatedtype FeatureContainer: KernelServerPlatform.FeatureContainer
    var app: Application { get }
    static var name: String { get }
}

extension DBAccessible {
    public typealias FluentModel = FeatureContainer.Fluent.Model
    
    public static var name: String { String(describing: Self.self) }
    
    public var featureContainer: FeatureContainer { app.kernelDI(FeatureContainer.self) }
    
    public func selectDB(_ specifiedDB: DatabaseID? = nil) throws -> CRUDModel.DBAccessor {
        if let specifiedDB { try app.withDBLock(specifiedDB) } else {
            try app.withDBLock(featureContainer.config.get("defaultDatabaseID", as: DatabaseID.self)!)
        }
    }
    
    public func selectDB(_ specifiedDB: DatabaseID? = nil) throws -> Database {
        if let specifiedDB { try app.withDBLock(specifiedDB) } else {
            try app.withDBLock(featureContainer.config.get("defaultDatabaseID", as: DatabaseID.self)!)
        }
    }
    
    public static func logInit(level: Logger.Level = .info) {
        Self.FeatureContainer.logger.log(level: level, "Initialising \(Self.name)")
    }
}


public protocol DBAccessibleActor: Actor {
    associatedtype FeatureContainer: KernelServerPlatform.FeatureContainer
    var app: Application { get }
}

extension DBAccessibleActor {
    public typealias FluentModel = FeatureContainer.Fluent.Model
    
    
    public var featureContainer: FeatureContainer { app.kernelDI(FeatureContainer.self) }
    
    public func selectDB(_ specifiedDB: DatabaseID? = nil) throws -> CRUDModel.DBAccessor {
        if let specifiedDB { try app.withDBLock(specifiedDB) } else {
            try app.withDBLock(featureContainer.config.get("defaultDatabaseID", as: DatabaseID.self)!)
        }
    }
    
    public func selectDB(_ specifiedDB: DatabaseID? = nil) throws -> Database {
        if let specifiedDB { try app.withDBLock(specifiedDB) } else {
            try app.withDBLock(featureContainer.config.get("defaultDatabaseID", as: DatabaseID.self)!)
        }
    }
}
