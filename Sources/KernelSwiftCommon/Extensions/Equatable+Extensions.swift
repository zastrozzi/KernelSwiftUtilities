//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/08/2023.
//

import Foundation

extension Equatable {
    public func equals(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else { return other.isExactlyEqual(self) }
        if let selfAsDate = self as? Date, let otherAsDate = other as? Date {
            return abs(selfAsDate.distance(to: otherAsDate)) < 0.1
        }
        return self == other
    }
    
    public func equals(_ other: (any Equatable)?) -> Bool {
        guard let other else { return false }
        return self.equals(other)
    }
    
    private func isExactlyEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else { return false }
        if let selfAsDate = self as? Date, let otherAsDate = other as? Date {
            return abs(selfAsDate.distance(to: otherAsDate)) < 0.1
        }
        return self == other
    }
}

extension Optional where Wrapped: Equatable {
    public func equals(_ other: (any Equatable)?) -> Bool {
        guard let self else { return other != nil }
        guard let other else { return false }
        return self.equals(other)
    }
    
    public func equals(_ other: any Equatable) -> Bool {
        guard let self else { return false }
        return self.equals(other)
    }
}
