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
public protocol KernelSwiftDIContainer: EnvironmentKey {
    associatedtype State: KernelSwiftAppState
    var _appState: StateStore<State>? { get set }
    var _persistentState: KernelSwiftPersistenceStore? { get set }
    var _httpService: KernelSwiftHttpService? { get set }
    var _remoteDebuggingClient: KernelSwiftRemoteDebuggingClient? { get set }
}

@available(*, deprecated)
public extension KernelSwiftDIContainer {
    @available(*, deprecated)
    mutating func initialize<S: KernelSwiftAppState>(
        state: StateStore<S>,
        persisent: KernelSwiftPersistenceStore,
        http: KernelSwiftHttpService,
        isDebugging: Bool = false,
        debuggingMonitors: Set<KernelSwiftAppSpectorMonitor>
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
            guard _appState != nil else { preconditionFailure(KernelSwiftDIContainerError.noAppState.localizedDescription) }
            return _appState!
        }
        set { preconditionFailure(KernelSwiftDIContainerError.noSettingAppState.localizedDescription) }
    }
    
    var persistentState: KernelSwiftPersistenceStore {
        get {
            guard _persistentState != nil else { preconditionFailure(KernelSwiftDIContainerError.noPersistentState.localizedDescription) }
            return _persistentState!
        }
        set { preconditionFailure(KernelSwiftDIContainerError.noSettingPersistentState.localizedDescription) }
        
        
    }
    
    var httpService: KernelSwiftHttpService {
        get {
            guard _httpService != nil else { preconditionFailure(KernelSwiftDIContainerError.noHTTPService.localizedDescription) }
            return _httpService!
        }
        set { preconditionFailure(KernelSwiftDIContainerError.noSettingHTTPService.localizedDescription) }
    }
    
    var remoteDebuggingClient: KernelSwiftRemoteDebuggingClient {
        get {
            guard _remoteDebuggingClient != nil else { preconditionFailure(KernelSwiftDIContainerError.noRemoteDebuggingClient.localizedDescription) }
            return _remoteDebuggingClient!
        }
        set { preconditionFailure(KernelSwiftDIContainerError.noSettingRemoteDebuggingClient.localizedDescription) }
    }
}

public enum KernelSwiftDIContainerError: Error {
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

extension KernelSwiftDIContainerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noContainer: return "[KernelSwiftDIContainer] No DI Container"
        case .noAppState: return "[KernelSwiftDIContainer] No App State"
        case .noPersistentState: return "[KernelSwiftDIContainer] No Persistent State"
        case .noHTTPService: return "[KernelSwiftDIContainer] No HTTP Service"
        case .noRemoteDebuggingClient: return "[KernelSwiftDIContainer] No Remote Debugging Client"
        case .noSettingAppState: return "[KernelSwiftDIContainer] App State cannot be altered from outside of initialize method"
        case .noSettingPersistentState: return "[KernelSwiftDIContainer] Persistent State cannot be altered from outside of initialize method"
        case .noSettingHTTPService: return "[KernelSwiftDIContainer] HTTP Service cannot be altered from outside of initialize method"
        case .noSettingRemoteDebuggingClient: return "[KernelSwiftDIContainer] Remote Debugging Client cannot be altered from outside of initialize method"
        }
    }
}
