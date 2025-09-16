//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelWebSockets.Core {
    public enum RemoteNodeStatus {
        case current(KernelWebSockets.Nodes.RemoteNode)
        case future([TimedContinuation<KernelWebSockets.Nodes.RemoteNode>])
    }
}

