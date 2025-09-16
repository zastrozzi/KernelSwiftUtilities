//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 01/05/2023.
//
//
//import Foundation
//import Vapor
//import NIOConcurrencyHelpers
//
//extension Application.KernelServices {
//    public final class KernelServiceConfig<ConfigKeys: Hashable & CaseIterable> {
//        private var configStorage: Dictionary<ConfigKeys, any Sendable>
//        private var lock: NIOLock
//        
//        public init() {
//            self.configStorage = [:]
//            self.lock = .init()
//        }
//        
//        public func get<V: Sendable>(_ key: ConfigKeys, as: V.Type) -> V? {
//            self.lock.lock()
//            defer { self.lock.unlock() }
//            return self.configStorage[key] as? V
//        }
//        
//        public func set<V: Codable>(_ key: ConfigKeys, value: V) {
//            self.lock.lock()
//            defer { self.lock.unlock() }
//            self.configStorage.updateValue(value, forKey: key)
//        }
//    }
//}
