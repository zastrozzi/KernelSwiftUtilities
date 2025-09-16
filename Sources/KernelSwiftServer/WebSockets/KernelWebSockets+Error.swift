//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import KernelSwiftCommon
import Vapor
import Distributed

extension KernelWebSockets: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case missingReplyContinuation
        case resolveFailedToMatchActorType
        case noPeers
        case insufficientEnvelopeArgs
        case decodeFailed
        case decodeError
        case resolveFailed
        case missingNodeId
        case noRemoteNode
        case failedToUpgrade
        case secureServerNotSupported
        case notInDistributedActor
        case timeoutWaitingForNode
        
        public var httpStatus: KernelSwiftCommon.Networking.HTTP.ResponseStatus {
//            switch self {
//            case .missingReplyContinuation: .internalServerError
//            case .resolveFailedToMatchActorType: .internalServerError
//                
//            }
            .internalServerError
        }
        
        public var httpReason: String {
            switch self {
            case .missingReplyContinuation: "Missing Reply Continuation"
            case .resolveFailedToMatchActorType: "Resolve Failed to Match Actor Type"
            case .noPeers: "No Peers"
            case .insufficientEnvelopeArgs: "Insufficient Envelope Args"
            case .decodeError: "Decode Error"
            case .decodeFailed: "Decode Failed"
            case .resolveFailed: "Resolve Failed"
            case .missingNodeId: "Missing Node ID"
            case .noRemoteNode: "No Remote Node"
            case .failedToUpgrade: "Failed To Upgrade"
            case .secureServerNotSupported: "Secure Server Not Supported"
            case .notInDistributedActor: "Not In Distributed Actor"
            case .timeoutWaitingForNode: "Timeout Waiting For Node"
            }
        }
    }
}

extension KernelSwiftCommon.TypedError<KernelWebSockets.ErrorTypes>: DistributedActorSystemError {}

extension KernelSwiftCommon.TypedError<KernelWebSockets.ErrorTypes> {
    public static func missingReplyContinuation(
        _ callId: KernelWebSockets.Core.CallID
    ) -> KernelWebSockets.TypedError {
        .init(.missingReplyContinuation, reason: "Missing Reply Continuation for Call ID: \(callId)", arguments: [callId])
    }
    
    public static func insufficientEnvelopeArgs(
        _ expected: Any.Type
    ) -> KernelWebSockets.TypedError {
        .init(.insufficientEnvelopeArgs, arguments: [expected])
    }
    
    public static func resolveFailedToMatchActorType(
        found: Any.Type,
        expected: Any.Type
    ) -> KernelWebSockets.TypedError {
        .init(.resolveFailedToMatchActorType, arguments: [found, expected])
    }
    
    public static func decodeFailed(
        _ message: Data,
        error: Error
    ) -> KernelWebSockets.TypedError {
        .init(.decodeFailed, arguments: [message, error])
    }
    
    public static func decodeError(
        _ error: Error
    ) -> KernelWebSockets.TypedError {
        .init(.decodeError, arguments: [error])
    }
    
    public static func resolveFailed(
        _ actorId: KernelWebSockets.Core.ActorID
    ) -> KernelWebSockets.TypedError {
        .init(.resolveFailed, arguments: [actorId])
    }
    
    public static func missingNodeId(
        _ actorId: KernelWebSockets.Core.ActorID
    ) -> KernelWebSockets.TypedError {
        .init(.missingNodeId, arguments: [actorId])
    }
    
    public static func timeoutWaitingForNode(
        _ nodeId: KernelWebSockets.Core.NodeIdentity?,
        timeout: Duration
    ) -> KernelWebSockets.TypedError {
        .init(.timeoutWaitingForNode, arguments: [nodeId, timeout])
    }
}
