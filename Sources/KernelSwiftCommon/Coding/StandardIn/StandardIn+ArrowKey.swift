//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/11/2023.
//

import Foundation

extension UInt8.StandardIn {
    public enum ArrowKey: RawRepresentable, CaseIterable, Sendable, CustomStringConvertible {
        public typealias RawValue = UInt8.StandardIn
        
        case up
        case down
        case right
        case left
        case none
        
        public init(rawValue: UInt8.StandardIn) {
            switch rawValue {
            case EscapedSequence.arrowUp      : self = .up
            case EscapedSequence.arrowDown    : self = .down
            case EscapedSequence.arrowRight   : self = .right
            case EscapedSequence.arrowLeft    : self = .left
            default                           : self = .none
            }
        }
        
        public var rawValue: UInt8.StandardIn {
            switch self {
            case .up    : EscapedSequence.arrowUp
            case .down  : EscapedSequence.arrowDown
            case .right : EscapedSequence.arrowRight
            case .left  : EscapedSequence.arrowLeft
            case .none  : .oneByte(.ascii.null)
            }
        }
        
        public var description: String {
            switch self {
            case .up: "↑"
            case .down: "↓"
            case .right: "→"
            case .left: "←"
            case .none: ""
            }
        }
    }
}
