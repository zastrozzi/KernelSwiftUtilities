//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import Foundation

@_documentation(visibility: private)
public protocol _KernelWebSocketsAnyManager: Sendable {
    func cancel() async
}

extension KernelWebSockets.Managers {
    public typealias AnyManager = _KernelWebSocketsAnyManager
}
