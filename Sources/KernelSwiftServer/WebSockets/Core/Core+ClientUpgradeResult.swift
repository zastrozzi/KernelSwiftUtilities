//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelWebSockets.Core {
    public enum ClientUpgradeResult: Sendable {
        case websocket(ServerConnection)
        case notUpgraded
    }
}
