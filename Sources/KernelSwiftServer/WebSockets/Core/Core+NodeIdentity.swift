//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 12/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelWebSockets.Core {
    public struct NodeIdentity: Hashable, Sendable, Equatable, Codable, ExpressibleByStringLiteral, CustomStringConvertible {
        public let id: String
        
        public init(
            id: String
        ) {
            self.id = id
        }
        
        public static func random() -> Self {
            .init(id: UUID().uuidString)
        }
        
        public func encode(to encoder: Encoder) throws {
            try id.encode(to: encoder)
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.id = try container.decode(String.self)
        }
        
        public init(stringLiteral value: String) {
            self.id = value
        }
        
        public var description: String {
            self.id.description
        }
    }
}

extension HTTPHeaders.Name {
    public static let xKernelWebSocketsNodeIdentity = HTTPHeaders.Name("X-KernelWebSockets-NodeIdentity")
}

extension HTTPHeaders {
    public var xKernelWebSocketsNodeIdentity: KernelWebSockets.Core.NodeIdentity? {
        get {
            guard let str = self.first(name: .xKernelWebSocketsNodeIdentity) else { return nil }
            return .init(id: str)
        }
        set {
            if let newValue { replaceOrAdd(name: .xKernelWebSocketsNodeIdentity, value: newValue.id) }
            else { remove(name: .xKernelWebSocketsNodeIdentity) }
        }
    }
}
