//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

extension KernelWebSockets.Nodes {
    public enum SystemNode {
        case client(Core.ServerAddress)
        case server(Core.ServerAddress)
        case local
    }
}
