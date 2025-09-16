//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/09/2023.
//

import Foundation

extension KernelASN1 {
    public enum ASN1Parser4ContentLength: Equatable, CustomDebugStringConvertible {
        case determinate(Int)
        case indeterminate
        
        public var length: Int {
            switch self {
            case let .determinate(length): length
            case .indeterminate: 0
            }
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.indeterminate, .indeterminate): true
            case (.determinate, .indeterminate): false
            case (.indeterminate, .determinate): false
            case let (.determinate(lhsLength), .determinate(rhsLength)): lhsLength == rhsLength
            }
        }
        
        public var debugDescription: String {
            switch self {
            case let .determinate(int): ".determinate(\(int))"
            case .indeterminate: ".indeterminate"
            }
        }
    }
}
