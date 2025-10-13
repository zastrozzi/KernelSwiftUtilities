//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation
import SwiftUI
import OSLog
import KernelSwiftCommon

@available(*, deprecated)
public protocol BKDIContainer: EnvironmentKey {
    associatedtype State: BKAppState
    var _appState: StateStore<State>? { get set }
    var _persistentState: KernelSwiftPersistenceStore? { get set }
    var _httpService: BKHttpService? { get set }
    var _remoteDebuggingClient: BKRemoteDebuggingClient? { get set }
}

@available(*, deprecated)
public extension BKDIContainer {
    @available(*, deprecated)
    mutating func initialize<S: BKAppState>(
        state: StateStore<S>,
        persisent: KernelSwiftPersistenceStore,
        http: BKHttpService,
        isDebugging: Bool = false,
        debuggingMonitors: Set<BKAppSpectorMonitor>
    ) {
        self._appState = state as? StateStore<State>
        self._persistentState = persisent
        self._httpService = http
        if isDebugging {
            self._remoteDebuggingClient = .init()
//            do { try self._remoteDebuggingClient?.initializeAppSpector(initialMonitors: debuggingMonitors) } catch let e { DI.logger.error("\(e.localizedDescription)") }
        }
    }
    
    var appState: StateStore<Self.State> {
        get {
            guard _appState != nil else { preconditionFailure(BKDIContainerError.noAppState.localizedDescription) }
            return _appState!
        }
        set { preconditionFailure(BKDIContainerError.noSettingAppState.localizedDescription) }
    }
    
    var persistentState: KernelSwiftPersistenceStore {
        get {
            guard _persistentState != nil else { preconditionFailure(BKDIContainerError.noPersistentState.localizedDescription) }
            return _persistentState!
        }
        set { preconditionFailure(BKDIContainerError.noSettingPersistentState.localizedDescription) }
        
        
    }
    
    var httpService: BKHttpService {
        get {
            guard _httpService != nil else { preconditionFailure(BKDIContainerError.noHTTPService.localizedDescription) }
            return _httpService!
        }
        set { preconditionFailure(BKDIContainerError.noSettingHTTPService.localizedDescription) }
    }
    
    var remoteDebuggingClient: BKRemoteDebuggingClient {
        get {
            guard _remoteDebuggingClient != nil else { preconditionFailure(BKDIContainerError.noRemoteDebuggingClient.localizedDescription) }
            return _remoteDebuggingClient!
        }
        set { preconditionFailure(BKDIContainerError.noSettingRemoteDebuggingClient.localizedDescription) }
    }
}

public enum BKDIContainerError: Error {
    case noContainer
    case noAppState
    case noPersistentState
    case noHTTPService
    case noRemoteDebuggingClient
    case noSettingAppState
    case noSettingPersistentState
    case noSettingHTTPService
    case noSettingRemoteDebuggingClient
}

extension BKDIContainerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noContainer: return "[BKDIContainer] No DI Container"
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
