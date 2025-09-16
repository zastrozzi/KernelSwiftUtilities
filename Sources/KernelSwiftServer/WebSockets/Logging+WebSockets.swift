//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import Foundation
@preconcurrency import Distributed

extension Logger {
    public func with(level: Logger.Level) -> Logger {
        var logger = self
        logger.logLevel = level
        return logger
    }
    
    func with(_ actorID: KernelWebSockets.Core.ActorIdentity) -> Logger {
        var logger = self
        logger[metadataKey: "actorID"] = .stringConvertible(actorID)
        return logger
    }
    
    func with(_ callID: KernelWebSockets.Core.CallID) -> Logger {
        var logger = self
        logger[metadataKey: "callID"] = .stringConvertible(callID)
        return logger
    }
    
    func with(_ channel: KernelWebSockets.AgentChannel) -> Logger {
        var logger = self
        logger[metadataKey: "channel"] = .string(channel.remoteDescription)
        return logger
    }
    
    func with(target: String) -> Logger {
        with(RemoteCallTarget(target))
    }
    
    func with(_ target: RemoteCallTarget) -> Logger {
        var logger = self
        logger[metadataKey: "target"] = .stringConvertible(target)
        return logger
    }
    
    func with(sender: KernelWebSockets.Core.ActorIdentity?) -> Logger {
        guard let sender else { return self }
        var logger = self
        logger[metadataKey: "sender"] = .stringConvertible(sender)
        return logger
    }
    
    func withOp(_ op: String = #function) -> Logger {
        var logger = self
        logger[metadataKey: "op"] = .string(op)
        return logger
    }
    
    func with(_ envelope: KernelWebSockets.Core.RemoteCallEnvelope) -> Logger {
        with(target: envelope.invocationTarget)
            .with(envelope.recipient)
            .with(envelope.callId)
    }
    
    func with(_ args: [Data]) -> Logger {
        var logger = self
        logger[metadataKey: "args"] = .string(
            "(" + args.map { String(data: $0, encoding: .utf8) ?? "???" }.joined(separator: ", ") + ")"
        )
        return logger
    }
}
