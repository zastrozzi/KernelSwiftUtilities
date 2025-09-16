//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 3/4/24.
//

import NIOConcurrencyHelpers
import Vapor

extension KernelAuthSessions.Model {
    public final class Session: Sendable {
        public var id: SessionID? {
            get {
                self._id.withLockedValue { $0 }
            }
            set {
                self._id.withLockedValue { $0 = newValue }
            }
        }
        
        public var data: SessionData {
            get {
                self._data.withLockedValue { $0 }
            }
            set {
                self._data.withLockedValue { $0 = newValue }
            }
        }
        
        let isValid: NIOLockedValueBox<Bool>
        
        private let _id: NIOLockedValueBox<SessionID?>
        private let _data: NIOLockedValueBox<SessionData>
        
        public init(
            id: SessionID? = nil,
            data: SessionData = .init()
        ) {
            self._id = .init(id)
            self._data = .init(data)
            self.isValid = .init(true)
        }
        
        public func invalidate() {
            self.isValid.withLockedValue { $0 = false }
        }
        
        public func set<T>(_ key: String, to data: T) throws where T: Codable {
            let val = try String(data: JSONEncoder().encode(data), encoding: .utf8)
            self.data[key] = val
        }
        
        public func get<T>(_ key: String, as type: T.Type) throws -> T where T: Codable {
            guard let stored = data[key] else {
                if _isOptional(T.self) { return Optional<Void>.none as! T }
                throw Abort(.internalServerError, reason: "No element found in auth session with key '\(key)'")
            }
            return try JSONDecoder().decode(T.self, from: Data(stored.utf8))
        }
    }
}
