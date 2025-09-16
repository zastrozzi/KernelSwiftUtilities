//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelWebSockets.Core {
    public struct UserInfoKey: RawRepresentable, Equatable, Hashable, Sendable {
        public typealias RawValue = String
        
        public let rawValue: String
        
        public init?(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static func == (lhs: KernelWebSockets.Core.UserInfoKey, rhs: KernelWebSockets.Core.UserInfoKey) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        
        public func hash(into hasher: inout Hasher) {
            rawValue.hash(into: &hasher)
        }
    }
}
