//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelWebSockets.Core {
    public enum ServerUpgradeResult: Sendable {
        case websocket(KernelWebSockets.AgentChannel, NodeIdentity)
        case notUpgraded(KernelWebSockets.ServerHTTPChannel)
    }
}
