//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/5/24.
//

import Vapor
import KernelSwiftCommon
import Fluent

public struct KernelAudit: KernelServerPlatform.FeatureContainer, Sendable {
//    public static let logger = makeLogger()
    @KernelDI.Injected(\.vapor) public var app: Application
    public let auditEvent: Services.AuditEventService
    
    public init() async {
        Self.logInit()
        self.auditEvent = .init()
        
    }
    
    internal func defaultDB() throws -> CRUDModel.DBAccessor {
        try app.withDBLock(config.get(.defaultDatabaseID, as: DatabaseID.self)!)
    }
    
    internal func defaultDB() throws -> Database {
        try app.withDBLock(config.get(.defaultDatabaseID, as: DatabaseID.self)!)
    }
}

extension KernelAudit {
    public enum ConfigKeys: LabelRepresentable {
        case defaultDatabaseID
        
        public var label: String {
            switch self {
            case .defaultDatabaseID: "defaultDatabaseID"
            }
        }
    }
    
}
