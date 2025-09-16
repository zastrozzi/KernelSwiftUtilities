//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/09/2023.
//

import Foundation

extension KernelASN1 {
    public enum ASN1Parser4TreeLevel: Equatable, CustomDebugStringConvertible {
        case root
        case child(ancestorCount: Int, parentId: UUID)
    
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.root, .root): true
            case (.child, .root): false
            case (.root, .child): false
            case let (.child(lhsAncestorCount, lhsParentId), .child(rhsAncestorCount, rhsParentId)):
                lhsAncestorCount == rhsAncestorCount &&
                lhsParentId == rhsParentId
            }
        }
        
        public var ancestors: Int {
            switch self {
            case .root: 0
            case let .child(ancestorCount, _): ancestorCount
            }
        }
        
        public var parentId: UUID? {
            switch self {
            case .root: nil
            case let .child(_, id): id
            }
        }
        
        public var debugDescription: String {
            switch self {
            case let .child(ancestorCount, parentId): ".child(\(ancestorCount)|\(parentId.uuidString))"
            case .root: ".root"
            }
        }
    }
}
