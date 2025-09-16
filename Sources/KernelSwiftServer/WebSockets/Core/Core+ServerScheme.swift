//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelWebSockets.Core {
    public enum ServerScheme: Codable, Equatable, Hashable, Sendable {
        case secure
        case insecure
        
        
        public var socketScheme: String {
            switch self {
            case .secure: "wss"
            case .insecure: "ws"
            }
        }
        
        public var webScheme: String {
            switch self {
            case .secure: "https"
            case .insecure: "http"
            }
        }
        
        public var port: Int {
            switch self {
            case .secure: 443
            case .insecure: 80
            }
        }
    }
}
