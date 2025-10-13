//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation
import SwiftData
import KernelSwiftCommon

@available(*, deprecated)
public protocol BKAppEnvironment {
    
    associatedtype DIContainer: BKDIContainer
    associatedtype ApplicationEventHandler: BKApplicationEventHandler
    var _container: DIContainer? { get set }
    var _appEventHandler: ApplicationEventHandler? { get set }
}

@available(*, deprecated)
extension BKAppEnvironment {
    public var container: DIContainer {
        get {
            guard self._container != nil else { preconditionFailure("No Container") }
            return self._container!
        }
        
        set {
            self._container = newValue
        }
    }
    
    public var appEventHandler: ApplicationEventHandler {
        get {
            guard self._appEventHandler != nil else { preconditionFailure("No App Event Handler") }
            return self._appEventHandler!
        }
        
        set {
            self._appEventHandler = newValue
        }
    }
}

@available(*, deprecated)
public extension BKAppEnvironment {
    mutating func bootstrap<S: BKAppState>(dbModelVersionNumber: UInt, dbModelPrefix: String, httpRootQueueLabel: String, stateModel: S.Type, isDebugging: Bool = false, debuggingMonitors: Set<BKAppSpectorMonitor> = [.logs]) {
        let appState = StateStore<S>(stateModel.initialize())
        let dbModelVersion = KernelSwiftCoreDataStack.Version(dbModelVersionNumber, prefix: dbModelPrefix)
        let persisentStore = KernelSwiftCoreDataStack(versionObj: dbModelVersion)
        let httpService = BKDefaultHttpService(rootQueueLabel: httpRootQueueLabel)
        self.container.initialize(state: appState, persisent: persisentStore, http: httpService, isDebugging: isDebugging, debuggingMonitors: debuggingMonitors)
        self.appEventHandler.connectToContainer(self.container)
        self.appEventHandler.initialize()
    }
    
    @available(*, deprecated)
    @available(iOS 17.0, macOS 14.0, *)
    mutating func bootstrapSwiftData<S: BKAppState>(dbSchema: Schema, _ dbConfigs: [KernelSwiftDataConfig], httpRootQueueLabel: String, stateModel: S.Type, isDebugging: Bool = false, debuggingMonitors: Set<BKAppSpectorMonitor> = [.logs]) throws {
        let appState = StateStore<S>(stateModel.initialize())
//        let dbModelVersion = BKCoreDataStack.Version(dbModelVersionNumber, prefix: dbModelPrefix)
        let persisentStore = try KernelSwiftDataStack(schema: dbSchema, dbConfigs)
        let httpService = BKDefaultHttpService(rootQueueLabel: httpRootQueueLabel)
        self.container.initialize(state: appState, persisent: persisentStore, http: httpService, isDebugging: isDebugging, debuggingMonitors: debuggingMonitors)
        self.appEventHandler.connectToContainer(self.container)
        self.appEventHandler.initialize()
    }
}
