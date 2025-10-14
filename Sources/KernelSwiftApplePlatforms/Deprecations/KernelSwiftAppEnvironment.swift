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
public protocol KernelSwiftAppEnvironment {
    
    associatedtype DIContainer: KernelSwiftDIContainer
    associatedtype ApplicationEventHandler: KernelSwiftApplicationEventHandler
    var _container: DIContainer? { get set }
    var _appEventHandler: ApplicationEventHandler? { get set }
}

@available(*, deprecated)
extension KernelSwiftAppEnvironment {
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
public extension KernelSwiftAppEnvironment {
    mutating func bootstrap<S: KernelSwiftAppState>(dbModelVersionNumber: UInt, dbModelPrefix: String, httpRootQueueLabel: String, stateModel: S.Type, isDebugging: Bool = false, debuggingMonitors: Set<KernelSwiftAppSpectorMonitor> = [.logs]) {
        let appState = StateStore<S>(stateModel.initialize())
        let dbModelVersion = KernelSwiftCoreDataStack.Version(dbModelVersionNumber, prefix: dbModelPrefix)
        let persisentStore = KernelSwiftCoreDataStack(versionObj: dbModelVersion)
        let httpService = KernelSwiftDefaultHttpService(rootQueueLabel: httpRootQueueLabel)
        self.container.initialize(state: appState, persisent: persisentStore, http: httpService, isDebugging: isDebugging, debuggingMonitors: debuggingMonitors)
        self.appEventHandler.connectToContainer(self.container)
        self.appEventHandler.initialize()
    }
    
    @available(*, deprecated)
    @available(iOS 17.0, macOS 14.0, *)
    mutating func bootstrapSwiftData<S: KernelSwiftAppState>(dbSchema: Schema, _ dbConfigs: [KernelSwiftDataConfig], httpRootQueueLabel: String, stateModel: S.Type, isDebugging: Bool = false, debuggingMonitors: Set<KernelSwiftAppSpectorMonitor> = [.logs]) throws {
        let appState = StateStore<S>(stateModel.initialize())
//        let dbModelVersion = KernelSwiftCoreDataStack.Version(dbModelVersionNumber, prefix: dbModelPrefix)
        let persisentStore = try KernelSwiftDataStack(schema: dbSchema, configurations: dbConfigs)
        let httpService = KernelSwiftDefaultHttpService(rootQueueLabel: httpRootQueueLabel)
        self.container.initialize(state: appState, persisent: persisentStore, http: httpService, isDebugging: isDebugging, debuggingMonitors: debuggingMonitors)
        self.appEventHandler.connectToContainer(self.container)
        self.appEventHandler.initialize()
    }
}
