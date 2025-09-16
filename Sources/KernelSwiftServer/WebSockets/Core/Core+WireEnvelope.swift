//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 12/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelWebSockets.Core {
    public enum WireEnvelope: Sendable, Codable {
        case call(RemoteCallEnvelope)
        case reply(ReplyEnvelope)
        case connectionClose
    }
}
