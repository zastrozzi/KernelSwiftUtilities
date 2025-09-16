//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import KernelSwiftCommon
import Vapor
import NIOCore
import NIOWebSocket

extension KernelWebSockets.Nodes {
    public final actor RemoteNode {
        @TaskLocal static var current: RemoteNode?
        
        public let nodeId: Core.NodeIdentity
        public let channel: KernelWebSockets.AgentChannel
        public let inbound: KernelWebSockets.InboundStream
        public let outbound: KernelWebSockets.OutboundWriter
        private var userInfo: Dictionary<Core.UserInfoKey, any Sendable> = [:]
        
        private init(
            nodeId: Core.NodeIdentity,
            channel: KernelWebSockets.AgentChannel,
            inbound: KernelWebSockets.InboundStream,
            outbound: KernelWebSockets.OutboundWriter
        ) {
            self.nodeId = nodeId
            self.channel = channel
            self.inbound = inbound
            self.outbound = outbound
        }
        
        public static func withRemoteNode(
            nodeId: Core.NodeIdentity,
            channel: KernelWebSockets.AgentChannel,
            _ handler: (RemoteNode) async throws -> Void
        ) async throws {
            try await channel.executeThenClose { inbound, outbound in
                let remote = RemoteNode(nodeId: nodeId, channel: channel, inbound: inbound, outbound: outbound)
                try await $current.withValue(remote) {
                    try await handler(remote)
                }
            }
        }
        
        public func write(
            forSystem actorSystem: KernelWebSockets.ActorSystem,
            envelope: Core.WireEnvelope
        ) async throws {
            switch envelope {
            case .connectionClose:
                var data = channel.channel.allocator.buffer(capacity: 2)
                data.write(webSocketErrorCode: .protocolError)
                let frame: WebSocketFrame = .init(fin: true, opcode: .connectionClose, data: data)
                try await outbound.write(frame)
            case .reply, .call:
                let encoder = JSONEncoder()
                encoder.userInfo[.actorSystemKey] = actorSystem
                var data = ByteBuffer()
                try data.writeJSONEncodable(envelope, encoder: encoder)
                let frame: WebSocketFrame = .init(fin: true, opcode: .text, data: data)
                try await outbound.write(frame)
            }
        }
        
        public func ping() async throws {
            let frame: WebSocketFrame = .init(fin: true, opcode: .ping, data: channel.channel.allocator.buffer(capacity: 0))
            try await outbound.write(frame)
        }
        
        public func getUserInfo(key: Core.UserInfoKey) -> (any Sendable)? { userInfo[key] }
        public func setUserInfo(key: Core.UserInfoKey, value: any Sendable) { userInfo[key] = value }
        
    }
}
