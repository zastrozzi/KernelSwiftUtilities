//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 12/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelWebSockets.Core {
    public struct ReplyEnvelope: Sendable, Codable {
        public let callId: CallID
        public let sender: ActorID?
        public let value: Data
    }
}
