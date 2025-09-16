//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 12/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelWebSockets.Core {
    public struct RemoteCallEnvelope: Sendable, Codable {
        public let callId: CallID
        public let recipient: ActorIdentity
        public let invocationTarget: String
        public let genericSubs: [String]
        public let args: [Data]
    }
}
