//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import KernelSwiftCommon
import Vapor
import Distributed
import NIOWebSocket

extension KernelWebSockets {
    public final class ActorSystem: DistributedActorSystem, @unchecked Sendable {
        @_documentation(visibility: private)
        public typealias Core = KernelWebSockets.Core
        
        @_documentation(visibility: private)
        public typealias Nodes = KernelWebSockets.Nodes
        
        @_documentation(visibility: private)
        public typealias Managers = KernelWebSockets.Managers
        
        public typealias ActorID = Core.ActorID
        public typealias InvocationEncoder = NIOInvocationEncoder
        public typealias InvocationDecoder = NIOInvocationDecoder
        public typealias SerializationRequirement = any Codable
        public typealias OnDemandResolver = (ActorID) -> (any DistributedActor)?
        
        @TaskLocal internal static var locked: Bool = false
        @TaskLocal internal static var actorIdHint: ActorID?
        public static let defaultLogger = Logger(label: "kernel.websockets")
        
        public let nodeId: Core.NodeIdentity
        public let logger: Logger
        private let pendingReplies = Managers.PendingRepliesManager()
        
        internal var managers: [Managers.AnyManager] = []
        private var remoteNodes: Nodes.RemoteNodeDirectory
        
        internal let lock = NSLock()
        internal var managedActors: Dictionary<ActorID, any DistributedActor> = [:]
        internal var onDemandResolver: OnDemandResolver?
        
        public var monitor: ResilientTask.MonitorFunction?
        
        public init(
            id: Core.NodeIdentity = .random(),
            logger: Logger = defaultLogger,
            connectionTimeout: Duration = .seconds(5)
        ) {
            self.nodeId = id
            self.logger = logger
            self.remoteNodes = .init(timeout: connectionTimeout)
        }
        
        func dispatchIncomingFrames(
            channel: KernelWebSockets.AgentChannel,
            remoteNodeId: Core.NodeIdentity
        ) async throws {
            try await Nodes.RemoteNode.withRemoteNode(nodeId: remoteNodeId, channel: channel) { remoteNode in
                logger.trace("Opened RemoteNode for \(remoteNodeId) on \(TaskPath.current)")
                await remoteNodes.opened(remoteNode)
                
                try await TaskPath.with(name: "remoteNode") {
                    for try await frame in remoteNode.inbound {
                        switch frame.opcode {
                        case .connectionClose:
                            logger.trace("Received close")
                            var data = frame.unmaskedData
                            let closeDataCode = data.readSlice(length: 2) ?? ByteBuffer()
                            let closeFrame: WebSocketFrame = .init(fin: true, opcode: .connectionClose, data: closeDataCode)
                            try await remoteNode.outbound.write(closeFrame)
                            
                        case .text:
                            var data = frame.unmaskedData
                            let text = data.getString(at: 0, length: data.readableBytes) ?? ""
                            logger.withOp().trace("Received: \(text), from: \(String(describing: channel.channel.remoteAddress))")
                            await decodeAndDeliver(data: &data, from: remoteNode)
                            
                        case .ping:
                            logger.trace("Received ping")
                            var frameData = frame.data
                            let maskingKey = frame.maskKey
                            if let maskingKey { frameData.webSocketUnmask(maskingKey) }
                            let responseFrame: WebSocketFrame = .init(fin: true, opcode: .pong, data: frameData)
                            try await remoteNode.outbound.write(responseFrame)
                            
                        case .pong: logger.trace("Received pong")
                        case .binary, .continuation: break
                        default: await closeOnError(channel: channel)
                        }
                    }
                }
                logger.trace("Closing RemoteNode for \(remoteNodeId) on \(TaskPath.current)")
                await remoteNodes.closing(remoteNode)
            }
        }
        
        public func getNodeInfo(key: Core.UserInfoKey) async throws -> (any Sendable)? {
            guard let remoteNode = Nodes.RemoteNode.current else { throw TypedError(.notInDistributedActor) }
            return await remoteNode.getUserInfo(key: key)
        }
        
        public func setNodeInfo(key: Core.UserInfoKey, value: any Sendable) async throws {
            guard let remoteNode = Nodes.RemoteNode.current else { throw TypedError(.notInDistributedActor) }
            await remoteNode.setUserInfo(key: key, value: value)
        }
        
        public func makeLocalActor<Act>(
            id: ActorID,
            _ factory: () -> Act
        ) -> Act where Act: DistributedActor, Act.ActorSystem == KernelWebSockets.ActorSystem {
            Self.$actorIdHint.withValue(id.with(nodeId)) { factory() }
        }
        
        public func makeLocalActor<Act>(
            _ factory: () -> Act
        ) -> Act where Act: DistributedActor, Act.ActorSystem == KernelWebSockets.ActorSystem {
            Self.$actorIdHint.withValue(.random(for: Act.self, node: nodeId)) { factory() }
        }
        
        public func remoteCall<Act, Err, Res>(
            on actor: Act,
            target: RemoteCallTarget,
            invocation: inout InvocationEncoder,
            throwing _: Err.Type,
            returning _: Res.Type
        ) async throws -> Res where Act: DistributedActor, Act.ID == ActorID, Err: Error, Res: Codable {
            let taggedLogger = logger.withOp().with(actor.id).with(target)
            taggedLogger.info("remoteCall")
            taggedLogger.trace("Call to: \(actor.id), target: \(target), target.identifier: \(target.identifier)")
            let remoteNode = try await remoteNodes.remoteNode(for: actor.id)
            taggedLogger.trace("Prepare [\(target)] call...")
            let localInvocation = invocation
            let targetIdentifier = target.identifier
            let genericSubs = localInvocation.genericSubs
            let argumentData = localInvocation.argumentData
            let replyData = try await pendingReplies.sendMessage { callId in
                let callEnvelope: Core.RemoteCallEnvelope = .init(
                    callId: callId,
                    recipient: actor.id,
                    invocationTarget: targetIdentifier,
                    genericSubs: genericSubs,
                    args: argumentData
                )
                let wireEnvelope: Core.WireEnvelope = .call(callEnvelope)
                taggedLogger.trace("Write envelope: \(wireEnvelope)")
                try await remoteNode.write(forSystem: self, envelope: wireEnvelope)
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.userInfo[.actorSystemKey] = self
                
                return try decoder.decode(Res.self, from: replyData)
            }
            catch {
                throw TypedError.decodeError(error)
            }
        }
        
        public func remoteCallVoid<Act, Err>(
            on actor: Act,
            target: RemoteCallTarget,
            invocation: inout InvocationEncoder,
            throwing _: Err.Type
        ) async throws where Act: DistributedActor, Act.ID == ActorID, Err: Error {
            let taggedLogger = logger.withOp().with(actor.id)
            taggedLogger.trace("Call to: \(actor.id), target: \(target), target.identifier: \(target.identifier)")
            
            let remoteNode = try await remoteNodes.remoteNode(for: actor.id)
            let localInvocation = invocation
            let targetIdentifier = target.identifier
            let genericSubs = localInvocation.genericSubs
            let argumentData = localInvocation.argumentData
            
            taggedLogger.trace("Prepare [\(target)] call...")
            _ = try await pendingReplies.sendMessage { callId in
                let callEnvelope: Core.RemoteCallEnvelope = .init(
                    callId: callId,
                    recipient: actor.id,
                    invocationTarget: targetIdentifier,
                    genericSubs: genericSubs,
                    args: argumentData
                )
                let wireEnvelope: Core.WireEnvelope = .call(callEnvelope)
                taggedLogger.trace("Write envelope: \(wireEnvelope)")
                try await remoteNode.write(forSystem: self, envelope: wireEnvelope)
            }
            
            taggedLogger.trace("COMPLETED CALL: \(target)")
        }
        
        public func decodeAndDeliver(
            data: inout ByteBuffer,
            from remote: Nodes.RemoteNode
        ) async {
            let decoder = JSONDecoder()
            decoder.userInfo[.actorSystemKey] = self
            let taggedLogger = logger.withOp()
            
            do {
                let wireEnvelope = try data.readJSONDecodable(Core.WireEnvelope.self, length: data.readableBytes)
                
                switch wireEnvelope {
                case let .call(remoteCallEnvelope):
                    receiveInboundCall(envelope: remoteCallEnvelope, on: remote)
                case let .reply(replyEnvelope):
                    try await receiveInboundReply(envelope: replyEnvelope)
                case .none, .connectionClose:
                    taggedLogger.error("Failed decoding: \(data); decoded empty")
                }
            }
            catch { taggedLogger.error("Failed decoding: \(data), error: \(error)") }
            taggedLogger.trace("done")
        }
        
        public func receiveInboundCall(
            envelope: Core.RemoteCallEnvelope,
            on remote: Nodes.RemoteNode
        ) {
            let taggedLogger = logger.withOp().with(envelope)
            taggedLogger.info("receiveInboundCall")
            taggedLogger.with(envelope.args).debug("args")
            Task {
                taggedLogger.trace("Calling resolveAny(id: \(envelope.recipient))")
                guard let anyRecipient = resolveAny(id: envelope.recipient) else {
                    taggedLogger.warning("failed to resolve \(envelope.recipient)")
                    return
                }
                taggedLogger.trace("Recipient: \(anyRecipient)")
                let target = RemoteCallTarget(envelope.invocationTarget)
                taggedLogger.trace("Target: \(target)")
                taggedLogger.trace("Target.identifier: \(target.identifier)")
                let handler = ResultHandler(actorSystem: self, callId: envelope.callId, system: self, remote: remote)
                taggedLogger.trace("Handler: \(anyRecipient)")
                
                do {
                    var decoder = NIOInvocationDecoder(system: self, envelope: envelope)
                    func doExecuteDistributedTarget<Act: DistributedActor>(recipient: Act) async throws {
                        taggedLogger.trace("executeDistributedTarget")
                        try await executeDistributedTarget(
                            on: recipient,
                            target: target,
                            invocationDecoder: &decoder,
                            handler: handler
                        )
                    }
                    try await _openExistential(anyRecipient, do: doExecuteDistributedTarget)
                }
                catch {
                    taggedLogger
                        .error("failed to executeDistributedTarget [\(target)] on [\(anyRecipient)], error: \(error)")
                    try? await handler.onThrow(error: error)
                }
            }
        }
        
        public func receiveInboundReply(envelope: Core.ReplyEnvelope) async throws {
            let taggedLogger = logger.withOp().with(envelope.callId).with(sender: envelope.sender)
            taggedLogger.info("receiveInboundReply")
            try await pendingReplies.receivedReply(for: envelope.callId, data: envelope.value)
        }
        
        internal func write(
            remote: Nodes.RemoteNode,
            envelope: Core.WireEnvelope
        ) async throws {
            let taggedLogger = logger.withOp()
            taggedLogger.trace("Unwrapping WireEnvelope")
            
            switch envelope {
            case .connectionClose:
                var data = remote.channel.channel.allocator.buffer(capacity: 2)
                data.write(webSocketErrorCode: .protocolError)
                let frame: WebSocketFrame = .init(fin: true, opcode: .connectionClose, data: data)
                try await remote.outbound.write(frame)
                
            case .reply, .call:
                let encoder = JSONEncoder()
                encoder.userInfo[.actorSystemKey] = self
                
                do {
                    var data = ByteBuffer()
                    try data.writeJSONEncodable(envelope, encoder: encoder)
                    taggedLogger.trace("Write: \(envelope)")
                    let frame: WebSocketFrame = .init(fin: true, opcode: .text, data: data)
                    try await remote.outbound.write(frame)
                }
                catch {
                    taggedLogger.error("Failed to serialise call [\(envelope)], error: \(error)")
                }
            }
        }
    }
}
