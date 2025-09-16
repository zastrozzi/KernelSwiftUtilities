//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/02/2025.
//

import KernelSwiftCommon
import Vapor
import Distributed
import NIOCore
import NIOHTTP1
import NIOWebSocket
import NIO

extension KernelWebSockets.Managers {
    public final actor ServerManager: AnyManager {
        private let system: KernelWebSockets.ActorSystem
        private let underlyingAddress: Core.ServerAddress
        private var serverTask: ResilientTask?
        private var serverChannel: KernelWebSockets.ServerListeningChannel?
        private var pendingChannels: [EnvironmentContinuation<KernelWebSockets.ServerListeningChannel, Never>] = []
        
        public init(
            system: KernelWebSockets.ActorSystem,
            on address: Core.ServerAddress
        ) {
            self.system = system
            self.underlyingAddress = address
        }
        
        public func localPort() async throws -> Int {
            try await requireChannel().channel.localAddress?.port ?? 0
        }
        
        public func address() async throws -> Core.ServerAddress {
            try await underlyingAddress.withPort(localPort())
        }
        
        public func requireChannel() async throws -> KernelWebSockets.ServerListeningChannel {
            if let serverChannel { serverChannel }
            else { await withCheckedContinuation { pendingChannels.append($0) } }
        }
        
        public func cancel() {
            serverChannel = nil
            serverTask?.cancel()
            serverTask = nil
        }
        
        public func connect(host: String, port: Int) {
            cancel()
            serverTask = ResilientTask { initialised in
                try await TaskPath.with(name: "server connection") {
                    let channel = try await self.openServerChannel(host: host, port: port)
                    await self.setChannel(channel)
                    await initialised()
                    try await withThrowingDiscardingTaskGroup { group in
                        try await channel.executeThenClose { inbound, _ in
                            for try await upgradeResult in inbound {
                                group.addTask { await self.system.handleUpgradeResult(upgradeResult) }
                            }
                        }
                    }
                }
            }
        }
        
        public func openServerChannel(host: String, port: Int) async throws -> KernelWebSockets.ServerListeningChannel {
            try await ServerBootstrap(group: MultiThreadedEventLoopGroup.singleton)
                .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
                .bind(host: host, port: port) { channel in
                    channel.eventLoop.makeCompletedFuture {
                        let upgrader = NIOTypedWebSocketServerUpgrader<Core.ServerUpgradeResult>(
                            shouldUpgrade: { channel, _ in
                                var headers = HTTPHeaders()
                                headers.xKernelWebSocketsNodeIdentity = self.system.nodeId
                                return channel.eventLoop.makeSucceededFuture(headers)
                            },
                            upgradePipelineHandler: { channel, requestHead in
                                channel.eventLoop.makeCompletedFuture {
                                    let remoteNodeId = requestHead.headers.xKernelWebSocketsNodeIdentity!
                                    let asyncChannel = try KernelWebSockets.AgentChannel(wrappingChannelSynchronously: channel)
                                    return .websocket(asyncChannel, remoteNodeId)
                                }
                            }
                        )
                        let serverUpgradeConfiguration = NIOTypedHTTPServerUpgradeConfiguration(upgraders: [upgrader]) { channel in
                                channel.eventLoop
                                    .makeCompletedFuture {
                                        try channel.pipeline.syncOperations.addHandler(
                                            KernelWebSockets.HTTPByteBufferResponsePartHandler()
                                        )
                                        let asyncChannel = try KernelWebSockets.ServerHTTPChannel(wrappingChannelSynchronously: channel)
                                        return Core.ServerUpgradeResult.notUpgraded(asyncChannel)
                                    }
                            }
                        
                        return try channel.pipeline.syncOperations
                            .configureUpgradableHTTPServerPipeline(
                                configuration: .init(upgradeConfiguration: serverUpgradeConfiguration)
                            )
                    }
                }
        }
        
        private func setChannel(_ channel: KernelWebSockets.ServerListeningChannel) {
            serverChannel = channel
            for pending in pendingChannels { pending.resume(returning: channel) }
            pendingChannels.removeAll()
        }
        
        
    }
}
