//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 12/02/2025.
//

import KernelSwiftCommon
import Vapor
import Distributed

extension KernelWebSockets.Core {
    public typealias ActorID = ActorIdentity
    
    public struct ActorIdentity: Sendable, Encodable, CustomStringConvertible, CustomDebugStringConvertible {
        public let id: String
        public let type: String?
        public let node: NodeIdentity?
        
        public init(
            id: String,
            type: String? = nil,
            node: NodeIdentity? = nil
        ) {
            self.id = id
            self.type = type
            self.node = node
        }
        
        public init<ActorType>(
            id: String,
            for actorType: ActorType.Type = ActorType.self,
            node: NodeIdentity? = nil
        ) {
            self.id = id
            self.type = "\(actorType)"
            self.node = node
        }
        
        enum CodingKeys: String, CodingKey {
            case id
            case type
            case node
        }

        public static func random(
            type: String? = nil,
            node: NodeIdentity? = nil
        ) -> Self {
            .init(id: UUID().uuidString, type: type, node: node)
        }

        public static func random<ActorType>(
            for actorType: ActorType.Type = ActorType.self,
            node: NodeIdentity? = nil
        ) -> Self where ActorType: DistributedActor, ActorType.ID == ActorIdentity {
            .random(type: "\(actorType)", node: node)
        }
        
        func with(_ nodeID: NodeIdentity) -> ActorIdentity {
            .init(id: id, type: type, node: nodeID)
        }
        
        public func hasType<ActorType>(
            for actorType: ActorType.Type = ActorType.self
        ) -> Bool where ActorType: DistributedActor, ActorType.ID == ActorIdentity {
            type == "\(actorType)"
        }
        
        public var description: String {
            guard let type else { return id }
            return "\(id) \(type)"
        }
        
        public var debugDescription: String {
            "\(Self.self)(\(description))"
        }
    }
}

extension KernelWebSockets.Core.ActorIdentity: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(id: value)
    }
}

extension KernelWebSockets.Core.ActorIdentity: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension KernelWebSockets.Core.ActorIdentity: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        node = try values.decodeIfPresent(KernelWebSockets.Core.NodeIdentity.self, forKey: .node)
    }
}
