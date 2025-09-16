//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 12/02/2025.
//

import Foundation

@dynamicMemberLookup
public protocol DynamicPropertyAccessible {
    subscript(dynamicMember member: String) -> AnyComparable? { get }
}

extension DynamicPropertyAccessible {
    public subscript(dynamicMember member: String) -> AnyComparable? {
        let mirror = Mirror(reflecting: self)
        let components = member.split(separator: ".").map { String($0) }
        guard let firstComponent = components.first else {
            return nil
        }
        
        for child in mirror.children {
            if let label = child.label, label == firstComponent {
                if components.count == 1 {
                    if let value = child.value as? (any Comparable) {
                        return .init(value)
                    }
                } else if let nestedChild = child.value as? DynamicPropertyAccessible {
                    let remainingPath = components.dropFirst().joined(separator: ".")
                    return nestedChild[dynamicMember: remainingPath]
                }
            }
        }
        return nil
    }
}
