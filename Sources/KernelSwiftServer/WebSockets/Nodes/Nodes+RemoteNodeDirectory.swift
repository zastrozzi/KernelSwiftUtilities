//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/02/2025.
//

import KernelSwiftCommon
import Vapor
import NIOCore
import NIOWebSocket

extension KernelWebSockets.Nodes {
    public final actor RemoteNodeDirectory {
        private var remoteNodes: Dictionary<Core.NodeIdentity, Core.RemoteNodeStatus> = [:]
        private var firstNode: [TimedContinuation<RemoteNode>] = []
        private var timeout: Duration
        private var tolerance: Duration
        
        public init(
            timeout: Duration = .seconds(5),
            tolerance: Duration = .seconds(0.5)
        ) {
            self.timeout = timeout
            self.tolerance = tolerance
        }
        
        public func remoteNode(for actorId: Core.ActorID) async throws -> RemoteNode {
            if let nodeId = actorId.node { try await requireRemoteNode(nodeId) }
            else if remoteNodes.count == 1 { try await requireRemoteNode(remoteNodes.first!.key) }
            else if remoteNodes.isEmpty { try await waitForFirstNode() }
            else { throw KernelWebSockets.TypedError.missingNodeId(actorId) }
        }
        
        public func requireRemoteNode(_ nodeId: Core.NodeIdentity) async throws -> RemoteNode {
            if case let .current(node) = remoteNodes[nodeId] { node }
            else {
                try await withTimeout(nodeId) { continuation in
                    await self.addContinuation(nodeId, continuation)
                }
            }
        }
        
        public func waitForFirstNode() async throws -> RemoteNode {
            try await withTimeout(nil) { continuation in
                await self.queueContinuation(continuation)
            }
        }
        
        public func opened(_ node: RemoteNode) async {
            let nodeId = node.nodeId
            if let status = remoteNodes[nodeId], case let .future(continuations) = status {
                remoteNodes[nodeId] = .current(node)
                for continuation in continuations { await continuation.resume(returning: node) }
            }
            else { remoteNodes[nodeId] = .current(node) }
            for continuation in firstNode { await continuation.resume(returning: node) }
            firstNode = []
        }
        
        public func closing(_ node: RemoteNode) {
            remoteNodes.removeValue(forKey: node.nodeId)
        }
        
        private func addContinuation(_ nodeId: Core.NodeIdentity, _ continuation: TimedContinuation<RemoteNode>) async {
            if let status = remoteNodes[nodeId] {
                switch status {
                case let .current(node): await continuation.resume(returning: node)
                case let .future(continuations): remoteNodes[nodeId] = .future(continuations + [continuation])
                }
            }
            else { remoteNodes[nodeId] = .future([continuation]) }
        }
        
        private func queueContinuation(_ continuation: TimedContinuation<RemoteNode>) {
            firstNode.append(continuation)
        }
        
        private func withTimeout(
            _ nodeId: Core.NodeIdentity?,
            _ handler: @Sendable @escaping (TimedContinuation<RemoteNode>) async -> ()
        ) async throws -> RemoteNode {
            try await withThrowingEnvironmentContinuation { @Sendable continuation in
                Task {
                    let timedContinuation = await TimedContinuation(
                        continuation: continuation,
                        error: KernelWebSockets.TypedError.timeoutWaitingForNode(nodeId, timeout: timeout),
                        timeout: timeout,
                        tolerance: tolerance
                    )
                    await handler(timedContinuation)
                }
            }
        }
    }
}
