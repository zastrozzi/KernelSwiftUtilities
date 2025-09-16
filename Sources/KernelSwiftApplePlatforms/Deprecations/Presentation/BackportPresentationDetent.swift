//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/09/2022.
//

import Foundation

public struct BackportPresentationDetent: Hashable, Comparable {
    public struct Identifier: RawRepresentable, Hashable {
        public var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static var medium: Identifier {
            .init(rawValue: "com.apple.UIKit.medium")
        }
        
        public static var large: Identifier {
            .init(rawValue: "com.apple.UIKit.large")
        }
    }
    
    public let id: Identifier
    
    public static var medium: BackportPresentationDetent {
        .init(id: .medium)
    }
    
    public static var large: BackportPresentationDetent {
        .init(id: .large)
    }
    
    fileprivate static var none: BackportPresentationDetent {
        return .init(id: .init(rawValue: ""))
    }
    
    public static func < (lhs: BackportPresentationDetent, rhs: BackportPresentationDetent) -> Bool {
        switch (lhs, rhs) {
        case (.large, .medium):
            return false
        default:
            return true
        }
    }
}
