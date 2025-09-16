//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/02/2025.
//

import KernelSwiftCommon
import NIOHTTP1
import NIOWebSocket

#if canImport(Network)
import NIOTransportServices
typealias PlatformBootstrap = NIOTSConnectionBootstrap
#else
import NIOPosix
typealias PlatformBootstrap = ClientBootstrap
#endif

extension KernelWebSockets.Managers {
    public final actor ClientManager: AnyManager {
        private let system: KernelWebSockets.ActorSystem
        private var clientTask: ResilientTask?
        private var pingScheduler: PingScheduler?
        
        private var remoteNodeId: Core.NodeIdentity?
        private var remoteNodeIdContinuations: [EnvironmentContinuation<Core.NodeIdentity, Never>] = []
        
        #if canImport(Network)
        static let group = NIOTSEventLoopGroup.singleton
        #else
        static let group = MultiThreadedEventLoopGroup.singleton
        #endif
        
        public init(system: KernelWebSockets.ActorSystem) {
            self.system = system
        }
        
        @Sendable
        func updateConnectionStatus(_ status: ResilientTask.Status) async {
            Task { await system.monitor?(status) }
        }
        
        func connect(host: String, port: Int) {
            cancel()
            clientTask = ResilientTask(monitor: updateConnectionStatus(_:)) { initialised in
                try await TaskPath.with(name: "client connection") {
                    let serverConnection = try await self.openClientChannel(host: host, port: port)
                    self.system.logger
                        .trace("got serverConnection to node \(serverConnection.nodeId) on \(TaskPath.current)")
                    await initialised()
                    try await self.system.dispatchIncomingFrames(
                        channel: serverConnection.channel,
                        remoteNodeId: serverConnection.nodeId
                    )
                }
            }
        }
        
        public func cancel() {
            clientTask?.cancel()
            clientTask = nil
        }
        
        func setRemoteNodeId(_ remoteNodeId: Core.NodeIdentity) {
            self.remoteNodeId = remoteNodeId
            for continuation in remoteNodeIdContinuations {
                continuation.resume(returning: remoteNodeId)
            }
            remoteNodeIdContinuations.removeAll()
        }
        
        public func getRemoteNodeId() async throws -> Core.NodeIdentity {
            if let remoteNodeId { remoteNodeId }
            else { await withCheckedContinuation { remoteNodeIdContinuations.append($0) } }
        }
        
        private func openClientChannel(host: String, port: Int) async throws -> Core.ServerConnection {
            let bootstrap = PlatformBootstrap(group: ClientManager.group)
            let upgradeResult = try await bootstrap.connect(host: host, port: port) { channel in
                channel.eventLoop.makeCompletedFuture {
                    let upgrader = NIOTypedWebSocketClientUpgrader<Core.ClientUpgradeResult> { channel, responseHead in
                        self.system.logger.trace("Upgrading Client Channel to Server on \(TaskPath.current)")
                        self.system.logger.trace("responseHead = \(responseHead)")
                        return channel.eventLoop.makeCompletedFuture {
                            let asyncChannel: KernelWebSockets.AgentChannel = try .init(wrappingChannelSynchronously: channel)
                            guard let serverNodeId = responseHead.headers.xKernelWebSocketsNodeIdentity else {
                                return .notUpgraded
                            }
                            return .websocket(.init(channel: asyncChannel, nodeId: serverNodeId))
                        }
                    }
                    
                    var headers = HTTPHeaders()
                    headers.xKernelWebSocketsNodeIdentity = self.system.nodeId
                    headers.add(name: "Content-Type", value: "text/plain; charset=utf-8")
                    headers.add(name: "Content-Length", value: "0")
                    
                    let requestHead = HTTPRequestHead(
                        version: .http1_1,
                        method: .GET,
                        uri: "/",
                        headers: headers
                    )
                    
                    let clientUpgradeConfiguration = NIOTypedHTTPClientUpgradeConfiguration(
                        upgradeRequestHead: requestHead,
                        upgraders: [upgrader]
                    ) { $0.eventLoop.makeCompletedFuture { .notUpgraded } }
                    
                    let negotiationResultFuture = try channel.pipeline.syncOperations
                        .configureUpgradableHTTPClientPipeline(
                            configuration: .init(upgradeConfiguration: clientUpgradeConfiguration)
                        )
                    return negotiationResultFuture
                }
            }
            
            switch try await upgradeResult.get() {
            case let .websocket(serverConnection):
                setRemoteNodeId(serverConnection.nodeId)
                return serverConnection
            case .notUpgraded: throw KernelWebSockets.TypedError(.failedToUpgrade)
            }
                
        }

    }
}

