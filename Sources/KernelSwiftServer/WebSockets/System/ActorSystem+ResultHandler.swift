//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/02/2025.
//

import KernelSwiftCommon
import Distributed
import Vapor

extension KernelWebSockets.ActorSystem {
    public struct ResultHandler: DistributedTargetInvocationResultHandler {
        public typealias SerializationRequirement = any Codable
        
        let actorSystem: KernelWebSockets.ActorSystem
        let callId: KernelWebSockets.Core.CallID
        let system: KernelWebSockets.ActorSystem
        let remote: KernelWebSockets.Nodes.RemoteNode
        
        public func onReturn<Success: Codable>(value: Success) async throws {
            system.logger.withOp().with(callId).trace("returning \(value)")
            let encoder = JSONEncoder()
            encoder.userInfo[.actorSystemKey] = actorSystem
            let returnValue = try encoder.encode(value)
            let envelope: KernelWebSockets.Core.ReplyEnvelope = .init(callId: callId, sender: nil, value: returnValue)
            try await actorSystem.write(remote: remote, envelope: .reply(envelope))
        }
        
        public func onReturnVoid() async throws {
            system.logger.withOp().with(callId).trace("returning Void")
            let envelope: KernelWebSockets.Core.ReplyEnvelope = .init(callId: callId, sender: nil, value: "".data(using: .utf8)!)
            try await actorSystem.write(remote: remote, envelope: .reply(envelope))
        }
        
        public func onThrow<Err: Error>(error: Err) async throws {
            system.logger.withOp().with(callId).trace("throwing \(error)")
            let envelope: KernelWebSockets.Core.ReplyEnvelope = .init(callId: callId, sender: nil, value: "".data(using: .utf8)!)
            try await actorSystem.write(remote: remote, envelope: .reply(envelope))
        }
    }
}
