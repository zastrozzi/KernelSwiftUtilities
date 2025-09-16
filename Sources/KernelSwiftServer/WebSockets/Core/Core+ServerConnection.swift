//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/02/2025.
//

extension KernelWebSockets.Core {
    public struct ServerConnection: Sendable {
        public var channel: KernelWebSockets.AgentChannel
        public var nodeId: NodeIdentity
        
        public init(
            channel: KernelWebSockets.AgentChannel,
            nodeId: NodeIdentity
        ) {
            self.channel = channel
            self.nodeId = nodeId
        }
    }
}
