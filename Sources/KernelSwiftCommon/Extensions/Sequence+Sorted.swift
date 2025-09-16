//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 05/11/2024.
//

import Foundation

internal protocol _AnyComparableBox {
    var _canonicalBox: _AnyComparableBox { get }
    func _isEqual(to box: _AnyComparableBox) -> Bool
    func _precede(to box: _AnyComparableBox) -> Bool
    func _unbox<T: Comparable>() -> T?
}

extension _AnyComparableBox {
    var _canonicalBox: _AnyComparableBox {
        return self
    }
}

internal struct _ConcreteComparableBox<Base: Comparable>: _AnyComparableBox {
    internal var _baseComparable: Base
    
    internal init(_ base: Base) {
        self._baseComparable = base
    }
    
    internal func _unbox<T: Comparable>() -> T? {
        return (self as _AnyComparableBox as? _ConcreteComparableBox<T>)?._baseComparable
    }
    
    func _isEqual(to rhs: _AnyComparableBox) -> Bool {
        if let rhs: Base = rhs._unbox() {
            return _baseComparable == rhs
        }
        return false
    }
    
    func _precede(to rhs: _AnyComparableBox) -> Bool {
        if let rhs: Base = rhs._unbox() {
            return _baseComparable < rhs
        }
        return false
    }
}

public struct AnyComparable {
    internal var _box: _AnyComparableBox
    
    public init<C: Comparable>(_ base: C) {
        self._box = _ConcreteComparableBox(base)
    }
}

extension AnyComparable: Equatable {
    public static func == (lhs: AnyComparable, rhs: AnyComparable) -> Bool {
        return lhs._box._isEqual(to: rhs._box)
    }
}

extension AnyComparable: Comparable {
    public static func < (lhs: AnyComparable, rhs: AnyComparable) -> Bool {
        return lhs._box._precede(to: rhs._box)
    }
}

extension AnyComparable: CustomStringConvertible {
    public var description: String {
        return String(describing: _box._canonicalBox)
    }
}

extension Sequence {
    @inlinable public func sorted<K: Comparable>(_ keyPath: KeyPath<Element, K>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
    
    @inlinable public func sorted<K: Comparable>(_ keyPath: KeyPath<Element, K>, order: SortOrder = .forward) -> [Element] {
        switch order {
        case .forward: sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
        case .reverse: sorted { $0[keyPath: keyPath] > $1[keyPath: keyPath] }
        }
    }
    
    @inlinable public func sorted(_ propertyKey: String, order: SortOrder = .forward) -> [Element] where Element: DynamicPropertyAccessible {
        switch order {
        case .forward:
            sorted { el1, el2 in
                if let v1 = el1[dynamicMember: propertyKey], let v2 = el2[dynamicMember: propertyKey] {
                    v1 < v2
                }
                else { true }
            }
        case .reverse:
            sorted { el1, el2 in
                if let v1 = el1[dynamicMember: propertyKey], let v2 = el2[dynamicMember: propertyKey] {
                    v1 > v2
                }
                else { false }
            }
        }
    }
}
