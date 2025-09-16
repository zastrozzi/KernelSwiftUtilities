//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/11/2023.
//

import Foundation

extension KernelSwiftCommon.Concurrency {
    public struct LifecycleBox: Sendable {
        private var storage: LifecycleStorage
        private var lock: Core.CriticalLock
        
        public init() {
            self.storage = .init()
            self.lock = .fromUnderlying()
        }
        
        public struct LifecycleStorage: Sendable {
            var didShutdown: Bool
            var running: LifecyclePromise?
            var signalSources: [DispatchSource]
            
            public init() {
                self.didShutdown = false
                self.running = nil
                self.signalSources = []
            }
        }
    }
}

extension KernelSwiftCommon.Concurrency.LifecycleBox {
    public mutating func addSignalSource(_ code: Int32, queue: DispatchQueue, handler: @escaping () -> Void) {
        self.lock.lock()
        defer { self.lock.unlock() }
        let source = DispatchSource.makeSignalSource(signal: code, queue: queue)
        source.setEventHandler(handler: handler)
        source.resume()
        storage.signalSources.append(source as! DispatchSource)
        signal(code, SIG_IGN)
    }
    
    public mutating func shutdown() {
        self.lock.lock()
        defer { self.lock.unlock() }
        storage.running?.stop()
        storage.didShutdown = true
    }
    
    public mutating func start() {
        self.lock.lock()
        defer { self.lock.unlock() }
        guard storage.running == nil else { preconditionFailure("Lifecycle already started") }
        storage.running = .start()
    }
}

extension DispatchSource: Sendable {}
