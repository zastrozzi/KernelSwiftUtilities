//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelWebSockets.Core {
    public struct ServerAddress: Codable, Equatable, Hashable, Sendable, ExpressibleByStringLiteral, CustomStringConvertible {
        public var scheme: ServerScheme
        public var host: String
        public var port: Int
        public var path: String
        
        public init(
            scheme: ServerScheme,
            host: String = "localhost",
            port: Int? = nil,
            path: String = "/"
        ) {
            self.scheme = scheme
            self.host = host
            if let port, port >= 0 { self.port = port }
            else { self.port = scheme.port }
            self.path = path
        }
        
        public init?(url: URL) {
            guard let comp = URLComponents(url: url, resolvingAgainstBaseURL: true), let host = comp.host else {
                return nil
            }
            switch comp.scheme {
            case "http", "ws": self.scheme = .insecure
            case "https", "wss": self.scheme = .secure
            default: return nil
            }
            self.host = host
            self.port = comp.port ?? scheme.port
            self.path = comp.path.isEmpty ? "/" : comp.path
        }
        
        public init?(string: String) {
            guard let url = URL(string: string) else { return nil }
            self.init(url: url)
        }
        
        public init(stringLiteral value: String) {
            guard let address = ServerAddress(string: value) else {
                fatalError("Invalid ServerAddress URL: \(value)")
            }
            self = address
        }
        
        public var description: String {
            "\(scheme.socketScheme)://\(host):\(port)\(path)"
        }
        
        public func withPort(_ newPort: Int) -> ServerAddress {
            var address = self
            address.port = newPort
            return address
        }
    }
}
