//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/06/2022.
//

import Foundation
//import AppSpectorSDK

public final class KernelSwiftRemoteDebuggingClient {
    fileprivate var appSpectorMonitors: Set<KernelSwiftAppSpectorMonitor> = []
    fileprivate var appSpectorAPIKey: String = ""
//    fileprivate var appSpectorConfig: AppSpectorConfig? = nil
    
    var propertyListDecoder = PropertyListDecoder()
    
    public init() {}
    
    public func initializeAppSpector(initialMonitors: Set<KernelSwiftAppSpectorMonitor>) throws {
//        stopAppSpector()
//        setAppSpectorAPIKeyFromPList()
//        setAppSpectorMonitors(initialMonitors)
//        try createAppSpectorConfig()
//        try startAppSpector()
        return
    }
    
    public func stopAppSpector() {
        guard isAppSpectorRunning else { return }
//        AppSpector.stop()
        return
    }
    
    public func startAppSpector() throws {
        if isAppSpectorRunning { stopAppSpector() }
//        guard let config = appSpectorConfig else { throw KernelSwiftRemoteDebuggingError.noAppSpectorConfig }
//        AppSpector.run(with: config)
        return
    }
    
    public func resetAppSpector() {
        stopAppSpector()
        appSpectorAPIKey = ""
        appSpectorMonitors = []
//        appSpectorConfig = nil
    }
    
    private var isAppSpectorRunning: Bool {
//        return AppSpector.isRunning()
        return true
    }
    
    private func createAppSpectorConfig() throws {
        guard !appSpectorAPIKey.isEmpty else { throw KernelSwiftRemoteDebuggingError.noAppSpectorKey }
        guard !appSpectorMonitors.isEmpty else { throw KernelSwiftRemoteDebuggingError.noAppSpectorMonitors }
//        appSpectorConfig = AppSpectorConfig(apiKey: appSpectorAPIKey, monitorIDs: .init(appSpectorMonitors.unique().map { $0.asAppSpectorMonitor }))
        return
    }
    
    
    
    private func setAppSpectorAPIKeyFromPList() {
        appSpectorAPIKey = plistConfig.appspector_api_key
        return
    }
    
    private func setAppSpectorMonitors(_ monitors: Set<KernelSwiftAppSpectorMonitor>) {
        appSpectorMonitors = monitors
        return
    }
}

extension KernelSwiftRemoteDebuggingClient {
    fileprivate struct PListConfig: Codable {
        let appspector_api_key: String
    }
    
    private var plistConfig: PListConfig {
        guard
            let plistURL = Bundle.main.url(forResource: "KernelSwiftUtilities", withExtension: "plist"),
            let plistData = try? Data(contentsOf: plistURL)
        else { preconditionFailure("[KernelSwiftRemoteDebuggingClient] Failed to find KernelSwiftUtilities Property List.")}
        
        guard
            let plistDecoded: PListConfig = try? propertyListDecoder.decode(PListConfig.self, from: plistData)
        else { preconditionFailure("[KernelSwiftRemoteDebuggingClient] Failed to decode KernelSwiftUtilities Property List.")}
        
        return plistDecoded
    }
}

public enum KernelSwiftAppSpectorMonitor: String, CaseIterable {
    case screenshot = "[KernelSwiftAppspectorMonitor] Screenshot"
    case sqlite  = "[KernelSwiftAppspectorMonitor] SQLite"
    case http  = "[KernelSwiftAppspectorMonitor] HTTP"
    case coredata  = "[KernelSwiftAppspectorMonitor] CoreData"
    case performance  = "[KernelSwiftAppspectorMonitor] Performance"
    case logs  = "[KernelSwiftAppspectorMonitor] Logs"
    case location  = "[KernelSwiftAppspectorMonitor] Location"
    case environment  = "[KernelSwiftAppspectorMonitor] Environment"
    case notifications  = "[KernelSwiftAppspectorMonitor] Notifications"
    case analytics  = "[KernelSwiftAppspectorMonitor] Analytics"
    case userdefaults  = "[KernelSwiftAppspectorMonitor] UserDefaults"
    case commands  = "[KernelSwiftAppspectorMonitor] Commands"
    case customEvents  = "[KernelSwiftAppspectorMonitor] CustomEvents"
    case fileSystem  = "[KernelSwiftAppspectorMonitor] FileSystem"
    
//    var asAppSpectorMonitor: Monitor {
//        switch self {
//        case .screenshot: return Monitor.screenshot
//        case .sqlite: return Monitor.sqlite
//        case .http: return Monitor.http
//        case .coredata: return Monitor.coredata
//        case .performance: return Monitor.performance
//        case .logs: return Monitor.logs
//        case .location: return Monitor.location
//        case .environment: return Monitor.environment
//        case .notifications: return Monitor.notifications
//        case .analytics: return Monitor.analytics
//        case .userdefaults: return Monitor.userdefaults
//        case .commands: return Monitor.commands
//        case .customEvents: return Monitor.customEvents
//        case .fileSystem: return Monitor.fileSystem
//        }
//    }
}

public enum KernelSwiftRemoteDebuggingError: Error {
    case noAppSpectorKey
    case noAppSpectorMonitors
    case noAppSpectorConfig
    case appSpectorAlreadyRunning
}

extension KernelSwiftRemoteDebuggingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noAppSpectorKey: return "No AppSpector API Key found"
        case .noAppSpectorMonitors: return "No AppSpector monitors selected"
        case .noAppSpectorConfig: return "No AppSpector config found"
        case .appSpectorAlreadyRunning: return "AppSpector is already running"
        }
    }
}
