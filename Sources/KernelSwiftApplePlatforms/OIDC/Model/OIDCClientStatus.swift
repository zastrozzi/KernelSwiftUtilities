//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelAppUtils.OIDC {
    public enum OIDCClientStatus: Equatable, CustomDebugStringConvertible, Hashable {
        case notAuthenticated
        case authenticationRequested(context: UUID)
        case tokenRequested(context: UUID)
        
        public var debugDescription: String {
            switch self {
            case .notAuthenticated: "notAuthenticated"
            case .authenticationRequested(let context): "authenticationRequested - (context: \(context.uuidString))"
            case .tokenRequested(let context): "tokenRequested - (context: \(context.uuidString))"
            }
        }
        
        public var context: UUID? {
            switch self {
            case let .authenticationRequested(context): context
            case let .tokenRequested(context): context
            default: nil
            }
        }
    }
}
